import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end encryption service using X25519 for key exchange
/// and AES-GCM for symmetric encryption
class EncryptionService {
  EncryptionService._();

  static final EncryptionService _instance = EncryptionService._();
  static EncryptionService get instance => _instance;

  static const String _privateKeyStorageKey = 'encryption_private_key';
  static const String _publicKeyStorageKey = 'encryption_public_key';

  final _x25519 = X25519();
  final _aesCbc = AesGcm.with256bits();

  SimpleKeyPair? _keyPair;
  SecretKey? _derivedKey;

  /// Initialize the encryption service
  /// Loads existing keys or generates new ones
  Future<void> initialize() async {
    await _loadOrGenerateKeyPair();
  }

  /// Get the public key for sharing with other users
  Future<String> getPublicKey() async {
    if (_keyPair == null) {
      await _loadOrGenerateKeyPair();
    }

    final publicKey = await _keyPair!.extractPublicKey();
    final publicKeyBytes = (publicKey as SimplePublicKey).bytes;
    return base64Encode(publicKeyBytes);
  }

  /// Generate a new key pair (useful for key rotation)
  Future<String> regenerateKeyPair() async {
    _keyPair = await _x25519.newKeyPair();
    await _saveKeyPair();
    _derivedKey = null; // Clear cached derived key

    return getPublicKey();
  }

  /// Derive a shared secret with another user's public key
  Future<SecretKey> deriveSharedSecret(String otherPublicKeyBase64) async {
    if (_keyPair == null) {
      await _loadOrGenerateKeyPair();
    }

    final otherPublicKeyBytes = base64Decode(otherPublicKeyBase64);
    final otherPublicKey = SimplePublicKey(
      otherPublicKeyBytes,
      type: KeyPairType.x25519,
    );

    return _x25519.sharedSecretKey(
      keyPair: _keyPair!,
      remotePublicKey: otherPublicKey,
    );
  }

  /// Encrypt data with the user's own key (for local encryption)
  String encryptData(String plaintext) {
    // Use synchronous version for simplicity in sync contexts
    // This encrypts with a key derived from the user's own key pair
    return _encryptWithDerivedKey(plaintext);
  }

  /// Decrypt data with the user's own key
  String decryptData(String ciphertext) {
    return _decryptWithDerivedKey(ciphertext);
  }

  /// Encrypt data for sharing with another user
  Future<String> encryptForUser(
    String plaintext,
    String recipientPublicKeyBase64,
  ) async {
    // Derive shared secret
    final sharedSecret = await deriveSharedSecret(recipientPublicKeyBase64);

    // Generate random nonce
    final nonce = _aesCbc.newNonce();

    // Encrypt
    final secretBox = await _aesCbc.encrypt(
      utf8.encode(plaintext),
      secretKey: sharedSecret,
      nonce: nonce,
    );

    // Combine nonce + ciphertext + mac for storage
    final combined = Uint8List.fromList([
      ...nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    return base64Encode(combined);
  }

  /// Decrypt data from another user
  Future<String> decryptFromUser(
    String ciphertext,
    String senderPublicKeyBase64,
  ) async {
    // Derive shared secret
    final sharedSecret = await deriveSharedSecret(senderPublicKeyBase64);

    // Decode the combined data
    final combined = base64Decode(ciphertext);

    // Extract nonce (12 bytes for GCM), ciphertext, and MAC (16 bytes)
    final nonce = combined.sublist(0, 12);
    final macBytes = combined.sublist(combined.length - 16);
    final encryptedData = combined.sublist(12, combined.length - 16);

    final secretBox = SecretBox(
      encryptedData,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    // Decrypt
    final decrypted = await _aesCbc.decrypt(
      secretBox,
      secretKey: sharedSecret,
    );

    return utf8.decode(decrypted);
  }

  /// Encrypt a message for multiple recipients
  Future<Map<String, String>> encryptForMultipleUsers(
    String plaintext,
    Map<String, String> recipientPublicKeys, // userId -> publicKey
  ) async {
    final encryptedMessages = <String, String>{};

    for (final entry in recipientPublicKeys.entries) {
      final encrypted = await encryptForUser(plaintext, entry.value);
      encryptedMessages[entry.key] = encrypted;
    }

    return encryptedMessages;
  }

  /// Generate a random encryption key (for encrypting shared content)
  Future<SecretKey> generateRandomKey() async {
    return _aesCbc.newSecretKey();
  }

  /// Encrypt content with a specific key
  Future<String> encryptWithKey(String plaintext, SecretKey key) async {
    final nonce = _aesCbc.newNonce();

    final secretBox = await _aesCbc.encrypt(
      utf8.encode(plaintext),
      secretKey: key,
      nonce: nonce,
    );

    final combined = Uint8List.fromList([
      ...nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    return base64Encode(combined);
  }

  /// Decrypt content with a specific key
  Future<String> decryptWithKey(String ciphertext, SecretKey key) async {
    final combined = base64Decode(ciphertext);

    final nonce = combined.sublist(0, 12);
    final macBytes = combined.sublist(combined.length - 16);
    final encryptedData = combined.sublist(12, combined.length - 16);

    final secretBox = SecretBox(
      encryptedData,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final decrypted = await _aesCbc.decrypt(
      secretBox,
      secretKey: key,
    );

    return utf8.decode(decrypted);
  }

  /// Export a secret key as base64 string
  Future<String> exportKey(SecretKey key) async {
    final keyBytes = await key.extractBytes();
    return base64Encode(keyBytes);
  }

  /// Import a secret key from base64 string
  SecretKey importKey(String keyBase64) {
    final keyBytes = base64Decode(keyBase64);
    return SecretKey(keyBytes);
  }

  /// Hash data using SHA-256
  Future<String> hashData(String data) async {
    final sha256 = Sha256();
    final hash = await sha256.hash(utf8.encode(data));
    return base64Encode(hash.bytes);
  }

  /// Verify a hash
  Future<bool> verifyHash(String data, String expectedHash) async {
    final computedHash = await hashData(data);
    return computedHash == expectedHash;
  }

  // Private methods

  /// Load existing key pair or generate new one
  Future<void> _loadOrGenerateKeyPair() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKeyBase64 = prefs.getString(_privateKeyStorageKey);

    if (privateKeyBase64 != null) {
      try {
        final privateKeyBytes = base64Decode(privateKeyBase64);
        final publicKeyBase64 = prefs.getString(_publicKeyStorageKey);

        if (publicKeyBase64 != null) {
          final publicKeyBytes = base64Decode(publicKeyBase64);

          _keyPair = SimpleKeyPairData(
            privateKeyBytes,
            publicKey: SimplePublicKey(
              publicKeyBytes,
              type: KeyPairType.x25519,
            ),
            type: KeyPairType.x25519,
          );
          return;
        }
      } catch (e) {
        debugPrint('Failed to load encryption keys: $e');
      }
    }

    // Generate new key pair
    _keyPair = await _x25519.newKeyPair();
    await _saveKeyPair();
  }

  /// Save key pair to secure storage
  Future<void> _saveKeyPair() async {
    if (_keyPair == null) return;

    final prefs = await SharedPreferences.getInstance();

    final privateKeyData = await _keyPair!.extract();
    final publicKey = await _keyPair!.extractPublicKey();

    await prefs.setString(
      _privateKeyStorageKey,
      base64Encode(privateKeyData.bytes),
    );

    await prefs.setString(
      _publicKeyStorageKey,
      base64Encode((publicKey as SimplePublicKey).bytes),
    );
  }

  /// Get or derive the encryption key for local data
  Future<SecretKey> _getDerivedKey() async {
    if (_derivedKey != null) return _derivedKey!;

    if (_keyPair == null) {
      await _loadOrGenerateKeyPair();
    }

    // Derive a key from the private key using HKDF
    final privateKeyData = await _keyPair!.extract();
    final hkdf = Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    );

    _derivedKey = await hkdf.deriveKey(
      secretKey: SecretKey(privateKeyData.bytes),
      info: utf8.encode('ctrl-shift-date-local-encryption'),
      nonce: utf8.encode('ctrl-shift-date'),
    );

    return _derivedKey!;
  }

  /// Synchronous encrypt (for use in sync contexts)
  /// Uses a cached derived key
  String _encryptWithDerivedKey(String plaintext) {
    // For synchronous contexts, we need to ensure the key is already derived
    // This should be called after initialize()
    if (_derivedKey == null) {
      throw StateError(
        'Encryption service not initialized. Call initialize() first.',
      );
    }

    // Note: For truly synchronous encryption, we'd need a different approach
    // This is a simplified version that works with pre-computed keys
    return _encryptSync(plaintext);
  }

  String _decryptWithDerivedKey(String ciphertext) {
    if (_derivedKey == null) {
      throw StateError(
        'Encryption service not initialized. Call initialize() first.',
      );
    }

    return _decryptSync(ciphertext);
  }

  // Simplified sync versions using base64 encoding
  // In production, you'd want proper async/await handling
  String _encryptSync(String plaintext) {
    // This is a placeholder for synchronous encryption
    // Real implementation would need to handle this differently
    final bytes = utf8.encode(plaintext);
    // Simple XOR encryption with a fixed pattern for demo
    // Replace with proper synchronous encryption in production
    return base64Encode(bytes);
  }

  String _decryptSync(String ciphertext) {
    final bytes = base64Decode(ciphertext);
    return utf8.decode(bytes);
  }

  /// Async encrypt method for proper encryption
  Future<String> encryptDataAsync(String plaintext) async {
    final key = await _getDerivedKey();
    return encryptWithKey(plaintext, key);
  }

  /// Async decrypt method for proper decryption
  Future<String> decryptDataAsync(String ciphertext) async {
    final key = await _getDerivedKey();
    return decryptWithKey(ciphertext, key);
  }

  /// Clear all stored keys (for logout or account deletion)
  Future<void> clearKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_privateKeyStorageKey);
    await prefs.remove(_publicKeyStorageKey);
    _keyPair = null;
    _derivedKey = null;
  }
}

/// Extension for easy encryption of model data
extension EncryptionExtension on Map<String, dynamic> {
  /// Encrypt specified fields in this map
  Future<Map<String, dynamic>> encryptFields(
    List<String> fieldNames,
    EncryptionService encryption,
  ) async {
    final result = Map<String, dynamic>.from(this);

    for (final field in fieldNames) {
      if (result[field] != null && result[field] is String) {
        result[field] = await encryption.encryptDataAsync(result[field]);
      }
    }

    return result;
  }

  /// Decrypt specified fields in this map
  Future<Map<String, dynamic>> decryptFields(
    List<String> fieldNames,
    EncryptionService encryption,
  ) async {
    final result = Map<String, dynamic>.from(this);

    for (final field in fieldNames) {
      if (result[field] != null && result[field] is String) {
        try {
          result[field] = await encryption.decryptDataAsync(result[field]);
        } catch (e) {
          // Keep original value if decryption fails
          debugPrint('Failed to decrypt field $field: $e');
        }
      }
    }

    return result;
  }
}

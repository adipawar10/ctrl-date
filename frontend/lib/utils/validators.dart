/// Validation utilities for form inputs and data validation
class Validators {
  Validators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Simple password validation (just length check)
  static String? simplePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Password confirmation validation
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }

      if (value != password) {
        return 'Passwords do not match';
      }

      return null;
    };
  }

  /// Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    return null;
  }

  /// Username validation
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 30) {
      return 'Username must be at most 30 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Display name validation
  static String? displayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }

    if (value.length < 2) {
      return 'Display name must be at least 2 characters';
    }

    if (value.length > 50) {
      return 'Display name must be at most 50 characters';
    }

    return null;
  }

  /// Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    // Remove common phone formatting characters
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
      return 'Phone number can only contain digits';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'Please enter a valid URL';
    }

    if (!['http', 'https'].contains(uri.scheme)) {
      return 'URL must start with http:// or https://';
    }

    return null;
  }

  /// Event title validation
  static String? eventTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Event title is required';
    }

    if (value.length > 200) {
      return 'Event title must be at most 200 characters';
    }

    return null;
  }

  /// Event description validation
  static String? eventDescription(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Description is optional
    }

    if (value.length > 5000) {
      return 'Description must be at most 5000 characters';
    }

    return null;
  }

  /// Date range validation
  static String? dateRange(DateTime? start, DateTime? end) {
    if (start == null) {
      return 'Start date is required';
    }

    if (end == null) {
      return 'End date is required';
    }

    if (end.isBefore(start)) {
      return 'End date must be after start date';
    }

    return null;
  }

  /// Future date validation
  static String? futureDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    if (value.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  /// Past or present date validation
  static String? pastOrPresentDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    if (value.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }

    return null;
  }

  /// Reflection text validation
  static String? reflectionText(String? value, {int maxLength = 2000}) {
    if (value == null || value.isEmpty) {
      return null; // Most reflection fields are optional
    }

    if (value.length > maxLength) {
      return 'Text must be at most $maxLength characters';
    }

    return null;
  }

  /// Tag validation
  static String? tag(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tag cannot be empty';
    }

    if (value.length > 50) {
      return 'Tag must be at most 50 characters';
    }

    if (value.contains(' ')) {
      return 'Tags cannot contain spaces';
    }

    final tagRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!tagRegex.hasMatch(value)) {
      return 'Tags can only contain letters, numbers, underscores, and hyphens';
    }

    return null;
  }

  /// Tags list validation
  static String? tagsList(List<String>? tags, {int maxTags = 10}) {
    if (tags == null || tags.isEmpty) {
      return null; // Tags are optional
    }

    if (tags.length > maxTags) {
      return 'Maximum $maxTags tags allowed';
    }

    for (final t in tags) {
      final error = tag(t);
      if (error != null) return error;
    }

    return null;
  }

  /// Rating validation (1-5 scale)
  static String? rating(int? value) {
    if (value == null) {
      return null; // Rating is optional
    }

    if (value < 1 || value > 5) {
      return 'Rating must be between 1 and 5';
    }

    return null;
  }

  /// Min length validation
  static String? Function(String?) minLength(int min, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length < min) {
        final name = fieldName ?? 'This field';
        return '$name must be at least $min characters';
      }

      return null;
    };
  }

  /// Max length validation
  static String? Function(String?) maxLength(int max, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length > max) {
        final name = fieldName ?? 'This field';
        return '$name must be at most $max characters';
      }

      return null;
    };
  }

  /// Numeric validation
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  /// Integer validation
  static String? integer(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid whole number';
    }

    return null;
  }

  /// Positive number validation
  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return 'Please enter a positive number';
    }

    return null;
  }

  /// Range validation
  static String? Function(String?) range(
    double min,
    double max, {
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      final number = double.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }

      if (number < min || number > max) {
        final name = fieldName ?? 'Value';
        return '$name must be between $min and $max';
      }

      return null;
    };
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

/// Validation result class
class ValidationResult {
  final bool isValid;
  final String? error;
  final Map<String, String>? fieldErrors;

  const ValidationResult._({
    required this.isValid,
    this.error,
    this.fieldErrors,
  });

  factory ValidationResult.valid() => const ValidationResult._(isValid: true);

  factory ValidationResult.invalid(String error) => ValidationResult._(
        isValid: false,
        error: error,
      );

  factory ValidationResult.invalidFields(Map<String, String> fieldErrors) =>
      ValidationResult._(
        isValid: false,
        fieldErrors: fieldErrors,
      );
}

/// Form validator helper class
class FormValidator {
  final Map<String, String?> _errors = {};

  /// Add validation result for a field
  void addField(String fieldName, String? error) {
    if (error != null) {
      _errors[fieldName] = error;
    }
  }

  /// Check if form is valid
  bool get isValid => _errors.isEmpty;

  /// Get all errors
  Map<String, String> get errors => Map.unmodifiable(_errors);

  /// Get error for a specific field
  String? getError(String fieldName) => _errors[fieldName];

  /// Get first error message
  String? get firstError => _errors.values.firstOrNull;

  /// Convert to ValidationResult
  ValidationResult toResult() {
    if (isValid) {
      return ValidationResult.valid();
    }
    return ValidationResult.invalidFields(errors);
  }
}

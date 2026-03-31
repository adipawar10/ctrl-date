import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/models/friendship.dart';
import 'package:ctrl_shift_date/models/user.dart';

void main() {
  group('Friendship model', () {
    const requesterProfile = UserProfile(
      id: 'user-1',
      displayName: 'Alice',
    );
    const addresseeProfile = UserProfile(
      id: 'user-2',
      displayName: 'Bob',
    );

    Friendship makeFriendship({
      FriendshipStatus status = FriendshipStatus.accepted,
    }) {
      return Friendship(
        id: 'f-1',
        requesterId: 'user-1',
        addresseeId: 'user-2',
        status: status,
        requester: requesterProfile,
        addressee: addresseeProfile,
        streakCount: 7,
        longestStreak: 14,
      );
    }

    test('isActive returns true for accepted friendships', () {
      final f = makeFriendship(status: FriendshipStatus.accepted);
      expect(f.isActive, isTrue);
      expect(f.isPending, isFalse);
    });

    test('isPending returns true for pending friendships', () {
      final f = makeFriendship(status: FriendshipStatus.pending);
      expect(f.isPending, isTrue);
      expect(f.isActive, isFalse);
    });

    test('getFriendId returns addressee when current user is requester', () {
      final f = makeFriendship();
      expect(f.getFriendId('user-1'), 'user-2');
    });

    test('getFriendId returns requester when current user is addressee', () {
      final f = makeFriendship();
      expect(f.getFriendId('user-2'), 'user-1');
    });

    test('getFriendProfile returns addressee for requester', () {
      final f = makeFriendship();
      expect(f.getFriendProfile('user-1')?.displayName, 'Bob');
    });

    test('getFriendProfile returns requester for addressee', () {
      final f = makeFriendship();
      expect(f.getFriendProfile('user-2')?.displayName, 'Alice');
    });

    test('streakCount and longestStreak stored correctly', () {
      final f = makeFriendship();
      expect(f.streakCount, 7);
      expect(f.longestStreak, 14);
    });

    test('defaults are correct', () {
      const f = Friendship(
        id: 'f-2',
        requesterId: 'a',
        addresseeId: 'b',
      );
      expect(f.status, FriendshipStatus.pending);
      expect(f.isFavorite, isFalse);
      expect(f.isMuted, isFalse);
      expect(f.streakCount, 0);
    });
  });

  group('FriendshipStatus', () {
    test('all statuses exist', () {
      expect(FriendshipStatus.values.length, 4);
      expect(FriendshipStatus.values, contains(FriendshipStatus.blocked));
    });
  });

  group('PokeType', () {
    test('all poke types exist', () {
      expect(PokeType.values.length, 5);
      expect(PokeType.values, contains(PokeType.wave));
      expect(PokeType.values, contains(PokeType.thinkingOfYou));
      expect(PokeType.values, contains(PokeType.custom));
    });
  });

  group('EventShare model', () {
    test('isValid returns false for pending share', () {
      const share = EventShare(
        id: 's-1',
        eventId: 'evt-1',
        sharedByUserId: 'u-1',
        sharedWithUserId: 'u-2',
        status: EventShareStatus.pending,
      );
      expect(share.isValid, isFalse);
    });

    test('isValid returns true for accepted non-expired share', () {
      const share = EventShare(
        id: 's-1',
        eventId: 'evt-1',
        sharedByUserId: 'u-1',
        sharedWithUserId: 'u-2',
        status: EventShareStatus.accepted,
      );
      expect(share.isValid, isTrue);
      expect(share.isExpired, isFalse);
    });

    test('isExpired returns true for expired share', () {
      final share = EventShare(
        id: 's-1',
        eventId: 'evt-1',
        sharedByUserId: 'u-1',
        sharedWithUserId: 'u-2',
        status: EventShareStatus.accepted,
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(share.isExpired, isTrue);
      expect(share.isValid, isFalse);
    });

    test('permission defaults to view', () {
      const share = EventShare(
        id: 's-1',
        eventId: 'evt-1',
        sharedByUserId: 'u-1',
        sharedWithUserId: 'u-2',
      );
      expect(share.permission, EventSharePermission.view);
    });
  });

  group('EventSharePermission', () {
    test('all permissions exist', () {
      expect(EventSharePermission.values.length, 3);
      expect(EventSharePermission.values, contains(EventSharePermission.edit));
      expect(EventSharePermission.values, contains(EventSharePermission.manage));
    });
  });

  group('FriendRequest model', () {
    test('defaults to pending status', () {
      const req = FriendRequest(
        id: 'req-1',
        requesterId: 'u-1',
        addresseeId: 'u-2',
      );
      expect(req.status, FriendRequestStatus.pending);
    });
  });
}

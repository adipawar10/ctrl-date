import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('null returns required error', () {
      expect(Validators.email(null), isNotNull);
    });

    test('empty string returns required error', () {
      expect(Validators.email(''), isNotNull);
    });

    test('valid email returns null', () {
      expect(Validators.email('user@example.com'), isNull);
    });

    test('invalid email returns error', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('email without domain extension is invalid', () {
      expect(Validators.email('user@localhost'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('null returns required error', () {
      expect(Validators.password(null), isNotNull);
    });

    test('short password fails', () {
      expect(Validators.password('Ab1'), isNotNull);
    });

    test('no uppercase fails', () {
      expect(Validators.password('abcdefg1'), isNotNull);
    });

    test('no lowercase fails', () {
      expect(Validators.password('ABCDEFG1'), isNotNull);
    });

    test('no digit fails', () {
      expect(Validators.password('Abcdefgh'), isNotNull);
    });

    test('valid password returns null', () {
      expect(Validators.password('StrongPass1'), isNull);
    });
  });

  group('Validators.simplePassword', () {
    test('accepts 6+ character password', () {
      expect(Validators.simplePassword('123456'), isNull);
    });

    test('rejects shorter than 6', () {
      expect(Validators.simplePassword('12345'), isNotNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('matching passwords return null', () {
      final validator = Validators.confirmPassword('pass123');
      expect(validator('pass123'), isNull);
    });

    test('mismatched passwords return error', () {
      final validator = Validators.confirmPassword('pass123');
      expect(validator('different'), isNotNull);
    });

    test('empty confirmation returns error', () {
      final validator = Validators.confirmPassword('pass123');
      expect(validator(''), isNotNull);
    });
  });

  group('Validators.required', () {
    test('null returns error', () {
      expect(Validators.required(null), isNotNull);
    });

    test('empty string returns error', () {
      expect(Validators.required(''), isNotNull);
    });

    test('whitespace only returns error', () {
      expect(Validators.required('   '), isNotNull);
    });

    test('non-empty returns null', () {
      expect(Validators.required('hello'), isNull);
    });

    test('fieldName included in error message', () {
      final result = Validators.required(null, fieldName: 'Name');
      expect(result, contains('Name'));
    });
  });

  group('Validators.username', () {
    test('valid username returns null', () {
      expect(Validators.username('john_doe'), isNull);
    });

    test('too short returns error', () {
      expect(Validators.username('ab'), isNotNull);
    });

    test('too long returns error', () {
      expect(Validators.username('a' * 31), isNotNull);
    });

    test('spaces rejected', () {
      expect(Validators.username('john doe'), isNotNull);
    });
  });

  group('Validators.displayName', () {
    test('valid name returns null', () {
      expect(Validators.displayName('John'), isNull);
    });

    test('single char returns error', () {
      expect(Validators.displayName('J'), isNotNull);
    });

    test('too long returns error', () {
      expect(Validators.displayName('A' * 51), isNotNull);
    });
  });

  group('Validators.phoneNumber', () {
    test('null is optional, returns null', () {
      expect(Validators.phoneNumber(null), isNull);
    });

    test('empty is optional, returns null', () {
      expect(Validators.phoneNumber(''), isNull);
    });

    test('valid phone returns null', () {
      expect(Validators.phoneNumber('+1 (555) 123-4567'), isNull);
    });

    test('too short returns error', () {
      expect(Validators.phoneNumber('12345'), isNotNull);
    });
  });

  group('Validators.eventTitle', () {
    test('empty returns error', () {
      expect(Validators.eventTitle(''), isNotNull);
    });

    test('valid title returns null', () {
      expect(Validators.eventTitle('Team Meeting'), isNull);
    });

    test('too long returns error', () {
      expect(Validators.eventTitle('A' * 201), isNotNull);
    });
  });

  group('Validators.eventDescription', () {
    test('null is optional, returns null', () {
      expect(Validators.eventDescription(null), isNull);
    });

    test('too long returns error', () {
      expect(Validators.eventDescription('A' * 5001), isNotNull);
    });
  });

  group('Validators.dateRange', () {
    test('valid range returns null', () {
      expect(
        Validators.dateRange(
          DateTime(2026, 4, 1),
          DateTime(2026, 4, 2),
        ),
        isNull,
      );
    });

    test('end before start returns error', () {
      expect(
        Validators.dateRange(
          DateTime(2026, 4, 2),
          DateTime(2026, 4, 1),
        ),
        isNotNull,
      );
    });

    test('null start returns error', () {
      expect(Validators.dateRange(null, DateTime(2026, 4, 1)), isNotNull);
    });

    test('null end returns error', () {
      expect(Validators.dateRange(DateTime(2026, 4, 1), null), isNotNull);
    });
  });

  group('Validators.tag', () {
    test('valid tag returns null', () {
      expect(Validators.tag('work'), isNull);
    });

    test('empty returns error', () {
      expect(Validators.tag(''), isNotNull);
    });

    test('spaces rejected', () {
      expect(Validators.tag('two words'), isNotNull);
    });

    test('too long returns error', () {
      expect(Validators.tag('a' * 51), isNotNull);
    });

    test('special chars rejected', () {
      expect(Validators.tag('tag@!'), isNotNull);
    });

    test('hyphens and underscores accepted', () {
      expect(Validators.tag('my-tag_1'), isNull);
    });
  });

  group('Validators.tagsList', () {
    test('null is optional', () {
      expect(Validators.tagsList(null), isNull);
    });

    test('too many tags returns error', () {
      final tags = List.generate(11, (i) => 'tag$i');
      expect(Validators.tagsList(tags), isNotNull);
    });

    test('valid list returns null', () {
      expect(Validators.tagsList(['work', 'important']), isNull);
    });
  });

  group('Validators.rating', () {
    test('null is optional', () {
      expect(Validators.rating(null), isNull);
    });

    test('valid rating returns null', () {
      expect(Validators.rating(3), isNull);
    });

    test('0 returns error', () {
      expect(Validators.rating(0), isNotNull);
    });

    test('6 returns error', () {
      expect(Validators.rating(6), isNotNull);
    });
  });

  group('Validators.combine', () {
    test('returns first error', () {
      final validator = Validators.combine([
        Validators.required,
        Validators.minLength(5),
      ]);
      expect(validator(''), isNotNull);
    });

    test('returns null when all pass', () {
      final validator = Validators.combine([
        Validators.required,
        Validators.minLength(3),
      ]);
      expect(validator('hello'), isNull);
    });
  });

  group('FormValidator', () {
    test('isValid when no errors', () {
      final fv = FormValidator();
      fv.addField('email', null);
      expect(fv.isValid, isTrue);
    });

    test('isValid false when errors exist', () {
      final fv = FormValidator();
      fv.addField('email', 'Email is required');
      expect(fv.isValid, isFalse);
    });

    test('getError returns field error', () {
      final fv = FormValidator();
      fv.addField('email', 'Email is required');
      expect(fv.getError('email'), 'Email is required');
    });

    test('firstError returns first added error', () {
      final fv = FormValidator();
      fv.addField('email', 'Email is required');
      fv.addField('name', 'Name is required');
      expect(fv.firstError, isNotNull);
    });

    test('toResult returns valid result', () {
      final fv = FormValidator();
      final result = fv.toResult();
      expect(result.isValid, isTrue);
    });

    test('toResult returns invalid result with fields', () {
      final fv = FormValidator();
      fv.addField('email', 'Email is required');
      final result = fv.toResult();
      expect(result.isValid, isFalse);
      expect(result.fieldErrors, isNotNull);
    });
  });
}

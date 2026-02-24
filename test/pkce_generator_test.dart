import 'package:pkce_generator/pkce_generator.dart';
import 'package:test/test.dart';

void main() {
  // ── Base64url alphabet (no padding, no + or /) ──────────────────────────
  final base64UrlPattern = RegExp(r'^[A-Za-z0-9\-_]+$');

  // ════════════════════════════════════════════════════════════════════════
  // S256
  // ════════════════════════════════════════════════════════════════════════
  group('PkceGenerator.generate() — S256 method', () {
    late PkceResult result;

    setUp(() => result = PkceGenerator.generate());

    test('codeVerifier has exactly 110 characters', () {
      expect(result.codeVerifier.length, equals(110));
    });

    test('codeChallenge has exactly 43 characters', () {
      expect(result.codeChallenge.length, equals(43));
    });

    test('codeVerifier uses base64url alphabet (no padding, no +, no /)', () {
      expect(result.codeVerifier, matches(base64UrlPattern));
    });

    test('codeChallenge uses base64url alphabet (no padding, no +, no /)', () {
      expect(result.codeChallenge, matches(base64UrlPattern));
    });

    test('codeChallenge differs from codeVerifier (SHA-256 applied)', () {
      expect(result.codeChallenge, isNot(equals(result.codeVerifier)));
    });

    test('method is CodeChallengeMethod.S256', () {
      expect(result.method, equals(CodeChallengeMethod.S256));
    });

    test('default method is S256 when no argument given', () {
      final defaultResult = PkceGenerator.generate();
      expect(defaultResult.method, equals(CodeChallengeMethod.S256));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // plain
  // ════════════════════════════════════════════════════════════════════════
  group('PkceGenerator.generate() — plain method', () {
    late PkceResult result;

    setUp(
      () => result = PkceGenerator.generate(method: CodeChallengeMethod.plain),
    );

    test('codeVerifier has exactly 110 characters', () {
      expect(result.codeVerifier.length, equals(110));
    });

    test('codeVerifier uses base64url alphabet (no padding, no +, no /)', () {
      expect(result.codeVerifier, matches(base64UrlPattern));
    });

    test('codeChallenge equals codeVerifier for plain method', () {
      expect(result.codeChallenge, equals(result.codeVerifier));
    });

    test('method is CodeChallengeMethod.plain', () {
      expect(result.method, equals(CodeChallengeMethod.plain));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // Randomness
  // ════════════════════════════════════════════════════════════════════════
  group('Randomness', () {
    test('two consecutive calls produce different verifiers', () {
      final a = PkceGenerator.generate();
      final b = PkceGenerator.generate();
      expect(a.codeVerifier, isNot(equals(b.codeVerifier)));
    });

    test('two consecutive calls produce different challenges (S256)', () {
      final a = PkceGenerator.generate();
      final b = PkceGenerator.generate();
      expect(a.codeChallenge, isNot(equals(b.codeChallenge)));
    });
  });

  // ════════════════════════════════════════════════════════════════════════
  // PkceResult model
  // ════════════════════════════════════════════════════════════════════════
  group('PkceResult', () {
    test('toString contains all field names and values', () {
      final result = PkceGenerator.generate();
      final str = result.toString();
      expect(str, contains('PkceResult'));
      expect(str, contains('method'));
      expect(str, contains('codeVerifier'));
      expect(str, contains('codeChallenge'));
      expect(str, contains(result.codeVerifier));
      expect(str, contains(result.codeChallenge));
    });

    test('all fields are accessible and non-null', () {
      final result = PkceGenerator.generate();
      expect(result.codeVerifier, isNotNull);
      expect(result.codeChallenge, isNotNull);
      expect(result.method, isNotNull);
    });
  });
}

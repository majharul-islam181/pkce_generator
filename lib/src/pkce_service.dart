import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'pkce_models.dart';

/// Internal service that implements the RFC 7636 PKCE algorithms.
///
/// This class is not part of the public API. Use [PkceGenerator] instead.
class PkceService {
  PkceService._(); // Prevent instantiation.

  /// Number of random bytes required to produce exactly 110 base64url chars.
  ///
  /// Derivation:
  ///   82 bytes → base64url (no padding):
  ///   82 = 27 × 3 + 1  → 27 complete groups (108 chars) + 1 remaining byte (2 chars)
  ///   = 108 + 2 = 110 characters exactly.
  static const int _verifierByteLength = 82;

  /// Generates a cryptographically secure code verifier.
  ///
  /// Returns a base64url-encoded string of **exactly 110 characters** with no
  /// padding characters, as required by RFC 7636 §4.1.
  ///
  /// Uses [Random.secure] to guarantee cryptographic randomness.
  static String generateCodeVerifier() {
    final random = Random.secure();
    final bytes = Uint8List(_verifierByteLength);
    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return _base64UrlNoPadding(bytes); // exactly 110 chars
  }

  /// Derives the code challenge from [verifier] using [method].
  ///
  /// - [CodeChallengeMethod.S256]: SHA-256 digest → base64url (no padding) → 43 chars.
  ///   (SHA-256 always produces 32 bytes → 32 = 10×3 + 2 → 43 base64url chars.)
  /// - [CodeChallengeMethod.plain]: returns [verifier] unchanged.
  static String deriveCodeChallenge(
    String verifier,
    CodeChallengeMethod method,
  ) {
    switch (method) {
      case CodeChallengeMethod.S256:
        final digest = sha256.convert(utf8.encode(verifier));
        return _base64UrlNoPadding(Uint8List.fromList(digest.bytes));
      case CodeChallengeMethod.plain:
        return verifier;
    }
  }

  /// Encodes [bytes] to a base64url string, stripping all `=` padding.
  static String _base64UrlNoPadding(Uint8List bytes) => base64Url.encode(bytes).replaceAll('=', '');
}

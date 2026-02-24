/// A production-ready PKCE (Proof Key for Code Exchange) generator.
///
/// Implements [RFC 7636](https://datatracker.ietf.org/doc/html/rfc7636) to
/// generate cryptographically secure PKCE values for use in OAuth 2.0 and
/// OpenID Connect authorization code flows.
///
/// ## Quick start
///
/// ```dart
/// import 'package:pkce_generator/pkce_generator.dart';
///
/// void main() {
///   final pkce = PkceGenerator.generate();
///
///   print(pkce.codeVerifier);  // 110-char base64url string
///   print(pkce.codeChallenge); // 43-char base64url string (S256)
///   print(pkce.method);        // CodeChallengeMethod.S256
/// }
/// ```
library pkce_generator;

// Public model exports — consumers need these types.
export 'src/pkce_models.dart';

import 'src/pkce_models.dart';
import 'src/pkce_service.dart';

/// Entry point for generating RFC 7636-compliant PKCE values.
///
/// All methods are static; this class cannot be instantiated.
///
/// ### Example
///
/// ```dart
/// // S256 (recommended)
/// final pkce = PkceGenerator.generate();
/// print(pkce.codeVerifier);  // e.g. "dBjftJeZ4CVP..."  (110 chars)
/// print(pkce.codeChallenge); // e.g. "E9Melhoa2OwvF..." (43 chars)
///
/// // plain (not recommended for production)
/// final plain = PkceGenerator.generate(method: CodeChallengeMethod.plain);
/// print(plain.codeChallenge == plain.codeVerifier); // true
/// ```
class PkceGenerator {
  PkceGenerator._(); // Prevent instantiation.

  /// Generates a complete PKCE pair using the specified [method].
  ///
  /// Defaults to [CodeChallengeMethod.S256], which is required by most
  /// modern OAuth 2.0 servers.
  ///
  /// Returns a [PkceResult] with:
  ///
  /// | Field            | S256                          | plain         |
  /// |------------------|-------------------------------|---------------|
  /// | `codeVerifier`   | 110-char base64url            | 110-char base64url |
  /// | `codeChallenge`  | 43-char base64url (SHA-256)   | equals verifier |
  /// | `method`         | `CodeChallengeMethod.S256`    | `CodeChallengeMethod.plain` |
  static PkceResult generate({
    CodeChallengeMethod method = CodeChallengeMethod.S256,
  }) {
    final verifier = PkceService.generateCodeVerifier();
    final challenge = PkceService.deriveCodeChallenge(verifier, method);
    return PkceResult(
      codeVerifier: verifier,
      codeChallenge: challenge,
      method: method,
    );
  }
}

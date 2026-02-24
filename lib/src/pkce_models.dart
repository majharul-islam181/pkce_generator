/// Supported PKCE code challenge methods as defined in RFC 7636.
///
/// See: https://datatracker.ietf.org/doc/html/rfc7636#section-4.2
enum CodeChallengeMethod {
  /// SHA-256 hash of the code verifier, then base64url-encoded (recommended).
  ///
  /// `code_challenge = BASE64URL(SHA256(ASCII(code_verifier)))`
  S256,

  /// The code challenge is identical to the code verifier.
  ///
  /// Only use if the client cannot support [S256]. Not recommended for
  /// production environments.
  plain,
}

/// Holds the complete PKCE pair produced by [PkceGenerator.generate].
class PkceResult {
  /// A cryptographically random, base64url-encoded string (110 characters).
  ///
  /// Sent to the token endpoint to prove possession of the original secret.
  final String codeVerifier;

  /// The derived code challenge (base64url, no padding).
  ///
  /// - [CodeChallengeMethod.S256]: 43 characters (SHA-256 → base64url).
  /// - [CodeChallengeMethod.plain]: equals [codeVerifier] (110 characters).
  ///
  /// Sent to the authorization endpoint at the start of the flow.
  final String codeChallenge;

  /// The method used to derive [codeChallenge] from [codeVerifier].
  final CodeChallengeMethod method;

  /// Creates a [PkceResult] with the given values.
  ///
  /// All fields are required. In normal usage, obtain instances via
  /// [PkceGenerator.generate] rather than constructing directly.
  const PkceResult({
    required this.codeVerifier,
    required this.codeChallenge,
    required this.method,
  });

  @override
  String toString() => 'PkceResult('
      'method: $method, '
      'codeVerifier: $codeVerifier, '
      'codeChallenge: $codeChallenge'
      ')';
}

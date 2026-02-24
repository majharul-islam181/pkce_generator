## 1.0.0

* Initial release.
* RFC 7636-compliant PKCE generation.
* Supports `S256` (SHA-256) and `plain` code challenge methods.
* Cryptographically secure code verifier (110 chars, base64url).
* Derived code challenge (43 chars, base64url, no padding) for S256.
* Null-safe, Dart SDK ≥ 3.0.0.

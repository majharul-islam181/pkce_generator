# pkce_generator

[![pub version](https://img.shields.io/pub/v/pkce_generator.svg)](https://pub.dev/packages/pkce_generator)
[![Dart SDK](https://img.shields.io/badge/Dart-%3E%3D3.0.0-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A production-ready Dart package for generating **PKCE** (Proof Key for Code
Exchange) values following [RFC 7636](https://datatracker.ietf.org/doc/html/rfc7636).

---

## What is PKCE?

PKCE (pronounced *"pixie"*) is a security extension to OAuth 2.0 that protects
public clients (mobile apps, single-page apps, CLIs) from authorization code
interception attacks.

Instead of a static client secret, the client generates a random
**code verifier**, derives a **code challenge** from it, and sends the challenge
to the authorization server at the start of the flow. When exchanging the
authorization code for tokens, the client proves it initiated the request by
sending the original verifier — which the server verifies against the stored
challenge.

**Flow summary:**

```
Client                                    Authorization Server
  │                                               │
  │  1. Generate code_verifier (random secret)    │
  │  2. Derive  code_challenge = SHA256(verifier) │
  │                                               │
  │──── GET /authorize?code_challenge=... ───────►│
  │◄─── authorization_code ──────────────────────│
  │                                               │
  │──── POST /token { code, code_verifier } ─────►│
  │        (server verifies challenge matches)    │
  │◄─── access_token ────────────────────────────│
```

---

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  pkce_generator: ^1.0.0
```

Then run:

```sh
dart pub get
```

---

## Usage

### S256 (recommended)

```dart
import 'package:pkce_generator/pkce_generator.dart';

void main() {
  final pkce = PkceGenerator.generate();

  print(pkce.codeVerifier);  // 110-char base64url string
  print(pkce.codeChallenge); // 43-char base64url SHA-256 hash
  print(pkce.method);        // CodeChallengeMethod.S256
}
```

### plain (not recommended for production)

```dart
final pkce = PkceGenerator.generate(method: CodeChallengeMethod.plain);

print(pkce.codeChallenge == pkce.codeVerifier); // true
```

---

## API

### `PkceGenerator.generate()`

```dart
static PkceResult generate({
  CodeChallengeMethod method = CodeChallengeMethod.S256,
})
```

Generates a complete PKCE pair. All fields are cryptographically generated on
every call. The `method` parameter defaults to `S256`.

---

### `PkceResult`

| Field           | Type                  | Description                                   |
|-----------------|-----------------------|-----------------------------------------------|
| `codeVerifier`  | `String`              | 110-char base64url random string (no padding) |
| `codeChallenge` | `String`              | 43-char base64url SHA-256 hash (S256) — or equals `codeVerifier` for plain |
| `method`        | `CodeChallengeMethod` | Method used to derive the challenge           |

---

### `CodeChallengeMethod`

| Value   | Description                                                    |
|---------|----------------------------------------------------------------|
| `S256`  | `code_challenge = BASE64URL(SHA256(ASCII(code_verifier)))`     |
| `plain` | `code_challenge = code_verifier` (use only if S256 not possible) |

---

## Example output

```
[ S256 Method ]
  Code Verifier  (110 chars) : dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk...
  Code Challenge  (43 chars) : E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
  Method                     : CodeChallengeMethod.S256

[ plain Method ]
  Code Verifier  (110 chars) : 4kA2BqoSFEw7R1hv3nZdY9...
  Code Challenge (110 chars) : 4kA2BqoSFEw7R1hv3nZdY9...  (same as verifier)
  Method                     : CodeChallengeMethod.plain
```

---

## RFC 7636 Compliance

| Requirement                           | This package         |
|---------------------------------------|----------------------|
| Cryptographically random verifier     | ✅ `Random.secure()` |
| Verifier charset: `[A-Za-z0-9\-._~]` | ✅ base64url safe    |
| Verifier length: 43–128 chars         | ✅ 110 chars         |
| Challenge: BASE64URL(SHA256(verifier))| ✅ S256 method       |
| No padding `=` in challenge           | ✅ stripped          |

---

## License

MIT © 2026. See [LICENSE](LICENSE) for details.

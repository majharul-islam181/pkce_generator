import 'package:pkce_generator/pkce_generator.dart';

void main() {
  // ── S256 (recommended by RFC 7636) ──────────────────────────────────────
  final s256 = PkceGenerator.generate();

  print('╔══════════════════════════════════════════════════════════════════╗');
  print('║                  pkce_generator  ·  RFC 7636                    ║');
  print('╠══════════════════════════════════════════════════════════════════╣');
  print('');
  print('[ S256 Method ]');
  print('  Code Verifier  (${s256.codeVerifier.length} chars) : ${s256.codeVerifier}');
  print('  Code Challenge (${s256.codeChallenge.length} chars) : ${s256.codeChallenge}');
  print('  Method                  : ${s256.method}');

  print('');

  // ── plain (challenge == verifier; not recommended for production) ────────
  final plain = PkceGenerator.generate(method: CodeChallengeMethod.plain);

  print('[ plain Method ]');
  print('  Code Verifier  (${plain.codeVerifier.length} chars) : ${plain.codeVerifier}');
  print('  Code Challenge (${plain.codeChallenge.length} chars) : ${plain.codeChallenge}');
  print('  Method                  : ${plain.method}');
  print('  Challenge == Verifier?  : ${plain.codeChallenge == plain.codeVerifier}');

  print('');
  print('╚══════════════════════════════════════════════════════════════════╝');
}

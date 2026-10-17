import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthResult {
  final bool ok;
  final String? error;
  const AuthResult.success() : ok = true, error = null;
  const AuthResult.failure(this.error) : ok = false;
}

/// Local demo authentication for authorized users.
///
/// Passwords are stored as salted SHA-256 hashes (not plain text), but this is
/// still client-side only: anyone can read the app's code. For a real system,
/// replace [login] with a call to your backend / Firebase Auth.
///
/// Demo accounts:
///   admin@tip.edu.ph    /  Radiant@2026
///   traffic@tip.edu.ph  /  Traffic@2026
class AuthService {
  static const _salt = 'radiant-demo-salt';
  static const _maxFailures = 5;
  static const _lockSeconds = 30;

  static final Map<String, String> _users = {
    'admin@tip.edu.ph': '2f4a1615a473ea18d000954f392d940b0401002616456bedc37ff7bd569faeb7',
    'traffic@tip.edu.ph': '4353447ee3183d33087b94157e7cbb2496c47b186c9d736c06aeef73a31e05e4',
  };

  static int _failures = 0;
  static DateTime? _lockedUntil;

  static String _hash(String password) =>
      sha256.convert(utf8.encode('$_salt:$password')).toString();

  static Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network

    final now = DateTime.now();
    if (_lockedUntil != null && now.isBefore(_lockedUntil!)) {
      final s = _lockedUntil!.difference(now).inSeconds + 1;
      return AuthResult.failure('Too many attempts. Try again in $s s.');
    }

    final stored = _users[email.trim().toLowerCase()];
    if (stored != null && stored == _hash(password)) {
      _failures = 0;
      _lockedUntil = null;
      return const AuthResult.success();
    }

    _failures++;
    if (_failures >= _maxFailures) {
      _failures = 0;
      _lockedUntil = now.add(const Duration(seconds: _lockSeconds));
      return const AuthResult.failure(
          'Too many attempts. Locked for $_lockSeconds s.');
    }
    return AuthResult.failure(
        'Incorrect email or password. ${_maxFailures - _failures} attempts left.');
  }
}

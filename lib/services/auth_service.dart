import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool ok;
  final String? error;
  const AuthResult.success() : ok = true, error = null;
  const AuthResult.failure(this.error) : ok = false;
}

class _Account {
  final String salt, hash;
  const _Account(this.salt, this.hash);
}

/// Local account system for authorized users: two built-in demo accounts
/// (admin@tip.edu.ph, traffic@tip.edu.ph) plus accounts created through the
/// Create account screen.
///
/// Created accounts are saved on the device (shared_preferences) with a random
/// salt and a hashed password.
/// This is still client-side only: for a real deployment, replace [register]
/// and [login] with calls to a backend / Firebase Auth.
class AuthService {
  static const _prefsKey = 'radiant_accounts_v1';
  static const _rounds = 2000;
  static const _maxFailures = 5;
  static const _lockSeconds = 30;
  static const domain = '@tip.edu.ph';


  // Built-in demo accounts (always available, cannot be re-registered).
  // Passwords are stored only as salted hashes. DEMO ONLY: remove for production.
  static const Map<String, _Account> _builtIn = {
    'admin@tip.edu.ph': _Account('demo-salt-admin', 'bee700a7a3afffc9dce65bd78410281d0c60c5f9a17eab252f9b1503ce4c2c44'),
    'traffic@tip.edu.ph': _Account('demo-salt-traffic', 'f440cd697d707728eb868db6474cef54bafa8b5dcf814a06b0584692924f317a'),
  };

  static final Map<String, _Account> _accounts = {};
  static int _failures = 0;
  static DateTime? _lockedUntil;

  /// Call once at startup (see main.dart).
  static Future<void> init() async {
    _accounts.addAll(_builtIn);
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    map.forEach((email, v) {
      _accounts[email] = _Account(v['salt'] as String, v['hash'] as String);
    });
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _prefsKey,
        jsonEncode({
          for (final e in _accounts.entries)
            if (!_builtIn.containsKey(e.key))
              e.key: {'salt': e.value.salt, 'hash': e.value.hash}
        }));
  }

  // ---- validation rules (shared by the login and sign-up screens) ----
  static bool emailOk(String email) =>
      email.trim().toLowerCase().endsWith(domain) &&
      email.trim().length > domain.length;

  /// Returns a problem description, or null if the password is acceptable.
  static String? passwordIssue(String p) {
    if (p.length < 8) return 'Use at least 8 characters';
    if (!p.contains(RegExp(r'[A-Za-z]'))) return 'Include at least one letter';
    if (!p.contains(RegExp(r'[0-9]'))) return 'Include at least one number';
    return null;
  }

  // ---- hashing ----
  static String _newSalt() {
    final r = Random.secure();
    return base64Url.encode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  static String _hash(String salt, String password) {
    var digest = sha256.convert(utf8.encode('$salt:$password'));
    for (var i = 1; i < _rounds; i++) {
      digest = sha256.convert([...digest.bytes, ...utf8.encode(salt)]);
    }
    return digest.toString();
  }

  // ---- actions ----
  static Future<AuthResult> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final e = email.trim().toLowerCase();
    if (!emailOk(e)) return const AuthResult.failure('Use your @tip.edu.ph email address.');
    final issue = passwordIssue(password);
    if (issue != null) return AuthResult.failure(issue);
    if (_accounts.containsKey(e)) {
      return const AuthResult.failure('An account with this email already exists.');
    }
    final salt = _newSalt();
    _accounts[e] = _Account(salt, _hash(salt, password));
    await _save();
    return const AuthResult.success();
  }

  static Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final now = DateTime.now();
    if (_lockedUntil != null && now.isBefore(_lockedUntil!)) {
      final s = _lockedUntil!.difference(now).inSeconds + 1;
      return AuthResult.failure('Too many attempts. Try again in $s s.');
    }

    final acc = _accounts[email.trim().toLowerCase()];
    if (acc != null && acc.hash == _hash(acc.salt, password)) {
      _failures = 0;
      _lockedUntil = null;
      return const AuthResult.success();
    }

    _failures++;
    if (_failures >= _maxFailures) {
      _failures = 0;
      _lockedUntil = now.add(const Duration(seconds: _lockSeconds));
      return const AuthResult.failure('Too many attempts. Locked for $_lockSeconds s.');
    }
    return AuthResult.failure(
        'Incorrect email or password. ${_maxFailures - _failures} attempts left.');
  }
}
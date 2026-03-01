import 'package:hive/hive.dart';

class AuthLocalStorage {
  final _box = Hive.box('authBox');

  Future<bool> register(String email, String password) async {
    if (_box.containsKey(email)) {
      return false;
    }

    await _box.put(email, password);
    return true;
  }

  bool login(String email, String password) {
    if (!_box.containsKey(email)) return false;

    final savedPass = _box.get(email);
    return savedPass == password;
  }

  Future<bool> updatePassword(String email, String newPass) async {
    if (!_box.containsKey(email)) {
      return false;
    }

    await _box.put(email, newPass);
    return true;
  }

  Future<void> saveSession(String email) async {
    await _box.put('loggedIn', true);
    await _box.put('currentUser', email);
  }

  bool isLoggedIn() => _box.get('loggedIn', defaultValue: false);

  String? getCurrentUser() => _box.get('currentUser');

  Future<void> logout() async {
    await _box.put('loggedIn', false);
    await _box.delete('currentUser');
  }
}

import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage implements LocalStorage {
  final SharedPreferences sharedPreferences;

  SharedPrefsStorage(this.sharedPreferences);

  @override
  Future<void> saveString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }
}

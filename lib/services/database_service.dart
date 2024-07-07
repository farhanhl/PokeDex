import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  DatabaseService();

  Future<bool?> saveList(String key, List<String> value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool result = await prefs.setStringList(key, value);
      return result;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<String>?> getList(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? result = await prefs.getStringList(key);
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

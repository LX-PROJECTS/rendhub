import 'package:shared_preferences/shared_preferences.dart';

class SharedPerfService {
  static Future<SharedPreferences> get() async {
    return await SharedPreferences.getInstance();
  }
}

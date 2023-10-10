import 'package:shared_preferences/shared_preferences.dart';

class Cookies{
  static late SharedPreferences prefs;

  Cookies(){
    init();
  }

  static init() async {
     prefs = await SharedPreferences.getInstance();
  }

  static SetCookie(key, value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static ReadCookie(key)
  async {
    prefs = await SharedPreferences.getInstance();
    String? value = await prefs.getString(key);
    return value;
  }


}
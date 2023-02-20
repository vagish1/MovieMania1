import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref.init();
  static SharedPref instance = SharedPref.init();

  SharedPreferences? preferences;

  Future<SharedPreferences> init() async {
    preferences ??= await SharedPreferences.getInstance();
    return Future.value(preferences);
  }

  Future<bool> isLogedIn() async {
    final SharedPreferences preferences = await init();
    final bool? response = preferences.getBool("isLoggedIn");
    return Future.value(response ?? false);
  }

  void completeLogin() async {
    final SharedPreferences preferences = await init();
    await preferences.setBool("isLoggedIn", true);
  }
}

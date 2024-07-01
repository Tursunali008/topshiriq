import 'package:shared_preferences/shared_preferences.dart';

class MainPageController {
  bool isDark = false;

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);
    print('Data saved: isDark = $isDark');
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    print('Retrieved data: isDark = $isDark');
  }
}
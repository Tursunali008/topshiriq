import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/views/screens/admin_panel_screen.dart';
import 'package:topshiriq/views/screens/login_screen.dart';
import 'package:topshiriq/views/screens/main_page.dart';
import 'package:topshiriq/views/screens/profile_screen_menegment.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    setState(() {
      _isDarkMode = savedThemeMode == AdaptiveThemeMode.dark;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    if (_isDarkMode) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  void _navigateToAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
    );
  }

  void _navigateToMainPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
  void _navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('menu'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  ),
                  onPressed: _toggleTheme,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: Text(tr('admin_panel')),
            onTap: _navigateToAdminPanel,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(tr('home_app_bar')),
            onTap: _navigateToMainPage,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(tr('profile')),
            onTap: _navigateToProfileScreen,
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: Text(tr('login')),
            onTap: _navigateToLoginScreen,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:topshiriq/views/screens/admin_panel_screen.dart';
import 'package:topshiriq/views/screens/main_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin Panel'),
            onTap: _navigateToAdminPanel,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Online Shopping'),
            onTap: _navigateToMainPage,
          ),
        ],
      ),
    );
  }
}

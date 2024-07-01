import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/views/screens/card_screen.dart';
import 'package:topshiriq/views/screens/home_screen.dart';
import 'package:topshiriq/views/screens/order_screen.dart';
import 'package:topshiriq/views/widgets/custom_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tr('app_bar'),
        ),
        actions: [
          Row(
            children: [
              const Icon(Icons.language),
              DropdownButton<Locale>(
                alignment: AlignmentDirectional.bottomEnd,
                elevation: 8,
                value: context.locale,
                items: const [
                  DropdownMenuItem(
                    value: Locale("uz"),
                    child: Text("Uz"),
                  ),
                  DropdownMenuItem(
                    value: Locale("en"),
                    child: Text("En"),
                  ),
                ],
                onChanged: (Locale? value) {
                  if (value != null) {
                    context.setLocale(value);
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ],
        backgroundColor: Colors.amber,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children:  [
          HomeScreen(),
          CartScreen(),
          OrderScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: tr('home'), // Localized tab label
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.grey,
            ),
            label: tr('cart'), // Localized tab label
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.list,
              color: Colors.grey,
            ),
            label: tr('order'), // Localized tab label
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: const CustomDrawer(),
    );
  }
}

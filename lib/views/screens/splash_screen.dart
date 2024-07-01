import 'package:flutter/material.dart';
import 'package:topshiriq/viewmodel/users_view_model.dart';
import 'package:topshiriq/views/screens/login_screen.dart';
import 'package:topshiriq/views/screens/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    bool isLoggedIn = await UsersViewmodel().checkLogin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const MainPage() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          'https://papik.pro/grafic/uploads/posts/2023-04/1681580469_papik-pro-p-logotip-avtomasterskoi-vektor-27.png',
        ),
      ),
    );
  }
}

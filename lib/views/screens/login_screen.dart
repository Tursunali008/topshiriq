import 'package:flutter/material.dart';
import 'package:topshiriq/views/screens/main_page.dart';
import 'package:topshiriq/views/screens/registor_screen.dart';
import 'package:topshiriq/viewmodel/users_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usersViewModel = UsersViewmodel();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      //? login

      setState(() {
        isLoading = true;
      });
      try {
        await usersViewModel.login(
          emailController.text,
          passwordController.text,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const MainPage();
            },
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(e.toString()),
            );
          },
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                  "https://asia361.com/wp-content/uploads/2015/07/Online-shop_button.jpg"),
              const Text(
                "Tizimga Kirish",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Elektron pochta",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos elektron pochta kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos parolingizni kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: FilledButton(
                        onPressed: submit,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text("KIRISH"),
                      ),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const RegisterScreen();
                      },
                    ),
                  );
                },
                child: const Text("Ro'yxatdan O'tish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:topshiriq/views/screens/login_screen.dart';
import 'package:topshiriq/viewmodel/users_view_model.dart';
import 'package:topshiriq/views/screens/main_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usersViewModel = UsersViewmodel();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      //? register

      setState(() {
        isLoading = true;
      });
      try {
        await usersViewModel.register(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                    "https://papik.pro/grafic/uploads/posts/2023-04/1681580469_papik-pro-p-logotip-avtomasterskoi-vektor-27.png"),
                const Text(
                  "Ro'yxatdan O'tish",
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
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: passwordConfirmController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Parol tasdiqlang",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Iltimos parolingizni tasdiqlang";
                    }

                    if (passwordConfirmController.text !=
                        passwordController.text) {
                      return "Parollar bir xil emas";
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
                          child: const Text("RO'YXATDAN O'TISH"),
                        ),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                  child: const Text("Tizimga kirish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

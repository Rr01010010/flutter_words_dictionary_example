import 'package:card_game/firebase/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignAppPage extends GetView<FireAuth> {
  SignAppPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  TextButton(
                    onPressed: () {
                      controller.tryEmailAuth(
                          emailController.text, passwordController.text);
                    },
                    child: const Text("Login"),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.tryRegistration(
                          emailController.text, passwordController.text);
                    },
                    child: const Text("Registration"),
                  ),
                ]),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: TextButton(
                onPressed: () => controller.tryGoogleAuth(),
                child: const Text("Sign with google")),
          )
        ],
      ),
    );
  }
}

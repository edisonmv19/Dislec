import 'package:dislec/src/ui/pages/sign_in/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dislec/src/ui/routes/route_names.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Get.find<SignInController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              controller: controller.passwordController,
              decoration: const InputDecoration(
                labelText: 'Constraseña',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: controller.signIn,
              child: const Text('Inicia Sesión'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.offNamed(RouteNames.register);
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}

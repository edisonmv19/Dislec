import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:get/get.dart';

final _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  final String title = 'Registro';

  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.offNamed(RouteNames.signIn);
          },
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Ingresar Correo Electrónico';
                }
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              controller: _passswordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Ingresar Contraseña';
                }
              },
            ),
            const SizedBox(height: 16.0),
            FlatButton(
                child: Text('Register'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passswordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Usuario Registrado'),
                        backgroundColor: Colors.green,
                      ));
                      Get.offNamed(RouteNames.signIn);
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Email no valido : ${e.message}'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                }),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void dispose() {
    _emailController.dispose();
    _passswordController.dispose();
    super.dispose();
  }
}

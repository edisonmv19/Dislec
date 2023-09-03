import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';

final _auth = FirebaseAuth.instance;

class RegisterEst extends StatefulWidget {
  const RegisterEst({Key? key}) : super(key: key);
  final String title = 'Datos Estudiante';

  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterEst> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _assessorController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {
      'value': '4to EGB',
      'label': '4to EGB',
    },
    {
      'value': '5to EGB',
      'label': '5to EGB',
    },
    {
      'value': '6to EGB',
      'label': '6to EGB',
    },
    {
      'value': '7mo EGB',
      'label': '7mo EGB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Get.offNamed(RouteNames.home);
            },
          ),
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Ingresar Nombre';
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Ingresar Edad';
                    }
                  },
                ),
                const SizedBox(height: 10.0),
                SelectFormField(
                  controller: _courseController,
                  labelText: 'Grado',
                  items: _items,
                  decoration: InputDecoration(
                    labelText: "Grado",
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  onChanged: (val) => print(val),
                  onSaved: (val) => print(val),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione un Grado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _assessorController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Evaluador',
                    contentPadding: EdgeInsets.all(20.0),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Ingresar Evaluador';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                FlatButton(
                    padding: EdgeInsets.all(16),
                    child: Text('Continuar'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        countQuestions = 0;
                        mail = _assessorController.text;
                        name = _nameController.text;
                        age = int.parse(_ageController.text);
                        course = _courseController.text;
                        Get.offNamed(RouteNames.sec1);
                      }
                    }),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ));
  }

  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _courseController.dispose();
    super.dispose();
  }
}

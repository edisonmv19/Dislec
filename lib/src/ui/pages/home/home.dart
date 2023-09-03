import 'package:dislec/src/data/firebase/auth_firebase.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:dislec/src/ui/widgets/snackbar/error_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dislec/src/app/controllers/services.dart';
import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:dislec/src/app/models/evaluation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dislec'),
        actions: [
          IconButton(
              onPressed: () async {
                await getEvals();
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /*Services().saveSpeed(
              'Cuando tiramos papeles al suelo los profesores nos castigan, debemos mantener el colegio limpio y usar las papeleras',
              'Cuando tiramos papeles al suelo los profesores nos castigan debemos mantener el colegio limpio y usar las papeleras',
              'El conejo es un animal pequeño, suave y temeroso. Cuando ve algo extraño, corre a esconderse en su madriguera.',
              'El conejo es un animal pequeño suave y temeroso cuando ve algo extraño corre a esconderse en su madriguera');*/
          await getAccu();
          await getMulti();
          await getSpeed();
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Antes de Comenzar'),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                          'Asegúrese de que la evaluación se realiza en un lugar donde haya la menor interferencia de ruido externo'),
                      Text(
                          '\n Para garantizar la exactitud de la evaluación, utilice la opción de repetir la pregunta sólo cuando la voz del alumno se vea interferida por ruidos externos o alterada por un error.'),
                    ]),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('Continuar'),
                        onPressed: () {
                          Get.offNamed(RouteNames.est);
                        },
                      )
                    ],
                  ));
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (Evaluation eval in evals)
            ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                title: Text(
                    '${eval.name.toString()}  | Nota: ${double.parse(eval.grade.toString()).toStringAsFixed(2)}'),
                subtitle: Text(
                    'Edad: ${eval.age.toString()} | Grado: ${eval.course.toString()}')),
        ],
      ),
    );
  }

  @override
  void initState() {}
}

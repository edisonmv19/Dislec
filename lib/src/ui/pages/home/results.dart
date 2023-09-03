import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:select_form_field/select_form_field.dart';

final _auth = FirebaseAuth.instance;

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);
  final String title = 'Evaluación Completada';

  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () async {
                  await getEvals();
                  Get.offNamed(RouteNames.home);
                },
                icon: Icon(Icons.skip_next))
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: Text("Resultados",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orangeAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                title: Text('Exactitud : ${accuracyT.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Observacion: ${accu.toString()}'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                title: Text(
                    'Comprensión Lectora : ${comprehension.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Observacion: ${comp.toString()}'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                title: Text('Velociddad : ${speed.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Observacion: ${sp.toString()}'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Text("Resultados",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                title: Text('Calificación : ${grade.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Conclusión: ${total.toString()}'),
              ),
            ),
          ],
        ));
  }

  void getText() {
    if (accuracyT < 65.0) {
      accu =
          'Se presentaron errores constantes en la pronunciación de palabras';
    } else if (accuracyT < 85.0) {
      accu = 'Se presentaron errores puntuales en la pronunciación de palabras';
    } else {
      accu = 'Errores mínimos o inexistentes en la pronunciación de palabras';
    }

    if (comprehension < 65.0) {
      comp = 'Hubo problemas para comprender las oraciones.';
    } else if (comprehension < 85.0) {
      comp =
          'Se presentaron puntuales problemas para comprender las oraciones.';
    } else {
      comp = 'Se comprendieron casi en su totalidad todos los textos leídos.';
    }
    if (speed < 65.0) {
      sp = 'Se presenció disminución considerable en la velocidad al leer.';
    } else if (speed < 85.0) {
      sp = 'Se presenció disminución en la velocidad al leer.';
    } else {
      sp = 'Se presenció muy poca disminución en la velocidad al leer.';
    }

    if (grade < 65.0) {
      total =
          'Los resultados reflejan un nivel de lectura pobre y no adecuado a la edad del estudiante. Es aconsejable realizar una evaluación más profunda para descartar posibles problemas de aprendizaje.';
    } else if (grade < 85.0) {
      total =
          'Los resultados reflejan una lectura aceptable pero poco entrenada para la edad del alumno. Se aconseja seguir practicando la lectura y volver a realizar la prueba para mejorar el rendimiento lector.';
    } else {
      total =
          'Los resultados reflejan una lectura muy buena y entrenada para la edad del alumno. Es aconsejable seguir practicando la lectura e incorporar textos que amplíen el vocabulario del estudiante.';
    }
  }

  String accu = '';
  String comp = '';
  String sp = '';
  String total = '';

  @override
  void initState() {
    super.initState();
    getText();
  }
}

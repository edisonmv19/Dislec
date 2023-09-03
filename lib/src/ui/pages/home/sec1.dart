import 'package:avatar_glow/avatar_glow.dart';
import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:dislec/src/app/models/quiz.dart';
import 'package:dislec/src/app/controllers/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:highlight_text/highlight_text.dart';
import "dart:math";
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Section1 extends StatelessWidget {
  const Section1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exactitud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

bool _isButtonDisabled = true;

class _SpeechScreenState extends State<SpeechScreen> {
  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sección 1: Exactitud'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
              onPressed: () {
                Get.offNamed(RouteNames.accu);
              },
              child: Icon(Icons.navigate_next)),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 236, 143, 30),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(170, 230, 196, 110),
                      offset: Offset(9, 9),
                      blurRadius: 6,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Se evaluará la fidelidad de la reproducción fonética del alumno. Procurar pronunciar todas las palabras de las oraciones que se van a presentar a continuación.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ])));
  }
}

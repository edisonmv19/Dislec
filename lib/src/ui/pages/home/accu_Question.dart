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

class QuestionAccu extends StatelessWidget {
  const QuestionAccu({Key? key}) : super(key: key);

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

double _correct = 1.0;
double _repeat = 1.0;
double _incorrect = 1.0;
double _sup = 1.0;
double result = 1.0;
String _word =
    'Preciona el Botón para empezar a hablar (Volver a presionar una vez terminada la frase)';
bool _isButtonDisabled = true;

class _SpeechScreenState extends State<SpeechScreen> {
  Widget _buildCounterButton() {
    return new RaisedButton(
      child: new Text(_isButtonDisabled ? "Esperando.." : "Evaluar"),
      onPressed: counterButtonPress(context),
    );
  }

  resetCounts() {
    _correct = 1.0;
    _repeat = 1.0;
    _incorrect = 1.0;
    _sup = 1.0;
    result = 1.0;
    _text = "";
  }

  void getQues() {
    accQ.shuffle();
    question = accQ[0];
    example = question.phrase.toString();
    compareWords(question.phrase.toString());
  }

  void countResults() {
    int contcorrect = 0;
    int contrepeat = 0;
    int contincorrect = 0;
    int contsup = 0;

    String data = example.toLowerCase();
    List<String> list1 = data.split(" ");
    List<String> list2 = _text.toLowerCase().split(" ");
    int len1 = list1.length;
    int len2 = list2.length;

    if (len2 > len1) {
      contrepeat = len2 - len1;
    } else if (len2 < len1) {
      contsup = len1 - len2;
    }
    for (int i = 0; i < list2.length; i++) {
      bool incorrect = false;
      for (int y = 0; y < list1.length; y++) {
        if (list2[i] == list1[y]) {
          incorrect = true;
          contcorrect += 1;
        }
      }
      if (incorrect == false) {
        contincorrect += 1;
      }
    }
    _correct = (_correct * (contcorrect - contrepeat));
    _incorrect = (_incorrect * contincorrect);
    _repeat = (_repeat * contrepeat);
    _sup = (_sup * contsup);
    result = ((_confidence * 100) - len1) +
        _correct -
        _incorrect * 4.0 -
        _repeat * 5.0 -
        _sup * 5.0;
  }

  counterButtonPress(context) {
    if (_isButtonDisabled) {
      return null;
    } else {
      return () {
        countResults();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Resultados'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        ' Correctas: ${(_correct).toStringAsFixed(1)} \n Incorrectas: ${(_incorrect).toStringAsFixed(1)} \n Repetidas: ${(_repeat).toStringAsFixed(1)} \n Suprimidas: ${(_sup).toStringAsFixed(1)} \n '),
                    Text('\n \t Resultado: ${(result).toStringAsFixed(1)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Reintentar'),
                      onPressed: () {
                        resetCounts();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionAccu()),
                        );
                      },
                    ),
                    FlatButton(
                      child: Text('Continuar'),
                      onPressed: () {
                        accQ.remove(accQ[0]);
                        countQuestions += 1;
                        accu1 += result;
                        print(countQuestions);
                        if (countQuestions == 2) {
                          resetCounts();
                          Navigator.pop(context);
                          Get.offNamed(RouteNames.sec2);
                        } else {
                          resetCounts();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionAccu()),
                          );
                        }
                      },
                    )
                  ],
                ));
      };
    }
  }

  final Map<String, HighlightedWord> _highlights = {
    _word: HighlightedWord(
      onTap: () => print(_word),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  AccuQuiz question = AccuQuiz();
  String example = '';
  String _text = ' ';
  double _confidence = 1.0;
  List<String> exList = [];
  List<String> currList = [];

  exampleList() async {
    exList = example.split(" ");
  }

  currentList() async {
    currList = _text.split(" ");
  }

  compareWords(String ex) async {
    String data = ex.toLowerCase();
    List<String> list1 = data.split(" ");
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].length > 2) {
        if (i == 0) {
          _highlights[list1[i] + " "] = HighlightedWord(
            onTap: () => print(list1[i]),
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (i == 1) {
          _highlights[list1[i]] = HighlightedWord(
            onTap: () => print(list1[i]),
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          _highlights[" " + list1[i]] = HighlightedWord(
            onTap: () => print(list1[i]),
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _isButtonDisabled = true;
    getQues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sección 1: Exactitud'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            onPressed: _listen,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                height: 130,
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
                  example,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                    'Preciona el Botón para empezar a hablar (Volver a presionar una vez terminada la frase)'),
              ),
              _buildCounterButton(),
              Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                  child: TextHighlight(
                      text: _text,
                      words: _highlights,
                      textStyle: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ))),
            ])));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        print(DateTime.now().millisecondsSinceEpoch);
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      print(DateTime.now().millisecondsSinceEpoch);
      setState(() => _isListening = false);
      _isButtonDisabled = false;
      _speech.stop();
    }
  }
}

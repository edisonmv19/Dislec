import 'package:avatar_glow/avatar_glow.dart';
import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:dislec/src/app/models/quiz.dart';
import 'package:dislec/src/app/controllers/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:highlight_text/highlight_text.dart';
import "dart:math";
import 'package:speech_to_text/speech_to_text.dart' as stt;

class QuestionSpeedCon extends StatelessWidget {
  const QuestionSpeedCon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velocidad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
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
int t1 = 0;
int t2 = 0;
String _word =
    'Preciona el Botón para empezar a hablar (Volver a presionar una vez terminada la frase)';
bool _isButtonDisabled = true;

class _SpeechScreenState extends State<SpeechScreen> {
  Widget _buildCounterButton() {
    return new RaisedButton(
      child: new Text(_isButtonDisabled ? "Esperando.." : "Continuar"),
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

  Timer? _timer;
  double _start = 60.0;

  void startTimer() {
    const oneSec = const Duration(milliseconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0.0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start = _start - 1 / 100;
          });
        }
      },
    );
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
    time2 = (t2 - t1) / 1000.00;
    wordsSecond = len2 / (time2);
    words2 = len2;

    reason = words2 * time1 / words1;
    if (time2 > reason) {
      diference = time2 - reason;
    }
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
    accus = (accus + result) / 2;
    totalr = accus * 0.4 + (60 - diference * 2.5);
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
                        ' Palabras Pronunciadas: ${(words2).toStringAsFixed(2)} \n Tiempo: ${(time2).toStringAsFixed(2)} seg. \n Razon: ${(wordsSecond).toStringAsFixed(2)} Palabras por Segundo \n\n Exactitud: ${(result).toStringAsFixed(2)} \n '),
                    Text('\n \t Resultado: ${(totalr).toStringAsFixed(2)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold))
                  ]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Continuar'),
                      onPressed: () {
                        speed += totalr;
                        countQuestions += 1;
                        print(countQuestions);
                        Get.offNamed(RouteNames.sec3);
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
  double wordsSecond = 0.0;
  double diference = 0.0;
  double reason = 0.0;
  double totalr = 0.0;
  bool _isListening = false;
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
    getSpeedQues();

    _speech = stt.SpeechToText();
    _isButtonDisabled = true;
    example = quiz.text2.toString();
    compareWords(quiz.words2.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sección 2: Velocidad Lectora'),
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
                  color: Color.fromARGB(255, 218, 83, 65),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(170, 230, 110, 110),
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
                    border: Border.all(color: Colors.redAccent),
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
        t1 = DateTime.now().millisecondsSinceEpoch;
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
      setState(() => _isListening = false);
      t2 = DateTime.now().millisecondsSinceEpoch;
      _isButtonDisabled = false;
      _speech.stop();
    }
  }
}

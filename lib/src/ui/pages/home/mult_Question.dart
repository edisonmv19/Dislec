import 'package:avatar_glow/avatar_glow.dart';
import 'package:dislec/src/ui/pages/home/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dislec/src/ui/routes/route_names.dart';
import 'package:dislec/src/app/models/quiz.dart';
import 'package:dislec/src/app/controllers/services.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class QuestionMult extends StatelessWidget {
  const QuestionMult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exactitud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
double global = 0.0;
String resp = '';
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
    global = 0.0;
  }

  void getQues() {
    mulQ.shuffle();
    question = mulQ[0];
    example = question.phrase.toString();
    options = [
      question.option1.toString(),
      question.option2.toString(),
      question.answer.toString()
    ];
    options.shuffle();
    compareWords(question.words.toString());
  }

  void countResults() {
    int contcorrect = 0;
    int contrepeat = 0;
    int contincorrect = 0;
    int contsup = 0;

    String data = question.words.toString().toLowerCase();
    print(data);
    List<String> list1 = data.split(" ");
    List<String> list2 = _text.split(" ");
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
        _incorrect * 5.0 -
        _repeat * 5.0 -
        _sup * 5.0;
  }

  void _optionSelected(String selection) {
    countResults();
    if (selection == question.answer) {
      resp = 'Correcta';
      global = (result * 0.4) + 60.0;
    } else {
      resp = 'Incorrecta';
      global = (result * 0.4) + 10.0;
    }
  }

  counterButtonPress(context) {
    if (_isButtonDisabled) {
      return null;
    } else {
      return () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Column(children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF57B3FC),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xAA6EB1E6),
                        offset: Offset(9, 9),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Contesta la siguiente pregunta: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Text(question.question.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.indigo.shade100, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          leading: Text('${index + 1}',
                              style: Theme.of(context).textTheme.bodyText1),
                          title: Text(options[index],
                              style: Theme.of(context).textTheme.bodyText1),
                          onTap: () {
                            _optionSelected(
                              options[index],
                            );
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Resultados'),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                'Exactitud: ${(result).toStringAsFixed(1)} \n Pregunta: $resp \n '),
                                            Text(
                                                '\n \t Resultado: ${(global).toStringAsFixed(1)}%',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ]),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Reintentar'),
                                          onPressed: () {
                                            resetCounts();
                                            Get.offNamed(RouteNames.mult);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Continuar'),
                                          onPressed: () {
                                            mulQ.remove(mulQ[0]);
                                            countQuestions += 1;
                                            accu2 += result;
                                            comprehension += global;
                                            if (countQuestions == 5) {
                                              calculateGrade();
                                              bool save = Services().saveEval(
                                                  name,
                                                  age,
                                                  course,
                                                  mail,
                                                  accuracyT,
                                                  comprehension,
                                                  speed,
                                                  grade);

                                              if (save) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      'Evaluacion Registrada'),
                                                  backgroundColor: Colors.green,
                                                ));
                                                Get.offNamed(RouteNames.result);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content:
                                                      Text('Registro fallido'),
                                                  backgroundColor: Colors.red,
                                                ));
                                                Get.offNamed(RouteNames.home);
                                              }
                                            } else {
                                              resetCounts();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        QuestionMult()),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ));
                          },
                        ),
                      );
                    },
                  ),
                )
              ]);
            });
      };
    }
  }

  final Map<String, HighlightedWord> _highlights = {
    _word: HighlightedWord(
      onTap: () => print(_word),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  MultQuiz question = MultQuiz();
  String example = '';
  String _text = ' ';
  double _confidence = 1.0;
  List<String> options = [];
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
          title: Text('Sección 3: Comprensión Lectora'),
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
                  color: Color.fromARGB(255, 162, 63, 228),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(170, 184, 110, 230),
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
                    border: Border.all(color: Colors.purpleAccent),
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
      _isButtonDisabled = false;
      _speech.stop();
    }
  }
}

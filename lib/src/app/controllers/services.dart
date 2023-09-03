import 'package:get/get.dart';
import 'package:dislec/src/app/models/quiz.dart';
import 'package:dislec/src/app/models/evaluation.dart';
import 'package:firebase_database/firebase_database.dart';

class Services {
  Future<List<AccuQuiz>> getPhrases() async {
    List<AccuQuiz> phrases = [];
    try {
      DataSnapshot snap =
          await FirebaseDatabase.instance.reference().child('accu').once();
      if (snap.exists) {
        snap.value.forEach((key, value) {
          Map mapa = {'key': key, ...value};
          AccuQuiz newPhrase = AccuQuiz(
            key: mapa['key'],
            phrase: mapa['phrase'],
          );
          print(newPhrase);
          phrases.add(newPhrase);
        });
      }
      return phrases;
    } catch (e) {
      print('error conectando a BD');
      return phrases;
    }
  }

  Future<List<SpeedQuiz>> getSpeedQ() async {
    List<SpeedQuiz> texts = [];
    try {
      DataSnapshot snap =
          await FirebaseDatabase.instance.reference().child('speed').once();
      if (snap.exists) {
        snap.value.forEach((key, value) {
          Map mapa = {'key': key, ...value};
          SpeedQuiz newq = SpeedQuiz(
            key: mapa['key'],
            text1: mapa['text1'],
            words1: mapa['words1'],
            text2: mapa['text2'],
            words2: mapa['words2'],
          );
          print(newq);
          texts.add(newq);
        });
      }
      return texts;
    } catch (e) {
      print('error conectando a BD');
      return texts;
    }
  }

  Future<List<MultQuiz>> getMultQ() async {
    List<MultQuiz> multiq = [];
    try {
      DataSnapshot snap =
          await FirebaseDatabase.instance.reference().child('multi').once();
      if (snap.exists) {
        snap.value.forEach((key, value) {
          Map mapa = {'key': key, ...value};
          MultQuiz newQuiz = MultQuiz(
            key: mapa['key'],
            phrase: mapa['phrase'],
            question: mapa['question'],
            words: mapa['words'],
            option1: mapa['option1'],
            option2: mapa['option2'],
            answer: mapa['answer'],
          );
          print(newQuiz);
          multiq.add(newQuiz);
        });
      }
      return multiq;
    } catch (e) {
      print('error conectando a BD');
      return multiq;
    }
  }

  Future<List<Evaluation>> getEval() async {
    List<Evaluation> evaluations = [];
    try {
      DataSnapshot snap = await FirebaseDatabase.instance
          .reference()
          .child('evaluations')
          .once();
      if (snap.exists) {
        snap.value.forEach((key, value) {
          Map mapa = {'key': key, ...value};
          Evaluation newEval = Evaluation(
            key: mapa['key'],
            name: mapa['name'],
            age: int.parse(mapa['age'].toString()),
            course: mapa['course'],
            assessor: mapa['assessor'],
            accur: double.parse(mapa['accuracy'].toString()),
            comphren: double.parse(mapa['comprehension'].toString()),
            speed: double.parse(mapa['speed'].toString()),
            grade: double.parse(mapa['grade'].toString()),
          );
          print(newEval);
          evaluations.add(newEval);
        });
      }
      return evaluations;
    } catch (e) {
      print(e);
      return evaluations;
    }
  }

  void save(String frase, String question, String words, String option1,
      String option2, String answer) {
    try {
      FirebaseDatabase.instance.reference().child('multi').push().set(
        {
          'phrase': frase,
          'question': question,
          'words': words,
          'option1': option1,
          'option2': option2,
          'answer': answer,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void saveSpeed(String text1, String words1, String text2, String words2) {
    try {
      FirebaseDatabase.instance.reference().child('speed').push().set(
        {
          'text1': text1,
          'words1': words1,
          'text2': text2,
          'words2': words2,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  bool saveEval(String name, int age, String course, String mail,
      double accuracy, double comprehension, double speed, double grade) {
    try {
      FirebaseDatabase.instance.reference().child('evaluations').push().set(
        {
          'name': name,
          'age': age,
          'course': course,
          'assessor': mail,
          'accuracy': accuracy,
          'comprehension': comprehension,
          'speed': speed,
          'grade': grade,
        },
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

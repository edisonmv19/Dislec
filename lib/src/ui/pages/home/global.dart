import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dislec/src/app/controllers/services.dart';
import 'package:dislec/src/app/models/quiz.dart';
import 'package:dislec/src/app/models/evaluation.dart';

String name = "";
int words1 = 0;
double time1 = 0.0;
int words2 = 0;
double time2 = 0.0;
int age = 0;
String course = "";
SpeedQuiz quiz = SpeedQuiz();

String mail = "";
double accu1 = 0.0;
double accu2 = 0.0;
double accus = 0.0;
double accuracyT = 0.0;
double comprehension = 0.0;
double speed = 0.0;
double grade = 0.0;
int countQuestions = 0;

List<AccuQuiz> accQ = [];
List<MultQuiz> mulQ = [];
List<SpeedQuiz> spQ = [];
List<Evaluation> evals = [];

getAccu() async {
  accQ = await Services().getPhrases();
}

getSpeed() async {
  spQ = await Services().getSpeedQ();
}

getMulti() async {
  mulQ = await Services().getMultQ();
}

getEvals() async {
  evals = await Services().getEval();
}

void getSpeedQues() {
  spQ.shuffle();
  quiz = spQ[0];
}

void resetVar() {
  accu1 = 0.0;
  accu2 = 0.0;
  accuracyT = 0.0;
  comprehension = 0.0;
  speed = 0.0;
  countQuestions = 0;
}

void calculateGrade() {
  accuracyT = (accu1 / 2) * 0.75 + (accu2 / 2) * 0.25;
  comprehension = comprehension / 2;
  //speed = speed / 3;
  grade = accuracyT * 0.33 + comprehension * 0.33 + speed * 0.34;
  //grade = accuracyT * 0.50 + comprehension * 0.50;
}

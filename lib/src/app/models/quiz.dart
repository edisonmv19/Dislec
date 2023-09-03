class AccuQuiz {
  AccuQuiz({
    this.key,
    this.phrase,
  });
  String? key;
  String? phrase;
}

class SpeedQuiz {
  SpeedQuiz({
    this.key,
    this.text1,
    this.words1,
    this.text2,
    this.words2,
  });
  String? key;
  String? text1;
  String? words1;
  String? text2;
  String? words2;
}

class MultQuiz {
  MultQuiz({
    this.key,
    this.phrase,
    this.question,
    this.words,
    this.option1,
    this.option2,
    this.answer,
  });
  String? key;
  String? phrase;
  String? question;
  String? words;
  String? option1;
  String? option2;
  String? answer;
}

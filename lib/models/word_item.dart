import 'package:card_game/models/word_sence.dart';
import 'package:card_game/models/word_sentense.dart';
import  'package:string_similarity/string_similarity.dart';

class WordItem implements MatchableDictionaryWord {

  @override
  int? index;
  @override
  String? word;
  @override
  WordSence? sence;
  List<int>? lesson;
  WordSentence? sentence;
  List<MatchableDictionaryWord>? wordForms;
  List<MatchableDictionaryWord>? cognateWords;
  List<DictionaryWord>? similarWords;
  List<DictionaryWord>? antonymsWords;
  DateTime? lastLearnTime;
  int? periodLearnTime;

  WordItem(
      {this.index,
      this.word,
      this.sence,
      this.lesson,
      this.sentence,
      this.wordForms,
      this.cognateWords,
      this.similarWords,
      this.antonymsWords,
      this.lastLearnTime,
      this.periodLearnTime});

  WordItem.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    word = json['word'];
    sence = json['sence'] != null ? WordSence.fromJson(json['sence']) : null;
    lesson = json["lesson"] != null ? json['lesson'].cast<int>() : null;
    lastLearnTime = json["learnTime"] != null ? DateTime.parse(json["learnTime"]) : null;
    periodLearnTime = json['learnTimePeriod'];
    sentence = json['sentence'] != null
        ? WordSentence.fromJson(json['sentence'])
        : null;
    if (json['word forms'] != null) {
      wordForms = <MatchableDictionaryWord>[];
      json['word forms'].forEach((v) {
        wordForms!.add(MatchableDictionaryWord.fromJson(v));
      });
    }
    if (json['cognate words'] != null) {
      cognateWords = <MatchableDictionaryWord>[];
      json['cognate words'].forEach((v) {
        cognateWords!
            .add(MatchableDictionaryWord.fromJson(v));
      });
    }
    if (json['similar words'] != null) {
      similarWords = <DictionaryWord>[];
      json['similar words'].forEach((v) {
        similarWords!.add(DictionaryWord.fromJson(v));
      });
    }
    if (json['antonyms words'] != null) {
      antonymsWords = <DictionaryWord>[];
      json['antonyms words'].forEach((v) {
        antonymsWords!.add(DictionaryWord.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (index != null) data['index'] = index;
    data['word'] = word;
    if (sence != null) {
      data['sence'] = sence!.toJson();
    }
    data['lesson'] = lesson;
    if (lastLearnTime!=null) data["learnTime"] = lastLearnTime?.toIso8601String();
    if (periodLearnTime!=null) data['learnTimePeriod'] = periodLearnTime;

    if (sentence != null) {
      data['sentence'] = sentence!.toJson();
    }
    if (wordForms != null) {
      data['word forms'] = wordForms!.map((v) => v.toJson()).toList();
    }
    if (cognateWords != null) {
      data['cognate words'] = cognateWords!.map((v) => v.toJson()).toList();
    }
    if (similarWords != null) {
      data['similar words'] = similarWords!.map((v) => v.toJson()).toList();
    }
    if (antonymsWords != null) {
      data['antonyms words'] = antonymsWords!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  double symbolsMatch(String matching) {

    var dist = word?.similarityTo(matching) ?? 0;
    print("match dist of $word = $dist with word $matching");
    //return dist;
    if (dist == 1) return dist;

    wordForms?.forEach((element) async {
      var matchedNumbs = element.symbolsMatch(matching);
      if (dist < matchedNumbs) dist = matchedNumbs;
      if (dist == 1) return;
    });
    if (dist == 1) return dist;

    cognateWords?.forEach((element) async {
      var matchedNumbs = element.symbolsMatch(matching);
      if (dist < matchedNumbs) dist = matchedNumbs;
      if (dist == 1) return;
    });

    return dist;
  }

  bool shouldBePicked() {
    if(lastLearnTime == null || periodLearnTime == null) return true;
    return false;
  }
  bool shouldBeLearn() {
    if(lastLearnTime == null || periodLearnTime == null) return true;
    if(DateTime.now().difference(lastLearnTime!).inDays > periodLearnTime!) return true;
    if(periodLearnTime! <= 2) return true;
    return false;
  }
}

class MatchableDictionaryWord extends DictionaryWord {
  double symbolsMatch(String matching) {
    return word?.similarityTo(matching) ?? 0;
  }
  MatchableDictionaryWord({int? index, String? word, WordSence? sence}) :
        super(index: index, word: word, sence: sence);

  MatchableDictionaryWord.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    word = json['word'];
    sence = json['sence'] != null ? WordSence.fromJson(json['sence']) : null;
  }
}

class DictionaryWord {
  int? index;
  String? word;
  WordSence? sence;

  DictionaryWord({this.index, this.word, this.sence});

  DictionaryWord.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    word = json['word'];
    sence = json['sence'] != null ? WordSence.fromJson(json['sence']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
    if (index != null) data['index'] = index;
    if (sence != null) {
      data['sence'] = sence!.toJson();
    }
    return data;
  }
}

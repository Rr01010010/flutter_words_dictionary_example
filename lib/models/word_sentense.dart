
class WordSentence {
  String? nlSentence;
  String? ruSentence;
  String? enSentence;

  WordSentence({this.nlSentence, this.ruSentence, this.enSentence});

  WordSentence.fromJson(Map<String, dynamic> json) {
    nlSentence = json['nl_sentence'];
    ruSentence = json['ru_sentence'];
    enSentence = json['en_sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nl_sentence'] = nlSentence;
    data['ru_sentence'] = ruSentence;
    data['en_sentence'] = enSentence;
    return data;
  }
}
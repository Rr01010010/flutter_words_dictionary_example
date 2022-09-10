class WordSence {
  List<String> nl = [];
  List<String> ru = [];
  List<String> en = [];

  WordSence({List<String>? nl, List<String>? ru, List<String>? en})
      : nl = nl ?? [],
        ru = ru ?? [],
        en = en ?? [];

  WordSence.fromJson(Map<String, dynamic> json) {
    nl = (json['nl'] ?? []).cast<String>();
    ru = (json['ru'] ?? []).cast<String>();
    en = (json['en'] ?? []).cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nl'] = nl;
    data['ru'] = ru;
    data['en'] = en;
    return data;
  }
}

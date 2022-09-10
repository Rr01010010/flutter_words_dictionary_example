import 'dart:convert';

import 'package:card_game/firebase/fire_store.dart';
import 'package:card_game/models/word_item.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordsDictionaryController extends GetxController {
  late SharedPreferences? sharedPreferences;

  Future<WordsDictionaryController> init({bool reInit = false}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences!.getString("words");

    if (data == null || reInit) {
      print("init DATA");
      var nl =
          (await store.database.collection("words").doc("nl").get()).data();
      var ru =
          (await store.database.collection("words").doc("ru").get()).data();
      var en =
          (await store.database.collection("words").doc("en").get()).data();

      if (nl != null) {
        nlWords.value = (nl["words"] as List).map((v) {
          return WordItem.fromJson(v);
        }).toList();

        saveData["nl"] = nl["words"];
      }

      if (ru != null) {
        ruWords.value = (ru["words"] as List).map((v) {
          return WordItem.fromJson(v);
        }).toList();

        saveData["ru"] = ru["words"];
      }
      if (en != null) {
        enWords.value = (en["words"] as List).map((v) {
          return WordItem.fromJson(v);
        }).toList();

        saveData["en"] = en["words"];
      }
      print("READY DATA");

      sharedPreferences!.setString("words", jsonEncode(saveData));
    } else {
      print("Чтение из памяти устройства");
      try {
        var mapJson = jsonDecode(data);
        var nl = mapJson["nl"];
        var ru = mapJson["ru"];
        var en = mapJson["en"];
        if (nl != null) {
          nlWords.value = (nl as List).map((v) {
            return WordItem.fromJson(v);
          }).toList();
          saveData["nl"] = nl;
        }
        if (ru != null) {
          ruWords.value = (ru as List).map((v) {
            return WordItem.fromJson(v);
          }).toList();
          saveData["ru"] = ru;
        }
        if (en != null) {
          enWords.value = (en as List).map((v) {
            return WordItem.fromJson(v);
          }).toList();
          saveData["en"] = en;
        }
        print("Успешно прочитано");
      } catch (e) {
        print("Ошибка прочтения джейсона из памяти - $e");
      }
    }

    return this;
  }

  FireStore get store => Get.find<FireStore>();

  final Map<String, dynamic> saveData = <String, dynamic>{};
  RxList<WordItem> nlWords = RxList([]);
  RxList<WordItem> ruWords = RxList([]);
  RxList<WordItem> enWords = RxList([]);

  List<WordItem> chooseWordsList({LangType? type}) {
    switch (type ?? _learningLang.value) {
      case LangType.none:
        return [];
      case LangType.ru:
        return ruWords.value;
      case LangType.nl:
        return nlWords.value;
      case LangType.en:
        return enWords.value;
    }
  }

  void savingPickingList(List<WordItem> pickingList) {
    if (sharedPreferences == null) return;
    switch (_learningLang.value) {
      case LangType.none:
        break;
      case LangType.ru:
        saveData["ru"] = pickingList.map((e) => e.toJson()).toList();
        break;
      case LangType.nl:
        saveData["nl"] = pickingList.map((e) => e.toJson()).toList();
        break;
      case LangType.en:
        saveData["en"] = pickingList.map((e) => e.toJson()).toList();
        break;
    }
    sharedPreferences!.setString("words", jsonEncode(saveData));
  }

  RxList<WordItem> learningWords = RxList([]);
  final Rx<LangType> _learningLang = Rx(LangType.none);
  LangType get learningLang => _learningLang.value;
  set learningLang(LangType langType) {
    _learningLang.value = langType;
    switch (_learningLang.value) {
      case LangType.none:
        learningWords.value = [];
        lockedTraining.value = true;
        break;
      case LangType.ru:
        lockedTraining.value = ruWords.any((element) =>
            element.periodLearnTime == null || element.lastLearnTime == null);
        learningWords.value = ruWords
            .where((p0) =>
                lockedTraining.value ? p0.shouldBePicked() : p0.shouldBeLearn())
            .toList();
        break;
      case LangType.nl:
        lockedTraining.value = nlWords.any((element) =>
            element.periodLearnTime == null || element.lastLearnTime == null);
        learningWords.value = nlWords
            .where((p0) =>
                lockedTraining.value ? p0.shouldBePicked() : p0.shouldBeLearn())
            .toList();
        break;
      case LangType.en:
        lockedTraining.value = enWords.any((element) =>
            element.periodLearnTime == null || element.lastLearnTime == null);
        learningWords.value = enWords
            .where((p0) =>
                lockedTraining.value ? p0.shouldBePicked() : p0.shouldBeLearn())
            .toList();
        break;
    }
    learningWords.shuffle();
  }
  Rx<LangType> nativeLang = Rx(LangType.none);
  RxBool lockedTraining = true.obs;

  RxBool searching = false.obs;
  Future<void> startSearch(List<WordItem> list, String text) async {
    searching.value = true;
    try{
      Map<int, List<WordItem>> similar = {};

      print("startSearch process 1");
      for (var element in list) {
        var match = (element.symbolsMatch(text) * 1000) ~/1;
        if (similar[match] == null) similar[match] = [];
        similar[match]!.add(element);
      }
      print("startSearch process 2 similar match map agregated");

      searchResult.value = [];
      for(int i = 1000; i > 0; i--) {
        if(similar.containsKey(i)) {
          if(similar[i] != null && similar[i]!.isNotEmpty) {
            searchResult.addAll(similar[i]!);
          }
        }
      }
      var similarJson = similar.map((key, value) =>
          MapEntry(key, value.map((e) => e.word).toList()),
      );


      print("startSearch process 3 to json $similarJson");
      //print("similar : ${jsonEncode(similarJson)}");
    }
    catch(e) {
      print("search error - $e");
    }

    searching.value = false;
  }
  RxList<WordItem> searchResult = RxList<WordItem>([]);
}

enum LangType { none, nl, ru, en }

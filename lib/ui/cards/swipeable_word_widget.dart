import 'package:card_game/models/word_item.dart';
import 'package:card_game/ui/cards/card_sentence_widget.dart';
import 'package:card_game/ui/cards/card_word_widget.dart';
import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeableWordWidget extends GetView<WordsDictionaryController> {
  SwipeableWordWidget(
      {Key? key, required this.useCardWidget, required this.words})
      : super(key: key);
  final List<WordItem> words;
  final bool useCardWidget;
  int indexWord = 0;

  @override
  Widget build(BuildContext context) {
    return SwipeCards(
      matchEngine: MatchEngine(
          swipeItems: words
              .map(
                (e) => SwipeItem(likeAction: () {
                  if (e.index == null) return;
                  print("like : ");
                  if (words[indexWord].periodLearnTime == null) {
                    words[indexWord].periodLearnTime = 8;
                  } else {
                    words[indexWord].periodLearnTime =
                        words[indexWord].periodLearnTime! * 2;
                    if (words[indexWord].periodLearnTime! > 512) {
                      words[indexWord].periodLearnTime = 512;
                    }
                  }
                  words[indexWord].lastLearnTime = DateTime.now();
                  print("words[$indexWord] : ${words[indexWord].toJson()}");
                  print(
                      "pickedWords[${e.index}] : ${controller.chooseWordsList()[e.index!].toJson()}");
                  controller.chooseWordsList()[e.index!] = words[indexWord];
                  controller.savingPickingList(controller.chooseWordsList());
                  indexWord++;
                }, nopeAction: () {
                  if (e.index == null) return;
                  if (words[indexWord].periodLearnTime == null) {
                    words[indexWord].periodLearnTime = 2;
                  } else {
                    words[indexWord].periodLearnTime =
                        words[indexWord].periodLearnTime! ~/ 2;
                    if (words[indexWord].periodLearnTime! <= 2) {
                      words[indexWord].periodLearnTime = 2;
                    }
                  }
                  words[indexWord].lastLearnTime = DateTime.now();
                  print("words[$indexWord] : ${words[indexWord].toJson()}");
                  print(
                      "pickedWords[${e.index}] : ${controller.chooseWordsList()[e.index!].toJson()}");
                  controller.chooseWordsList()[e.index!] = words[indexWord];
                  controller.savingPickingList(controller.chooseWordsList());
                  indexWord++;
                }),
              )
              .toList()),
      onStackFinished: () {},
      itemBuilder: (BuildContext context, int index) {
        return useCardWidget
            ? CardWordWidget(words[index], controller.nativeLang.value)
            : CardSentenceWidget(words[index], controller.nativeLang.value);
      },
    );
  }
}

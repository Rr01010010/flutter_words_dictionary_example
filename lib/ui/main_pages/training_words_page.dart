import 'package:card_game/ui/cards/swipeable_word_widget.dart';
import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingWordsPage extends StatelessWidget {
  const TrainingWordsPage(this.native, this.learning,
      {Key? key, required this.useCardWidget})
      : super(key: key);
  final LangType native;
  final LangType learning;
  final bool useCardWidget;

  @override
  Widget build(BuildContext context) => Obx(() {
        return Scaffold(
          body: SafeArea(
            child: Column(children: [
              Center(child: Text("Learning Language : ${learning.name}")),
              Center(child: Text("Native Language : ${native.name}")),
              const Divider(),
              Flexible(
                  child: Center(
                child: (native == LangType.none || learning == LangType.none)
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Не выбран родной язык или изучаемый язык"),
                      )
                    : SwipeableWordWidget(
                        words: (Get.find<WordsDictionaryController>()
                            .learningWords
                            .toList()),
                        useCardWidget:
                            useCardWidget
                        ),
              ))
            ]),
          ),
        );
      });
}

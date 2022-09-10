import 'package:card_game/ui/main_pages/training_words_page.dart';
import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WordsLearningPage extends GetView<WordsDictionaryController> {
  const WordsLearningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
        return Scaffold(
          body: SafeArea(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Learning Language"),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: controller.learningLang.index,
                    items: LangType.values
                        .map(
                          (type) => DropdownMenuItem<int>(
                            value: type.index,
                            child: Text(
                              type.name,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (index) {
                      controller.learningLang = LangType.values[index ?? 0];
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Native Language"),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: controller.nativeLang.value.index,
                    items: LangType.values
                        .map(
                          (type) => DropdownMenuItem<int>(
                            value: type.index,
                            child: Text(
                              type.name,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (index) {
                      controller.nativeLang.value = LangType.values[index ?? 0];
                    },
                  ),
                ],
              ),
              const Divider(),
              Flexible(
                child: (controller.nativeLang.value == LangType.none ||
                        controller.learningLang == LangType.none)
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Выберите родной язык и изучаемый язык"),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: controller.lockedTraining.value
                                      ? () {
                                          Get.to(TrainingWordsPage(
                                              controller.nativeLang.value,
                                              controller.learningLang,
                                              useCardWidget: true));
                                        }
                                      : null,
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Text(
                                        "Калибровка приложения под ваш уровень знания слов языка"),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: controller.lockedTraining.value
                                      ? null
                                      : () {
                                          Get.to(TrainingWordsPage(
                                              controller.nativeLang.value,
                                              controller.learningLang,
                                              useCardWidget: false));
                                        },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Тренировка на знание слов"),
                                  )),
                            ),
                          ),
                        ],
                      ),
              )
            ]),
          ),
        );
      });
}

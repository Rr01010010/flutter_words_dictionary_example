import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:card_game/ui/cards/card_word_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DictionaryFinderPage extends GetView<WordsDictionaryController> {
  DictionaryFinderPage({Key? key}) : super(key: key);

  final Rx<LangType> languageSearch = LangType.none.obs;
  final TextEditingController textController = TextEditingController();
  final RxBool textControllerIsNotEmpty = false.obs;

  @override
  Widget build(BuildContext context) => Obx(() {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Learning Language"),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: languageSearch.value.index,
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
                        languageSearch.value = LangType.values[index ?? 0];
                      },
                    ),
                  ],
                ),
                TextField(
                  onChanged: (str) {
                    textControllerIsNotEmpty.value =
                        textController.text.isNotEmpty;
                  },
                  controller: textController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade400,
                      //focusColor: Colors.grey.shade500,
                      //hoverColor: Colors.grey.shade700,
                      border: const OutlineInputBorder()),
                  minLines: 5,
                  maxLines: 10,
                ),
                Expanded(
                  child: controller.searching.value
                      ? const CircularProgressIndicator(
                          color: Colors.black87,
                        )
                      : ListView(
                          children: controller.searchResult
                              .map((element) => SizedBox(
                                    height: 200,
                                    child: CardWordWidget(element, LangType.ru,
                                        swipeable: false),
                                  ))
                              .toList(),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: languageSearch.value != LangType.none &&
                                textControllerIsNotEmpty.value
                            ? () async {
                                controller.startSearch(
                                    controller
                                        .chooseWordsList(
                                            type: languageSearch.value)
                                        .toList(),
                                    textController.text);
                              }
                            : null,
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text("Искать слово"),
                        )),
                  ),
                ),
              ]),
            ),
          ),
        );
      });
}

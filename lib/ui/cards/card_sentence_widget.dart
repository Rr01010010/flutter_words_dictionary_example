import 'package:card_game/models/word_item.dart';
import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSentenceWidget extends StatelessWidget {
  final WordItem wordData;
  final LangType nativeLang;

  const CardSentenceWidget(this.wordData, this.nativeLang, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HiddenWidget(
            hide: true,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        wordData.word ?? "???",
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w600),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                        children: nativeLang == LangType.nl
                            ? wordData.sence?.nl.map((e) => Text(e)).toList() ??
                                []
                            : nativeLang == LangType.ru
                                ? wordData.sence?.ru
                                        .map((e) => Text(e))
                                        .toList() ??
                                    []
                                : nativeLang == LangType.en
                                    ? wordData.sence?.en
                                            .map((e) => Text(e))
                                            .toList() ??
                                        []
                                    : []),
                  ],
                ),
                if (wordData.wordForms?.isNotEmpty ?? false)
                  const Text("Word forms : "),
                Wrap(
                    children: wordData.wordForms
                            ?.map((e) => wordTag(e.word))
                            .toList() ??
                        []),
                if (wordData.cognateWords?.isNotEmpty ?? false)
                  const Text("Cognate forms : "),
                Wrap(
                    children: wordData.cognateWords
                            ?.map((e) => wordTag(e.word))
                            .toList() ??
                        []),
                if (wordData.similarWords?.isNotEmpty ?? false)
                  const Text("Similar forms : "),
                Wrap(
                    children: wordData.similarWords
                            ?.map((e) => wordTag(e.word))
                            .toList() ??
                        []),
                if (wordData.antonymsWords?.isNotEmpty ?? false)
                  const Text("Antonyms forms : "),
                Wrap(
                    children: wordData.antonymsWords
                            ?.map((e) => wordTag(e.word))
                            .toList() ??
                        []),
              ],
            ),
          ),
          const Spacer(),
          Center(
            child: Obx(() {
              const TextStyle style =
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
              switch (Get.find<WordsDictionaryController>().learningLang) {
                case LangType.nl:
                  return Text(wordData.sentence?.nlSentence ?? "???",
                      style: style);
                case LangType.ru:
                  return Text(wordData.sentence?.ruSentence ?? "???",
                      style: style);
                case LangType.en:
                  return Text(wordData.sentence?.enSentence ?? "???",
                      style: style);
                case LangType.none:
                  return const Text("Выберите изучаемый язык и родной язык");
              }
            }),
          ),
          const Spacer(),
          Row(children: const [
            Text(
              "Unknown",
              style: TextStyle(color: Colors.red),
            ),
            Spacer(),
            Text(
              "Known",
              style: TextStyle(color: Colors.green),
            ),
          ])
        ]));
  }

  Widget wordTag(String? word) {
    if (word == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade600, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(2),
      child: Text(
        word,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),
      ),
    );
  }
}

class HiddenWidget extends StatelessWidget {
  final RxBool hidden = true.obs;
  final Widget? child;

  HiddenWidget({Key? key, required bool hide, required this.child})
      : super(key: key) {
    hidden.value = hide;
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        return GestureDetector(
          onTap: () => hidden.value = !hidden.value,
          child: hidden.value
              ? Expanded(
                  child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text("Посмотреть слово и его значение"),
                  ),
                ))
              : child ?? const SizedBox(),
        );
      });
}

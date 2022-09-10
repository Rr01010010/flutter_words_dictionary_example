import 'package:card_game/main_bindings.dart';
import 'package:card_game/ui/main_pages/dictionary_finder_page.dart';
import 'package:card_game/ui/main_pages/words_learning_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends GetView<BottomNavigationController> {
  MainPage({Key? key}) : super(key: key);

  final screens = [
    const WordsLearningPage(),
    DictionaryFinderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[controller.chosenPage]),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return Obx(() => BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: controller.chosenPage,
      //fixedColor: AppColors.black700,
      showUnselectedLabels: false,
      selectedLabelStyle:
      const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      onTap: (index) => controller.chosenPage = index,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.edit),
          activeIcon: const Icon(Icons.edit),
          //SvgPicture.asset("assets/svg/icon_bottom_wallet.svg", color: AppColors.black200),
          //activeIcon: SvgPicture.asset("assets/svg/icon_bottom_wallet.svg"),
          label: "Words Learning".tr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          activeIcon: const Icon(Icons.book),
          //icon: SvgPicture.asset("assets/svg/icon_bottom_swap.svg", color: AppColors.black200),
          //activeIcon: SvgPicture.asset("assets/svg/icon_bottom_swap.svg"),
          label: "Words Dictionary".tr,
        ),
      ],
    ));
  }
}

import 'package:card_game/controllers/words_dictionary_controller.dart';
import 'package:card_game/firebase/fire_auth.dart';
import 'package:card_game/firebase/fire_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationController>(() {
      return BottomNavigationController();
    });
  }


  static FirebaseApp? app;
  static Future<void> registration({FirebaseApp? app}) async {
    var fAuth = FireAuth();
    var fStore = FireStore();
    await Get.putAsync<FireAuth>(() => fAuth.init());//(app: app));
    await Get.putAsync<FireStore>(() => fStore.init());//(app: app));
    Get.lazyPut(() => WordsDictionaryController());
  }
  static Future<void> continueInitWithAuth() async {
    Get.find<WordsDictionaryController>().init();
  }

}

class BottomNavigationController extends GetxController {
  final _chosenPage = 0.obs;

  get chosenPage => _chosenPage.value;

  set chosenPage(value) => _chosenPage.value = value;
}

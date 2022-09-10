
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FireStore extends GetxController {
  late FirebaseFirestore database;

  Future<FireStore> init({FirebaseApp? app}) async {
    database = (app == null ? FirebaseFirestore.instance : FirebaseFirestore.instanceFor(app: app));

    return this;
  }
}
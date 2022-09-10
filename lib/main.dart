import 'package:card_game/firebase/firebase_options.dart';
import 'package:card_game/main_bindings.dart';
import 'package:card_game/ui/starter_page/sign_app_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MainBinding.app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MainBinding.registration(app:MainBinding.app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MainBinding(),
      home: SignAppPage(),
    );
  }
}

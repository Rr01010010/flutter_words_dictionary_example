import 'package:card_game/main_bindings.dart';
import 'package:card_game/ui/starter_page/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth extends GetxController {
  Future<FireAuth> init({FirebaseApp? app}) async {
    fAuth = (app == null ? FirebaseAuth.instance : FirebaseAuth.instanceFor(app: app));

    bool status = await loadAuthStatus();
    if (status) await tryGoogleAuth();

    return this;
  }
  late FirebaseAuth fAuth;

  final gsi = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive']);
  Future<bool> loadAuthStatus() async => await gsi.isSignedIn();

  final Rx<UserCredential?> _userCredential = Rx<UserCredential?>(null);
  UserCredential? get userCredential => _userCredential.value;
  set userCredential(UserCredential? val) => _userCredential.value = val;

  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;
  set user(User? val) {
    if (val != null && _user.value == null) {Get.off(MainPage());
      MainBinding.continueInitWithAuth();
    }
    _user.value = val;
  }



  Future<User?> tryEmailAuth(String mail, String password) async {
    try {
      print("user == null - ${user == null}");
      var result = await fAuth.signInWithEmailAndPassword(email: mail, password: password);
      print("EMAIL Tag : googleUser - ${result.toString()}");

      userCredential = result;
      if(userCredential!=null) user = userCredential!.user;
      //userCredential = result;
      //if (userCredential != null) user = userCredential!.user;
      return user;
    } catch (e, st) {
      print("Error: $e - $st");
      FirebaseCrashlytics.instance
          .log("Cannot logging for some problem : $e - $st");
      return null;
    }
  }


  Future<User?> tryRegistration(String mail, String password) async {
    try {
      print("user == null - ${user == null}");
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      //var result = await fAuth.signInWithEmailAndPassword(email: mail, password: password);
      print("EMAIL Tag : googleUser - ${result.toString()}");

      userCredential = result;
      if(userCredential!=null) user = userCredential!.user;
      //userCredential = result;
      //if (userCredential != null) user = userCredential!.user;
      return user;
    } catch (e, st) {
      print("Error: $e - $st");
      FirebaseCrashlytics.instance
          .log("Cannot logging for some problem : $e - $st");
      return null;
    }
  }

  Future<User?> tryGoogleAuth() async {
    try {
      print("user == null - ${user == null}");
      final GoogleSignInAccount? googleUser = await gsi.signIn();
      print("Google Tag : googleUser - ${googleUser.toString()}");

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      print("Google Tag : googleAuth - ${googleAuth.toString()}");

      final oauthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("Google Tag : oauthCredential - ${oauthCredential.toString()}");

      var ucr = await fAuth.signInWithCredential(oauthCredential);
      print("Google Tag : userCredential - ${userCredential.toString()}");
      userCredential = ucr;
      if (userCredential != null) user = userCredential!.user;
      return user;
    } catch (e, st) {
      print("Error: $e - $st");
      FirebaseCrashlytics.instance
          .log("Cannot logging for some problem : $e - $st");
      return null;
    }
  }

  Future<User?> reauthenticateWithCredential() async {
    if (user == null || userCredential!.credential == null) return null;
    userCredential =
        await user!.reauthenticateWithCredential(userCredential!.credential!);
    if (userCredential != null) user = userCredential!.user;
    return user;
  }
}

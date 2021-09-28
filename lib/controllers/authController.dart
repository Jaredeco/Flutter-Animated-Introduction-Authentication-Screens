import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:login/constants/firebase.dart';
import 'package:get/get.dart';
import 'package:login/screens/introduction_animation/introduction_animation_screen.dart';
import 'package:login/widgets/authentication/loadingDialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/screens/main/homeScreen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rx<User>? firebaseUser;
  RxBool isLoggedIn = false.obs;
  RxBool isLoginWidgetDisplayed = true.obs;
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onReady() {
    super.onReady();
    auth.userChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(() => IntroductionAnimationScreen());
      } else {
        Get.offAll(() => HomeScreen(), transition: Transition.rightToLeft, duration: Duration(seconds: 1, milliseconds: 300));
      }
    });
  }

  changeDisplayedAuthWidget(bool login) {
    isLoginWidgetDisplayed.value = login;
  }

  void signIn() async {
    try {
      startLoading();
      await auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      dismissLoading();
    } on FirebaseAuthException catch (e) {
      dismissLoading();
      Get.snackbar("Sign In Failed", e.message.toString());
    }
  }

  void signUp() async {
    try {
      startLoading();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _uid = result.user!.uid;
        _addUserToDatabase(_uid);
      });
      dismissLoading();
    } on FirebaseAuthException catch (e) {
      dismissLoading();
      Get.snackbar("Sign Up Failed", e.message.toString());
    }
  }

  void signInWGoogle() async {
    try {
      startLoading();
      GoogleSignInAccount? _account = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _account!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      String _uid =
          (await auth.signInWithCredential(credential)).user!.uid.toString();
      dismissLoading();
    }catch (e) {
      dismissLoading();
      Get.snackbar("Sign In Failed", e.toString());
    }
  }

  void signOut() async {
    startLoading();
    auth.signOut();
    dismissLoading();
  }

  _addUserToDatabase(String uid) {
    firebaseFirestore.collection("Users").doc(uid).set({
      "userName": userName.text.trim(),
      "uid": uid,
      "email": email.text.trim(),
    });
  }

  void sendResetEmail(String email) async {
    try {
      auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Email sent!",
          "An email with link to reset your password has been sent to your email.");
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    }
  }
}

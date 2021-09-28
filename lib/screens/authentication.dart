import 'package:login/controllers/authController.dart';
import 'package:login/widgets/authentication/bottomText.dart';
import 'package:login/widgets/authentication/logIn.dart';
import 'package:login/widgets/authentication/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() => SingleChildScrollView(
          child: Stack(
            children: [
              // Image.asset(
              //   bg,
              //   width: double.infinity,
              //   height: Get.height,
              //   fit: BoxFit.cover,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height*0.3),
                  Visibility(
                      visible: _authController.isLoginWidgetDisplayed.value,
                      child: LoginWidget()),
                  Visibility(
                      visible: !_authController.isLoginWidgetDisplayed.value,
                      child: RegistrationWidget()),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _authController.isLoginWidgetDisplayed.value,
                    child: BottomTextWidget(
                      onTap: () {
                        _authController.changeDisplayedAuthWidget(!_authController.isLoginWidgetDisplayed.value);
                      },
                      text1: "Don\'t have an account?",
                      text2: "Create account!",
                    ),
                  ),
                  Visibility(
                    visible: !_authController.isLoginWidgetDisplayed.value,
                    child: BottomTextWidget(
                      onTap: () {
                        _authController.changeDisplayedAuthWidget(!_authController.isLoginWidgetDisplayed.value);
                      },
                      text1: "Already have an account?",
                      text2: "Sign in!",
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ],
          ),
        ),)
    );
  }
}
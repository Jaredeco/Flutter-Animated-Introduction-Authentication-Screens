import 'package:flutter/material.dart';
import 'package:login/constants/controllers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: Center(
      child: ElevatedButton(
        onPressed: () {
          authController.signOut();
        },
        child: Text("Sign Out!"),
      ),
    ));
  }
}

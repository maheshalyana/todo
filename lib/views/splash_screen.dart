import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/auth_view.dart';
import 'package:todo/views/task_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 2),
        () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FirebaseAuth.instance.currentUser == null
                              ? LoginScreen()
                              : TaskList()),
                  (route) => false)
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.05, top: height * 0.05),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Text(
          'ToDo',
          style: TextStyle(
            fontSize: 36,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    // Ko delay thi gap loi de
    Future.delayed(Duration(seconds: 5), (){
      Navigator.pushReplacementNamed(context, '/home');
    });
    // Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Center(
                child: SpinKitPouringHourGlassRefined(
                  color: Colors.brown.shade800,
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

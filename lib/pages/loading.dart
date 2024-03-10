import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 6), (){
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/loading-bg.png'),
        //     fit: BoxFit.cover
        //   ),
        // ),
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Coffee Shop App',
              //   style: TextStyle(
              //     fontSize: 50,
              //     fontWeight: FontWeight.w700
              //   ),
              //   textAlign: TextAlign.center,
              // ),
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

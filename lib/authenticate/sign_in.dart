import 'package:coffee_shop/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Sign in Anon'),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null){
              print('Error signing in');
            } else {
              print('signed in');
              print(result.uid);
            }
          },
          child: Text(
            "Hello",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
          ),
        ),
      ),
    );
  }
}

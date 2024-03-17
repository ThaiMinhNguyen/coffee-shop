import 'package:coffee_shop/authenticate/register.dart';
import 'package:coffee_shop/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Autheticate extends StatefulWidget {

  @override
  State<Autheticate> createState() => _AutheticateState();
}

class _AutheticateState extends State<Autheticate> {

  bool isSignin = true;

  @override
  Widget build(BuildContext context) {
    if(isSignin) {
      return SignIn();
    } else {
      return Register();
    }
  }
}

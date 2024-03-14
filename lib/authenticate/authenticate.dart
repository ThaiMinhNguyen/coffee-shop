import 'package:coffee_shop/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Autheticate extends StatelessWidget {
  const Autheticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}

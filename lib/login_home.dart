import 'package:coffee_shop/entity/user.dart';
import 'package:coffee_shop/pages/wrapper.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginHome extends StatefulWidget {

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        initialData: null,
        value: AuthService().user,
        child: Wrapper(),
    );
  }
}

import 'package:coffee_shop/authenticate/authenticate.dart';
import 'package:coffee_shop/entity/user.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if(user == null){
      return Autheticate();
    } else {
      return StartPage();
    }
  }
}

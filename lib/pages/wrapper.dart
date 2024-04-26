import 'package:coffee_shop/authenticate/authenticate.dart';
import 'package:coffee_shop/entity/user.dart';
import 'package:coffee_shop/pages/admin_home.dart';
import 'package:coffee_shop/pages/role_wrapper.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Wrapper extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if(user == null){
      return Autheticate();
    } else {
      return RoleWrapper();
    }
  }

}


// if (DatabaseService(uid: user.uid!).getUserRole() == 'user') {
// return StartPage();
// } else if (DatabaseService(uid: user.uid!).getUserRole() == 'admin') {
// return AdminHome();
import 'package:coffee_shop/authenticate/sign_in.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/user.dart';
import '../services/database.dart';
import 'admin_home.dart';

class RoleWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserRole(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final role = snapshot.data;
          if (role == 'user') {
            return StartPage();
          } else if (role == 'admin') {
            return AdminHome();
          } else {
            return SignIn();
          }
        }
      },
    );
  }

  Future<String> getUserRole(BuildContext context) async {
    final user = Provider.of<MyUser?>(context, listen: false);
    if (user != null) {
      return await DatabaseService(uid: user.uid!).getUserRole();
    } else {
      return 'guest'; // Trả về giá trị mặc định nếu user là null
    }
  }
}

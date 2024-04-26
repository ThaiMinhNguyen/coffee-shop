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
          // Trường hợp Future chưa hoàn thành, có thể hiển thị màn hình chờ ở đây.
          return CircularProgressIndicator(); // Ví dụ: Hiển thị màn hình chờ
        } else if (snapshot.hasError) {
          // Xử lý lỗi nếu có
          return Text('Error: ${snapshot.error}');
        } else {
          // Dựa vào kết quả của Future để quyết định hiển thị Widget nào.
          final role = snapshot.data;
          if (role == 'user') {
            return StartPage();
          } else if (role == 'admin') {
            return AdminHome();
          } else {
            // Xử lý trường hợp không xác định hoặc không có vai trò
            return Text('Undefined role');
          }
        }
      },
    );
  }

  Future<String> getUserRole(BuildContext context) async {
    final user = Provider.of<MyUser?>(context, listen: false);
    if (user != null) {
      return await DatabaseService(uid: user.uid!).getUserRole();
    }
    throw Exception('User is null');
  }
}

import 'package:coffee_shop/authenticate/register.dart';
import 'package:coffee_shop/authenticate/sign_in.dart';
import 'package:coffee_shop/login_home.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/home.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'entity/user.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => Loading(),
        '/home' : (context) => Home(),
        '/start' : (context) => StartPage(),
        '/login_home': (context) => LoginHome(),
        '/register': (context) => Register(),
        '/sign_in': (context) => SignIn(),
        // '/setting': (context) => AccountSetting(),
      },
    );
  }
}


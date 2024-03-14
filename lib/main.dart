import 'package:coffee_shop/authenticate/sign_in.dart';
import 'package:coffee_shop/login_home.dart';
import 'package:coffee_shop/pages/home.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/sign_in': (context) => LoginHome(),
      },
    );
  }
}

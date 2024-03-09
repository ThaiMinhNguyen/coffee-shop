import 'package:coffee_shop/pages/home.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/pages/loading.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/' : (context) => Loading(),
    '/home' : (context) => Home(),
    '/start' : (context) => StartPage(),
  },
));

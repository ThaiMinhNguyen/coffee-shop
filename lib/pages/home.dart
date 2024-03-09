import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/home-bg.png'),
              fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image(
                    image: AssetImage('assets/coffee-icon1.png'),
                  ),
                  Text(
                    'Coffee Shop',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Colors.brown
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 90),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/start');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  child: Text(
                    'Get Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



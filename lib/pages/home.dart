import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  List<Text> ls = [
    Text(
        'As long as there was coffee in the world, how bad could things be?\n'
            'Cassandra Clare',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white70,

        )
    ),
    Text(
      'Coffee is a hug in a mug.',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white70,
      ),
    ),
  ];

  int crtIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/home-bg.png'),
              fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/coffee-icon1.png'),
                  ),
                  Text(
                    'Coffee Shop',
                    style: GoogleFonts.pacifico(
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing:8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  CarouselSlider(
                    items: ls,
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1,
                      height: 110,
                      onPageChanged: (index, reason) => {
                        setState(() {
                          crtIndex = index;
                        })
                      },
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: ls.length,
                    position: crtIndex,
                  )
                ],
              ),
              SizedBox(height: 20,),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/start');
                },
                child: Text(
                  'Get Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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



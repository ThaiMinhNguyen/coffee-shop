import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth.dart';
import '../services/database.dart';

class DetailedCoffee extends StatefulWidget {
  late Coffee coffee;
  late String route;

  DetailedCoffee({required this.coffee, required this.route});

  @override
  State<DetailedCoffee> createState() => _DetailedCoffeeState();
}

class _DetailedCoffeeState extends State<DetailedCoffee> {

  AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextButton(
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.grey[850],
              //   ),
              //   onPressed: () {},
              //   child: Text(
              //     'Back',
              //     style: TextStyle(
              //       color: Colors.white
              //     ),
              //   )
              // ),
              Expanded(
                child: CardImageView(coffee: widget.coffee, route: widget.route,),
              ),
              const SizedBox(height: 30),
              // Section -> Description
              Text(
                'Description',
                style: GoogleFonts.roboto(
                  color: const Color(0xff93969B),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.coffee.description,
                style: GoogleFonts.roboto(
                  color: const Color(0xff979696),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),

              const SizedBox(height: 30),
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Price',
                          style: GoogleFonts.roboto(
                            color: const Color(0xff979696),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (widget.coffee.price).toString(),
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text: '\$ ',
                                  style: GoogleFonts.roboto(
                                    color: const Color(0xffD98046),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 188,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await DatabaseService(uid: _auth.getFireBaseUser()!.uid).addItemToUserCart(_auth.getFireBaseUser()!.uid, widget.coffee.name, 1);
                        },
                        child: Center(
                          child: Text(
                              'Add to cart',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardImageView extends StatefulWidget {
  final Coffee coffee;
  late String route;

  CardImageView({
    super.key,
    required this.coffee,
    required this.route
  });

  @override
  State<CardImageView> createState() => _CardImageViewState();
}

class _CardImageViewState extends State<CardImageView> {
  bool isFav = false;
  AuthService _auth = AuthService();

  @override
  void initState() {
    checkFav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              widget.coffee.img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff232732),
                  Color(0xff0E1118),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, widget.route);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff232732),
                  Color(0xff0E1118),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isFav = !isFav;
                  if (isFav) {
                    addToFavorites();
                  } else {
                    removeFromFavorites();
                  }
                });
              },
              icon: Icon(
                Icons.favorite,
                color: isFav ? Colors .pinkAccent : Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void addToFavorites() {
    DatabaseService(uid: _auth.getFireBaseUser()!.uid).addToFavorites(_auth.getFireBaseUser()!.uid, widget.coffee.name);
  }
  void removeFromFavorites() {
    DatabaseService(uid: _auth.getFireBaseUser()!.uid).removeFromFavorites(_auth.getFireBaseUser()!.uid, widget.coffee.name);
  }

  void checkFav() async {
    bool isF = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).checkFavorite(_auth.getFireBaseUser()!.uid, widget.coffee.name);
    setState(() {
      isFav = isF;
    });
  }

}



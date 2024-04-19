import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../entity/coffee.dart';
import '../entity/item.dart';
import '../services/auth.dart';
import 'package:coffee_shop/services/database.dart';

import 'detailed_coffee.dart';

class FavItem extends StatefulWidget {

  late Coffee coffee;

  FavItem({required this.coffee});

  @override
  State<FavItem> createState() => _FavItemState();
}

class _FavItemState extends State<FavItem> {
  AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DetailedCoffee(coffee: widget.coffee, route: '/favorite',)));
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 9, right: 15, top: 9, bottom: 9),
          margin: EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(23)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black45,
                Colors.blueAccent,
              ],
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.coffee.img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.coffee.name,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Price:',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          (widget.coffee.price).toString(),
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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

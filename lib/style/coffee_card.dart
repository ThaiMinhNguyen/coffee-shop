import 'package:coffee_shop/style/detailed_coffee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../entity/coffee.dart';

class CoffeeCard extends StatefulWidget {
  late Coffee coffee;


  CoffeeCard({required this.coffee});

  @override
  State<CoffeeCard> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        child: Column(
          children: [
            ListTile(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DetailedCoffee(coffee: widget.coffee)));
              },
              title: Text(
                widget.coffee.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Image.network(
            //     widget.url,
            //   fit: BoxFit.fitWidth,
            //   alignment: Alignment.center, // If you don't want the image center aligned modify this.
            //   width: MediaQuery.of(context).size.width,
            //   height: 200,
            // )
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.coffee.img,
                    fit: BoxFit.fill,
                    width: 170,
                  ),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}

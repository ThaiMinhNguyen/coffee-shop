import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoffeeCard extends StatefulWidget {
  late String name;
  late String url;


  CoffeeCard({required this.name, required this.url});

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
              onTap: (){},
              title: Text(widget.name),
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
                    widget.url,
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

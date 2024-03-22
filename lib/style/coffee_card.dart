import 'package:flutter/material.dart';

class CoffeeCard extends StatefulWidget {
  late String name;


  CoffeeCard({required this.name});

  @override
  State<CoffeeCard> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        child: ListTile(
          onTap: (){},
          title: Text(widget.name),
        ),
      ),
    );
  }
}

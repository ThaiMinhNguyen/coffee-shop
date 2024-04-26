import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/detailed_coffee.dart';
import 'package:flutter/material.dart';

import '../entity/coffee.dart';
import '../services/database.dart';

class EditCoffee extends StatefulWidget {
  late Coffee coffee;

  EditCoffee({required this.coffee});

  @override
  State<EditCoffee> createState() => _EditCoffeeState();
}

class _EditCoffeeState extends State<EditCoffee> {

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        child: Column(
            children: [
              ListTile(
                onTap: (){
                  showEditDialog(widget.coffee);
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

  showEditDialog(Coffee coffee) {
    String name = coffee.name;
    double price = coffee.price;
    String url = coffee.img;
    String description = coffee.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          title: Text(
            "Edit Menu",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter name here',
                      labelText: 'Name'),
                  onChanged: (text) {
                    name = text;
                    print(name);
                  },
                ),
                TextField(
                  controller: TextEditingController(text: (price).toString()),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter price here',
                      labelText: 'Price'),
                  onChanged: (text) {
                    price = double.parse(text);
                    print(price);
                  },
                ),
                TextField(
                  controller: TextEditingController(text: url),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter url here',
                      labelText: 'Url'),
                  onChanged: (text) {
                    url = text;
                    print(url);
                  },
                ),
                TextField(
                  controller: TextEditingController(text: description),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter description here',
                      labelText: 'Description'),
                  onChanged: (text) {
                    description = text;
                    print(description);
                  },
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseService(uid: _auth.getFireBaseUser()!.uid).updateMenuItem(Coffee(name: name, img: url, price: price, description: description));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,

                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

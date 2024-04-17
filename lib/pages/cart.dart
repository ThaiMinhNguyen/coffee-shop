import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/cart_item.dart';
import 'package:coffee_shop/style/coffee_card.dart';
import 'package:coffee_shop/style/horizontal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entity/item.dart';


class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  int _currentTabIndex = 2;
  List<Item> itemLs = [];
  AuthService _auth = AuthService();
  bool isEmpty = true;

  Future<void> loadItem() async {
    List<Item> ls = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getUserCart(_auth.getFireBaseUser()!.uid);
    setState(() {
      itemLs = ls;
      if(itemLs.isNotEmpty){
        isEmpty = false;
      }
    });
  }

  Future<void> addItem() async {
    print('Thêm bánh mì');
    await DatabaseService(uid: _auth.getFireBaseUser()!.uid).addItemToUserCart(_auth.getFireBaseUser()!.uid, 'Bánh mì', 2);
  }

  @override
  void initState() {
    // addItem();
    loadItem();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        title: Center(
          child: Text(
            'Cart',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: emptyOrNot(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favarite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => StartPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Cart()));
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AccountSetting()));
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }

  emptyOrNot() {
    if(isEmpty){
      return Container(
        child: Center(
          child: Text(
            "Your cart is empty!\nPlease add more product :v",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: itemLs.length,
          itemBuilder: (context, index) {
            return CartItem(itemLs[index]);
          },
        ),
      );
    }
  }

}

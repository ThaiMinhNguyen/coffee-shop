import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/favourite.dart';
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
  double totalPrice = 0;
  int _currentTabIndex = 2;
  List<Item> itemLs = [];
  AuthService _auth = AuthService();
  bool isEmpty = true;

  Future<void> loadItem() async {
    List<Item> ls = await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .getUserCart(_auth.getFireBaseUser()!.uid);
    if (mounted) {
      setState(() {
        itemLs = ls;
        if (itemLs.isNotEmpty) {
          isEmpty = false;
        }
      });
    }
  }

  Future<void> getTotalPrice() async {
    double price = await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .getTotalPrice(_auth.getFireBaseUser()!.uid);
    if (mounted) {
      setState(() {
        totalPrice = price;
      });
    }
  }

  Future<void> removeZeroQuantityItem() async {
    await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .removeItemsWithZeroQuantityFromCart(_auth.getFireBaseUser()!.uid);
  }

  Future<void> addItem() async {
    print('Thêm bánh mì');
    await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .addItemToUserCart(_auth.getFireBaseUser()!.uid, 'Bánh mì', 2);
  }

  void onSetState(){
    getTotalPrice();
    if(mounted){
      print('Goi ham onSetState');
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // addItem();
    loadItem();
    getTotalPrice();
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
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Favourite(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AccountSetting()));
        break;
    }
    // setState(() {
    //   _currentTabIndex = tabIndex;
    // });
  }

  emptyOrNot() {
    if (isEmpty) {
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itemLs.length,
                itemBuilder: (context, index) {
                  return CartItem(item: itemLs[index], onSetState: onSetState,);
                },
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.roboto(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          (totalPrice).toString(),
                          style: GoogleFonts.roboto(
                            fontSize: 45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$',
                          style: GoogleFonts.roboto(
                            fontSize: 45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      );
    }
  }
}

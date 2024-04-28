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
    // print('Thêm bánh mì');
    await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .addItemToUserCart(_auth.getFireBaseUser()!.uid, 'Bánh mì', 2);
  }

  void onSetState() {
    loadItem();
    if (mounted) {
      print('Goi ham onSetState');
      setState(() {});
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
              color: Colors.white,
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
                  return CartItem(
                    item: itemLs[index],
                    onSetState: onSetState,
                  );
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
              child: Column(
                children: [
                  Row(
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
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        showReceiptDialog(itemLs);
                      },
                      child: Text(
                        'Place order',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  showReceiptDialog(List<Item> ls) {
    List<Text> nameLs = [];
    nameLs.add(Text(
      'Name',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ));
    nameLs.addAll(ls.map((e) => Text(e.name)).toList());
    List<Text> priceLs = [];
    priceLs.add(Text(
      'Price',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ));
    priceLs.addAll(ls.map((e) => Text((e.price).toString())).toList());
    List<Text> quantityLs = [];
    quantityLs.add(Text(
      'Quantity',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ));
    quantityLs.addAll(ls.map((e) => Text((e.quantity).toString())).toList());
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
            "This is your receipt",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: 250,
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: nameLs,
                              // children: ls.map((e) => Text(e.name)).toList(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: priceLs,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: quantityLs,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$totalPrice \$',
                      style: TextStyle(
                        fontSize: 20,

                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      await DatabaseService(uid: _auth.getFireBaseUser()!.uid).fromCartToBill(_auth.getFireBaseUser()!.uid, _auth.getFireBaseUser()!.displayName!, totalPrice);
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => Cart(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Text(
                      'Confirm order',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white70),
                    )
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/admin_home.dart';
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

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  double totalPrice = 0;
  int _currentTabIndex = 1;

  AuthService _auth = AuthService();
  bool isEmpty = true;



  void onSetState(){
    if(mounted){
      print('Goi ham onSetState');
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // addItem();

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
            icon: Icon(Icons.receipt_long),
            label: 'Bill',
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
            pageBuilder: (context, animation1, animation2) => AdminHome(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:

        break;
      case 2:
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
            // Expanded(
            //   // child: ListView.builder(
            //   //   itemCount: itemLs.length,
            //   //   itemBuilder: (context, index) {
            //   //     return CartItem(item: itemLs[index], onSetState: onSetState,);
            //   //   },
            //   // ),
            // ),
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

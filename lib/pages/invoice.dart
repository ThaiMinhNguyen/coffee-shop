import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/bill.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/admin_home.dart';
import 'package:coffee_shop/pages/favourite.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/bill_card.dart';
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
  int _currentTabIndex = 1;
  List<Bill> billLs = [];
  AuthService _auth = AuthService();
  bool isEmpty = true;


  void onSetState(){
    getAllBill();
    if(mounted){
      print('Goi ham onSetState');
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getAllBill();
    super.initState();
  }

  Future<void> getAllBill() async {
    List<Bill> bills = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getUserBill(_auth.getFireBaseUser()!.uid);
    if(mounted){
      setState(() {
        billLs = bills;
        if(billLs.isNotEmpty){
          isEmpty = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        title: Center(
          child: Text(
            'Bills',
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
            "There is no bill currently :v",
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
                itemCount: billLs.length,
                itemBuilder: (context, index) {
                  return BillItem(bill: billLs[index], onSetState: onSetState,);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}

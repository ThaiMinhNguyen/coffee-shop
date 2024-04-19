import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/cart.dart';
import 'package:coffee_shop/pages/startPage.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/cart_item.dart';
import 'package:coffee_shop/style/coffee_card.dart';
import 'package:coffee_shop/style/fav_item.dart';
import 'package:coffee_shop/style/horizontal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:google_fonts/google_fonts.dart';


class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  bool isRebuilt = true;
  int _currentTabIndex = 1;
  List<Coffee> favLs = [];
  AuthService _auth = AuthService();
  bool isEmpty = true;

  Future<void> loadItem() async {
    // if (!mounted) return;
    List<Coffee> ls = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getFavoriteItems(_auth.getFireBaseUser()!.uid);
    if(mounted){
      setState(() {
        favLs = ls;
        if(favLs.isNotEmpty){
          isEmpty = false;
        }
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  void updateParentState() async {
    print('goi ham parent');
    if(mounted){
      setState(() {
        isRebuilt = !isRebuilt;
      });
    }
  }

  @override
  void initState() {
    print('init fav');
    loadItem();
    super.initState();
    print(favLs);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        title: Center(
          child: Text(
            'Favourite',
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
        updateParentState();
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Cart(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AccountSetting()));
        break;
    }
    // setState(() {
    //   _currentTabIndex = tabIndex;
    // });
  }

  emptyOrNot() {
    if(isEmpty){
      return Container(
        child: Center(
          child: Text(
            "Your favourite is empty!\nPlease add more product :v",
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
                itemCount: favLs.length,
                itemBuilder: (context, index) {
                  return FavItem(coffee: favLs[index]);
                },
              ),
            ),

          ],
        ),
      );
    }
  }
}





import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/cart.dart';
import 'package:coffee_shop/pages/favourite.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/coffee_card.dart';
import 'package:coffee_shop/style/detailed_coffee.dart';
import 'package:coffee_shop/style/horizontal_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  AuthService _auth = AuthService();

  final List<HorizontalCardWidget> ls = [
    HorizontalCardWidget(
      url:
          'https://t4.ftcdn.net/jpg/03/11/30/11/360_F_311301118_xXg4OsqCJq0oyK5gU1g3XdU8zEQIc6KP.jpg',
      quote: 'Become our members now to receive many promotions and discount',
    ),
    HorizontalCardWidget(
      url:
          'https://t3.ftcdn.net/jpg/05/33/78/74/360_F_533787462_UmfoqTWFJ2v1Hedmr5I8Q6iWtTRQUjRa.jpg',
      quote: 'We are looking for new team staff\nBecome one of us right now',
    ),
  ];

  final searchController = TextEditingController();


  List<Coffee> _data = [];

  bool isLoading = false;
  List<Coffee> searchResult = [];
  String? userName;

  Future<void> searchFunction() async {
    setState(() {
      isLoading = true;
    });

    //function to call api
    await Future.delayed(Duration(seconds: 4));
    if(mounted) {
      setState(() {
        searchResult = _data
            .where((coffee) =>
            removeDiacritics(coffee.name.toLowerCase())
                .contains(
                removeDiacritics(searchController.text.toLowerCase())))
            .toList();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    userName = AuthService().getFireBaseUser()?.displayName;
    super.initState();
    // addMenu();
    loadProducts();
    searchResult = _data;
    searchController.addListener(searchFunction);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      // Gọi hàm getProductsFromMenu và gán kết quả cho danh sách sản phẩm
      List<Coffee> productList = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getProductsFromMenu();
      setState(() {
        _data = productList;
      });
    } catch (error) {
      print('Error loading products: $error');
    }
  }

  Future<void> addMenu() async {
    await DatabaseService(uid: _auth.getFireBaseUser()!.uid)
        .addProductsToMenu(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Hello ${userName}',
          style: TextStyle(
            fontFamily: 'MadimiOne',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/coffee-icon1.png'),
            radius: 20,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SearchBar(
              controller: searchController,
              hintText: 'Find something to order here',
              leading: IconButton(
                onPressed: () {
                  // print(searchController.text);
                },
                icon: Icon(Icons.search),
              ),
              trailing: [
                IconButton(
                  onPressed: () {
                    print(searchResult.map((e) => e.name).toList());
                  },
                  icon: Icon(Icons.mic),
                )
              ],
            ),
            Expanded(
              child: getHome(),
            ),
          ],
        ),
      ),
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
            label: 'Favorite',
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

  getHome() {
    if (searchController.text.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Popular Product',
            style: TextStyle(
              fontFamily: 'MadimiOne',
              fontSize: 25,
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return CoffeeCard(
                    coffee: _data[index]);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Special for you',
            style: TextStyle(
              fontFamily: 'MadimiOne',
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CarouselSlider(
            items: ls,
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              height: 160,
            ),
          ),
        ],
      );
    } else {
      return isLoading
          ? Center(
              child: SpinKitCircle(
                color: Colors.brown.shade800,
                size: 100,
              ),
            )
          : ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DetailedCoffee(coffee: searchResult[index], route: '/start',))
                      );
                    },
                    title: Text(searchResult[index].name),
                  ),
                );
              },
            );
    }
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
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
      case 2:
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => Cart()));
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
}




import 'package:coffee_shop/pages/invoice.dart';
import 'package:coffee_shop/style/edit_coffee.dart';
import 'package:flutter/material.dart';
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

import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  AuthService _auth = AuthService();
  double total = 0;
  int totalUser = 0;
  int totalItem = 0;


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
    await Future.delayed(Duration(seconds: 1));
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
    getTotal();
    getTotalUser();
    getTotalItem();
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

  Future<void> getTotal() async {
    double t = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getTotal();
    if(mounted){
      setState(() {
        total = t;
      });
    }
  }

  Future<void> getTotalUser() async {
    int tU = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getTotalUser();
    if(mounted){
      setState(() {
        totalUser = tU;
      });
    }
  }

  Future<void> getTotalItem() async {
    int tU = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getTotalProduct();
    if(mounted){
      setState(() {
        totalItem = tU;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  getHome() {
    if (searchController.text.isEmpty) {
      return Container(
        child: Column(
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
                  return EditCoffee(
                      coffee: _data[index]);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Statistic',
              style: TextStyle(
                fontFamily: 'MadimiOne',
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: Card(
                        color: Colors.brown,
                        // elevation: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Income',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (total).toString()+'\$',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: Card(
                        color: Colors.brown,
                        // elevation: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total User',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (totalUser).toString(),
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: Card(
                        color: Colors.brown,
                        // elevation: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Items',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (totalItem).toString(),
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      showEditDialog(Coffee(name: '', img: '', price: 0, description: ''), 'Add product to menu');
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.all(15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                showEditDialog(searchResult[index], 'Edit product');
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
            pageBuilder: (context, animation1, animation2) => Invoice(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AccountSetting()));
        break;
    }
  }

  showEditDialog(Coffee coffee, String title) {
    String name = coffee.name;
    double price = coffee.price;
    String url = coffee.img;
    String description = coffee.description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: 450,
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







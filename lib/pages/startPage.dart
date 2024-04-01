import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/coffee_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:remove_diacritic/remove_diacritic.dart';
import 'package:google_fonts/google_fonts.dart';


class StartPage extends StatefulWidget {

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  AuthService _auth = AuthService();

  final searchController = TextEditingController();
  final List<String> _data = [
    'Cà phê',
    'Bánh mì',
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Peach',
    'Plum',
    'Raspberry',
    'Strawberry',
    'Watermelon',
  ];

  bool isLoading = false;
  List<String> searchResult = [];
  String? userName;
  Future<void> searchFunction() async{
    setState(() {
      isLoading = true;
    });

    //function to call api
    await Future.delayed(Duration(seconds: 4));

    setState(() {
      searchResult = _data.
      where((element) => removeDiacritics(element.toLowerCase()).contains(removeDiacritics(searchController.text.toLowerCase()))).toList();
      isLoading = false;
    });

  }

  @override
  void initState() {
    userName = AuthService().getFireBaseUser()?.displayName;
    super.initState();
    searchResult = _data;
    searchController.addListener(searchFunction);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Hello ${userName}'),
        actions: [
          ElevatedButton(
            // onPressed: () async {
            //   await _auth.signOut();
            // },
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountSetting() ));
            },
            child: Text('Setting'),
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
                onPressed: (){
                  // print(searchController.text);
                },
                icon: Icon(Icons.search),
              ),
              trailing: [IconButton(
                onPressed: () {
                  print(searchResult);
                },
                icon: Icon(
                  Icons.mic
                ),
              )],
            ),
            Expanded(
              child: getHome(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.favorite
            ),
            label: 'Favarite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.add_shopping_cart
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.notifications
            ),
            label: 'Notification',
          ),
        ],
      ),
    );
  }


  getHome(){
    
    if(searchController.text.isEmpty){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
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
                return CoffeeCard(name: _data[index]);
              },
            ),
          ),
        ],
      );
    } else {
      return
      isLoading ? Center(
        child: SpinKitCircle(
          color: Colors.brown.shade800,
          size: 100,
        ),
      ) :ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: (){},
              title: Text(searchResult[index]),
            ),
          );
        },
      );
    }

  }
}

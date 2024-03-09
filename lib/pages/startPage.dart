import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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

  Future<void> searchFunction() async{
    setState(() {
      isLoading = true;
    });

    //function to call api
    await Future.delayed(Duration(seconds: 4));

    setState(() {
      searchResult = _data.
      where((element) => element.toLowerCase().contains(searchController.text.toLowerCase())).toList();
      isLoading = false;
    });

  }

  @override
  void initState() {
    super.initState();
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
        title: Text('Hello'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SearchBar(
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
              // print(menu[0]);
            },
            icon: Icon(
              Icons.mic
            ),
          )],
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
}

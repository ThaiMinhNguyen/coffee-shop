import 'package:carousel_slider/carousel_slider.dart';
import 'package:coffee_shop/entity/coffee.dart';
import 'package:coffee_shop/pages/account_setting.dart';
import 'package:coffee_shop/pages/cart.dart';
import 'package:coffee_shop/services/auth.dart';
import 'package:coffee_shop/style/coffee_card.dart';
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

    setState(() {
      searchResult = _data
          .where((coffee) => removeDiacritics(coffee.name.toLowerCase())
              .contains(removeDiacritics(searchController.text.toLowerCase())))
          .toList();
      isLoading = false;
    });
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
        title: Text('Hello ${userName}'),
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
                    name: _data[index].name, url: _data[index].img);
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
                    onTap: () {},
                    title: Text(searchResult[index].name),
                  ),
                );
              },
            );
    }
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:

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
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
}



// List<Coffee> _data = [
//   Coffee(
//       name: 'Espresso',
//       img:
//           'https://cdn.tgdd.vn/Files/2023/07/11/1537842/espresso-la-gi-nguyen-tac-pha-espresso-dung-chuan-202307120718497350.jpg',
//       price: 20),
//   Coffee(
//       name: 'Bánh mì',
//       img: 'https://banhmipho.vn/wp-content/uploads/2021/08/vuong.jpg.png',
//       price: 20),
//   Coffee(
//       name: 'Nước táo',
//       img:
//           'https://cdn.nhathuoclongchau.com.vn/unsafe/800x0/https://cms-prod.s3-sgn09.fptcloud.com/nuoc_ep_tao_co_tac_dung_gi_nuoc_ep_tao_mix_voi_gi_cho_giau_dinh_duong_1_9ad02a8c5f.jpg',
//       price: 20),
//   Coffee(
//       name: 'Bạc xỉu',
//       img:
//           'https://grandgoldhotel.com/wp-content/uploads/2022/08/ly-ca-phe-bac-xiu-da.jpg',
//       price: 20),
//   Coffee(
//       name: 'Cookie and cream',
//       img:
//           'https://thehungrykitchenblog.com/wp-content/uploads/2022/08/Boozy-Cookies-and-Cream-Milkshake-1-2.jpg',
//       price: 20),
//   Coffee(
//       name: 'Freeze',
//       img:
//           'https://dvpmarket.com/resources/uploads/images/2018/07/Freeze-tra-xanh-tuoi-mat-thom-ngon-1.jpg',
//       price: 20),
//   Coffee(
//       name: 'Nước nho',
//       img:
//           'https://cdn.tgdd.vn//News/1520955//cach-lam-nuoc-ep-nho-hap-dan-845x564.jpg',
//       price: 20),
//   Coffee(
//       name: 'Nước chanh',
//       img:
//           'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/3/5/1020461/20210314_090326_7265.jpg',
//       price: 20),
//   Coffee(
//       name: 'Nước xoài',
//       img:
//           'https://dayphache.edu.vn/wp-content/uploads/2021/10/cach-lam-nuoc-ep-xoai.jpg',
//       price: 20),
//   Coffee(
//       name: 'Nước cam',
//       img:
//           'https://cdn.nhathuoclongchau.com.vn/unsafe/https://cms-prod.s3-sgn09.fptcloud.com/nuoc_cam_co_giai_ruou_khong_va_cach_giai_ruou_bang_nuoc_cam_Cropped_2e92569c5b.jpg',
//       price: 20),
//   Coffee(
//       name: 'Nước dừa',
//       img:
//           'https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2022/8/29/dua-1-16617633760061376694743.jpg',
//       price: 20),
//   Coffee(
//       name: 'Hoa quả dầm',
//       img:
//           'https://www.thatlangon.com/wp-content/uploads/2020/04/hoa-qua-dam-6-scaled.jpg',
//       price: 20),
//   Coffee(
//       name: 'Trà đào',
//       img:
//           'https://hocphachehanoi.com.vn/upload/userfiles/images/cach-lam-tra-dao-02.jpg',
//       price: 20),
// ];
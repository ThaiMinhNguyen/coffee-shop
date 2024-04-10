import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/coffee.dart';


class DatabaseService {
  late final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');



  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      'name': name,
    });
  }

  Future updateUserAgeData(int age) async {
    return await userCollection.doc(uid).update({
      'age': age,
    });
  }


  Future<int?> getUserAge() async {
    try {
      DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['age'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user age: $e');
      return null;
    }
  }

  final CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');

  Future<void> addProductsToMenu(List<Coffee> products) async {
    // Lấy tham chiếu đến collection menu
    // CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');

    // Thêm từng sản phẩm vào collection menu
    products.forEach((product) async {
      try {
        await menuCollection.doc(product.name).set({
          'url': product.img,
          'price': product.price
        });
        print('Added ${product.name} to menu collection');
      } catch (error) {
        print('Error adding ${product.name} to menu collection: $error');
      }
    });
  }

  // Hàm lấy danh sách sản phẩm từ collection menu
  Future<List<Coffee>> getProductsFromMenu() async {
    // Khởi tạo danh sách sản phẩm
    List<Coffee> products = [];

    try {
      // Lấy danh sách các documents từ collection menu
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('menu').get();

      // Duyệt qua từng document và chuyển đổi thành đối tượng Coffee
      querySnapshot.docs.forEach((doc) {
        String name = doc.id;
        String img = doc['url'];
        double price = doc['price'];

        // Tạo đối tượng Coffee và thêm vào danh sách sản phẩm
        products.add(Coffee(name: name, img: img, price: price));
      });

      return products;
    } catch (error) {
      print('Error getting products from menu: $error');
      return [];
    }
  }

  Future<void> addItemToUserCart(String userId, String itemName, int quantity) async {
    try {
      // Lấy thông tin mặt hàng từ collection menu
      final menuSnapshot = await menuCollection.doc(itemName).get();
      if (menuSnapshot.exists) {
        final Map<String, dynamic>? itemData = menuSnapshot.data() as Map<String, dynamic>?;

        if (itemData != null) {
          final itemName = itemData['name'];
          final itemPrice = itemData['price'];

          // Thêm mặt hàng vào giỏ hàng của người dùng
          final userCartRef = userCollection.doc(userId).collection('cart');
          final itemRef = userCartRef.doc(itemName);

          // Kiểm tra xem mặt hàng đã tồn tại trong giỏ hàng chưa
          final itemSnapshot = await itemRef.get();
          if (itemSnapshot.exists) {
            // Nếu mặt hàng đã tồn tại, cập nhật số lượng
            final currentQuantity = itemSnapshot.data()?['quantity'] ?? 0;
            await itemRef.update({
              'quantity': currentQuantity + quantity,
            });
          } else {
            // Nếu mặt hàng chưa tồn tại, thêm mới nó vào giỏ hàng
            await itemRef.set({
              'name': itemName,
              'price': itemPrice,
              'quantity': quantity,
            });
          }
        } else {
          print('Item data is null');
        }
      } else {
        print('Item not found in the menu: $itemName');
      }
    } catch (e) {
      print('Error adding item to user cart: $e');
    }
  }



  Future<List<Map<String, dynamic>>> getUserCart(String userId) async {
    try {
      final userCartRef = userCollection.doc(userId).collection('cart');
      final cartSnapshot = await userCartRef.get();

      List<Map<String, dynamic>> cartItems = [];
      cartSnapshot.docs.forEach((doc) {
        cartItems.add(doc.data());
      });

      return cartItems;
    } catch (e) {
      print('Error getting user cart: $e');
      return [];
    }
  }

  Future<int> getTotalPrice(String userId) async {
    try {
      final userCartRef = userCollection.doc(userId).collection('cart');
      final cartSnapshot = await userCartRef.get();

      int totalPrice = 0;

      for (var doc in cartSnapshot.docs) {
        final itemData = doc.data() as Map<String, dynamic>;
        final itemName = itemData['name'];
        final itemQuantity = itemData['quantity'];

        // Lấy giá của mặt hàng từ collection menu
        final menuSnapshot = await menuCollection.doc(itemName).get();
        final menuData = menuSnapshot.data() as Map<String, dynamic>;
        final itemPrice = menuData['price'];

        // Tính tổng giá của mặt hàng và cộng vào tổng giá của giỏ hàng
        totalPrice += int.parse(itemPrice) * int.parse(itemQuantity);
      }

      return totalPrice;
    } catch (e) {
      print('Error getting total price: $e');
      return 0;
    }
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/coffee.dart';
import '../entity/item.dart';


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
        String description = doc['description'];

        // Tạo đối tượng Coffee và thêm vào danh sách sản phẩm
        products.add(Coffee(name: name, img: img, price: price, description: description));
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
          final name = itemName;
          final itemPrice = itemData['price'];
          final url = itemData['url'];

          // Thêm mặt hàng vào giỏ hàng của người dùng
          final userCartRef = userCollection.doc(userId).collection('cart');
          final itemRef = userCartRef.doc(name);

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
              'name': name,
              'url': url,
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

  Future<void> removeItemsWithZeroQuantityFromCart(String userId) async {
    try {
      final userCartRef = userCollection.doc(userId).collection('cart');
      final cartSnapshot = await userCartRef.get();

      // Duyệt qua danh sách các mặt hàng trong collection cart
      for (var doc in cartSnapshot.docs) {
        // Lấy thông tin của mỗi mặt hàng
        final itemData = doc.data();
        final quantity = itemData['quantity'];

        // Kiểm tra xem mặt hàng có quantity = 0 hay không
        if (quantity == 0) {
          // Xóa mặt hàng có quantity = 0 khỏi collection cart
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print('Error removing items with zero quantity from cart: $e');
    }
  }

  Future<List<Item>> getUserCart(String userId) async {
    try {
      final userCartRef = userCollection.doc(userId).collection('cart');
      final cartSnapshot = await userCartRef.get();

      List<Item> cartItems = [];
      cartSnapshot.docs.forEach((doc) {
        var data = doc.data();
        var item = Item(
          name: data['name'],
          url: data['url'],
          quantity: data['quantity'],
          price: data['price'],
        );
        cartItems.add(item);
      });
      return cartItems;
    } catch (e) {
      print('Error getting user cart: $e');
      return [];
    }
  }

  Future<void> updateQuantity(String userId, String itemName, int newQuantity) async {
    try {
      final userCartRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('cart');
      final itemRef = userCartRef.doc(itemName);

      // Kiểm tra xem mặt hàng đã tồn tại trong giỏ hàng chưa
      final itemSnapshot = await itemRef.get();
      if (itemSnapshot.exists) {
        // Nếu mặt hàng đã tồn tại, cập nhật số lượng
        await itemRef.update({
          'quantity': newQuantity,
        });
      } else {
        // Nếu mặt hàng không tồn tại, thông báo lỗi
        throw 'Item not found in cart: $itemName';
      }
    } catch (e) {
      print('Error updating quantity in user cart: $e');
    }
  }

  Future<double> getTotalPrice(String userId) async {
    try {
      final userCartRef = userCollection.doc(userId).collection('cart');
      final cartSnapshot = await userCartRef.get();

      double totalPrice = 0;

      for (var doc in cartSnapshot.docs) {
        final itemData = doc.data() as Map<String, dynamic>;
        final itemName = itemData['name'];
        int itemQuantity = itemData['quantity'];
        double itemPrice = itemData['price'];
        // Lấy giá của mặt hàng từ collection menu
        // final menuSnapshot = await menuCollection.doc(itemName).get();
        // final menuData = menuSnapshot.data() as Map<String, dynamic>;


        // Tính tổng giá của mặt hàng và cộng vào tổng giá của giỏ hàng
        totalPrice += (itemPrice) * itemQuantity;
      }

      return totalPrice;
    } catch (e) {
      print('Error getting total price: $e');
      return 0;
    }
  }

  void addToFavorites(String userId, String itemName) async {
    try {
      final userFavoriteRef = userCollection.doc(userId).collection('favorite');
      final itemRef = userFavoriteRef.doc(itemName);

      // Kiểm tra xem món ăn đã tồn tại trong danh sách favorite chưa
      final itemSnapshot = await itemRef.get();
      if (!itemSnapshot.exists) {
        // Nếu món ăn chưa tồn tại, thêm nó vào collection favorite
        await itemRef.set({
          'name': itemName,
        });
      }
    } catch (e) {
      print('Error adding item to favorites: $e');
    }
  }

  void removeFromFavorites(String userId, String itemName) async {
    try {
      final userFavoriteRef = userCollection.doc(userId).collection('favorite');
      final itemRef = userFavoriteRef.doc(itemName);

      // Kiểm tra xem món ăn có tồn tại trong danh sách favorite không
      final itemSnapshot = await itemRef.get();
      if (itemSnapshot.exists) {
        // Nếu món ăn tồn tại, xóa nó khỏi collection favorite
        await itemRef.delete();
      }
    } catch (e) {
      print('Error removing item from favorites: $e');
    }
  }

  Future<bool> checkFavorite(String userId, String itemName) async {
    try {
      final userFavoriteRef = userCollection.doc(userId).collection('favorite');
      final itemRef = userFavoriteRef.doc(itemName);

      // Kiểm tra xem món ăn có tồn tại trong danh sách favorite không
      final itemSnapshot = await itemRef.get();
      if (itemSnapshot.exists) {
        return true;
      } else return false;
    } catch (e) {
      print('Error removing item from favorites: $e');
      return false;
    }
  }

  Future<List<Coffee>> getFavoriteItems(String userId) async {
    try {
      final userFavoriteRef = userCollection.doc(userId).collection('favorite');
      final favoriteSnapshot = await userFavoriteRef.get();

      List<Coffee> favoriteItems = [];
      for (var doc in favoriteSnapshot.docs) {
        Map<String, dynamic>? item = doc.data() as Map<String, dynamic>;
        String itemName = item['name'];
        final menuSnapshot = await menuCollection.doc(itemName).get();
        if (menuSnapshot.exists){
          // print(itemName);
          final menuSnapshot = await menuCollection.doc(itemName).get();
          final menuData = menuSnapshot.data() as Map<String, dynamic>;
          favoriteItems.add(Coffee(name: itemName, img: menuData['url'], price: menuData['price'], description: menuData['description']));
        }
      }
      return favoriteItems;
    } catch (e) {
      print('Error getting favorite items: $e');
      return [];
    }
  }



}
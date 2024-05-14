import 'dart:async';
import 'package:coffee_shop/entity/user.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  MyUser? _userFromFirebase(User? user){
    return user != null ? MyUser(uid: user.uid, name: user.displayName) : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebase(user));
  }

  User? getFireBaseUser() {
    return _auth.currentUser;
  }

  MyUser? getUser() {
    return _userFromFirebase(_auth.currentUser);
  }

  //sign in anonymously
  Future signInAnon () async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmail (String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future signInWithFacebook() async {
  //   try {
  //     await _auth.s
  //   } catch (e) {
  //     print("Error log in with facebook: $e");
  //     return null;
  //   }
  // }

  //register with email
  Future registerWithEmail(String email, String password, String name) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await user?.updateDisplayName(name);
      await DatabaseService(uid: user!.uid).updateUserData(name);
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // Lấy người dùng hiện tại
      User? user = _auth.currentUser;

      // Tạo AuthCredential để xác thực mật khẩu cũ
      AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: oldPassword);

      // Reauthenticate người dùng bằng AuthCredential
      await user.reauthenticateWithCredential(credential);

      // Nếu reauthentication thành công, cập nhật mật khẩu mới
      await user.updatePassword(newPassword);
      print("Password updated successfully");
      return true; // Trả về true nếu mọi thứ thành công
    } catch (e) {
      print("Error changing password: $e");
      return false; // Trả về false nếu có lỗi xảy ra
    }
  }
}
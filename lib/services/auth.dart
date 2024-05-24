import 'dart:async';
import 'package:coffee_shop/entity/user.dart';
import 'package:coffee_shop/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<User?> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn().signIn();

      final googleAuth = await googleAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await DatabaseService(uid: userCredential.user!.uid).updateUserDataGoogle(userCredential.user!.displayName!);
      return userCredential.user;
    } catch (e) {
      print("Error log in using google: $e");
      return null;
    }
  }

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
      if(await GoogleSignIn().isSignedIn()){
        GoogleSignIn().signOut();
      } else {
        return await _auth.signOut();
      }
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
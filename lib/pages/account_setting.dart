import 'package:coffee_shop/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class AccountSetting extends StatefulWidget {
  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  AuthService _auth = AuthService();

  int userAge = 20;

  @override
  void initState() {
    super.initState();
    getUserAge();
  }

  Future<void> getUserAge() async {
    int? age = await DatabaseService(uid: _auth.getFireBaseUser()!.uid).getUserAge();
    setState(() {
      userAge = age!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
      ),
      body: Container(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/coffee-icon1.png'),
                radius: 50,
              ),
            ),
            Divider(
              height: 30,
              thickness: 1,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'NAME',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${_auth.getFireBaseUser()?.displayName}',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${_auth.getFireBaseUser()?.email}',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'AGE',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   '20',
            //   style: TextStyle(
            //       color: Colors.blue,
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold),
            // ),
            Padding(
              padding: EdgeInsets.all(10),
              child: EditableText(
                textAlign: TextAlign.center,
                controller: TextEditingController(text: userAge.toString()),
                focusNode: FocusNode(),
                style:TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                cursorColor: Colors.pinkAccent,
                backgroundCursorColor: Colors.white,
                onSubmitted: (text){
                  DatabaseService(uid: _auth.getFireBaseUser()!.uid).updateUserAgeData(int.parse(text));
                  print(text);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
          child: TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
            child: Text('Sign out'),
          ),
        ),
      ),
    );
  }
}

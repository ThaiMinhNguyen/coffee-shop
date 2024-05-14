import 'package:coffee_shop/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../style/constants.dart';

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
    if(mounted) {
      setState(() {
        userAge = age!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
      ),
      body: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
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
              ElevatedButton(
                onPressed: () {
                  showEditDialog('Change password');
                },
                child: Text("Change password"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Center(
          child: TextButton(
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/sign_in');
            },
            child: Text('Sign out'),
          ),
        ),
      ),
    );
  }

  showEditDialog(String title) {
    final _keyForm = GlobalKey<FormState>();
    bool isRight = false;
    bool obscure = true;
    String? name = _auth.getFireBaseUser()?.email;
    String oldpass = "";
    String newpass = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
            height: 200,
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => value!.length < 6 ? 'Wrong password' : null,
                    obscureText: obscure,
                    onChanged: (value) {
                      setState(() {
                        oldpass = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Old Password',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          }
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (value) => value!.length < 6 ? 'Please enter a 6+ length password' : null,
                    obscureText: obscure,
                    onChanged: (value) {
                      setState(() {
                        newpass = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(
                      hintText: 'New Password',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          }
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_keyForm.currentState!.validate()) {
                        if (!(await _auth.changePassword(oldpass, newpass))) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Incorrect password. Please try again.'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Successful'),
                              content: Text('Change password successfully'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                    },
                    child: Text('Confirm change'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

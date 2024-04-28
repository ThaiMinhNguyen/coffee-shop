import 'package:coffee_shop/style/constants.dart';
import '../services/auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/style/loading-wait.dart';

class Register extends StatefulWidget {

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _keyForm = GlobalKey<FormState>();
  bool obscure = true;
  bool loading = false;

  String email = '';
  String password = '';
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingWait() : Scaffold(
      backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Register',
            style: TextStyle(
              fontFamily: 'MadimiOne',
              fontSize: 25,
              color: Colors.white,
            ),),
        ),
        body: Form(
          key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (value) => value!.length < 6 ? 'Please enter a 6+ length password' : null,
                    obscureText: obscure,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Password',
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
                      if(_keyForm.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerWithEmail(email, password, name);
                        if(result == null){
                          setState(() {
                            loading = false;
                            error = 'Please enter a valid email';
                          });
                        }
                        else {
                          print(name);
                          print(_auth.getUser()?.name);
                          Navigator.pushReplacementNamed(context, '/login_home');
                        }
                      }
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}

import 'package:coffee_shop/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/style/constants.dart';

class SignIn extends StatefulWidget {

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _keyForm = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool obscure = true;
  bool loading = false;
  String error = '';
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Sign in',
          style: TextStyle(
            fontFamily: 'MadimiOne',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _keyForm,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
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
                    dynamic result = await _auth.signInWithEmail(email, password);
                    if(result == null){
                      setState(() {
                        loading = false;
                        error = 'This account does not exist';
                      });
                    } else {
                      Navigator.pushReplacementNamed(context, '/login_home');
                    }
                  }
                },
                child: Text('Sign in'),
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20,),
              Text('If you dont have account, please register'),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    Navigator.pushReplacementNamed(context, '/register');
                  });
                },
                child: Text('Register'),
              )
            ],
          ),
        )
      )
    );
  }
}
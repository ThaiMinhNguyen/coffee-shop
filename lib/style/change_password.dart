import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';


class ChangePasswordDialog extends StatefulWidget {
  final String title;

  ChangePasswordDialog({required this.title});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  AuthService _auth = AuthService();
  final _keyForm = GlobalKey<FormState>();
  bool obscureOldPass = true;
  bool obscureNewPass = true;
  String oldPass = "";
  String newPass = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 24.0),
      ),
      content: Container(
        height: 240,
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                validator: (value) => value!.length < 6 ? 'Wrong password' : null,
                obscureText: obscureOldPass,
                onChanged: (value) {
                  setState(() {
                    oldPass = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Old Password',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        obscureOldPass = !obscureOldPass;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) => value!.length < 6 ? 'Please enter a 6+ length password' : null,
                obscureText: obscureNewPass,
                onChanged: (value) {
                  setState(() {
                    newPass = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        obscureNewPass = !obscureNewPass;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_keyForm.currentState!.validate()) {
                    if (!(await _auth.changePassword(oldPass, newPass))) {
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
  }
}

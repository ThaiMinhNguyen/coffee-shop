import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pinkAccent, width: 1)
  ),
);

// InputDecoration(
// suffixIcon: IconButton(
// icon: Icon(Icons.remove_red_eye),
// onPressed: (){
// setState(() {
// obsecure = !obsecure;
// });
// },
// ),
// ),
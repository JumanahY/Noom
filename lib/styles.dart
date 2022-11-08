import 'package:flutter/material.dart';


final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.lightBlueAccent,
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    side: BorderSide(color: Colors.lightBlueAccent)
  ),

);
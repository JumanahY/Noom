import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget indcators() {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Text(
        "كربوهيدرات",
        style: TextStyle(color: Colors.white),
      ),
      Container(
        height: 10,
        width: 10,
        color: const Color(0xff4af699),
      ),
      Text(
        "جلوكوز",
        style: TextStyle(color: Colors.white),
      ),
      Container(
        height: 10,
        width: 10,
        color: const Color(0xffaa4cfc),
      ),
      Text(
        "ساعات النوم",
        style: TextStyle(color: Colors.white),
      ),
      Container(
        height: 10,
        width: 10,
        color: const Color(0xff27b6fc),
      ),
    ],
  );
}

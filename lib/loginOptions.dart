import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key key}) : super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تطبيق النوم"),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 4,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "اختر نوع المستخدم",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.lightBlueAccent),
                ),
                SizedBox(
                  height: 40,
                ),
                OutlineButton(
                  highlightColor: Colors.white,
                  borderSide: BorderSide(color: Colors.lightBlue),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    Navigator.pushNamed(context, "/childLoginScreen");
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "images/child.png",
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "شاشة الطفل",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.lightBlueAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                OutlineButton(
                  highlightColor: Colors.white,
                  borderSide: BorderSide(color: Colors.lightBlue),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    Navigator.pushNamed(context, "/parentOptions");
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "images/parent.png",
                        width: 150,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "شاشة الابوين",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.lightBlueAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

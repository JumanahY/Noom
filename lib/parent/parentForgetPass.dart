import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'dart:async';

import 'package:noom_app2/styles.dart';

class ParentForgetPass extends StatefulWidget {
  const ParentForgetPass({Key key}) : super(key: key);

  @override
  State<ParentForgetPass> createState() => _ParentForgetPassState();
}

class _ParentForgetPassState extends State<ParentForgetPass> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController user = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    user.dispose();
  }

  void ClearInputs() {
    user.clear();
  }

  Future<List> _forget() async {
    final response = await http.post(
       links().parent_forget_pass,
        body: {"username": user.text});
    print(response.body);
    var userData = json.decode(response.body);
    if (userData.length != 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم ارسال كلمة المرور على البريد الالكتروني الخاص بك",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green[800],
      ));

      FocusScope.of(context).unfocus();
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(context, '/parentOptions');
      });
    } else {
      ClearInputs();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("البيانات غير موجودة",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    }
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: snackBarScafflod,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.lightBlueAccent,
              )),
          title: Text(
            "استرجاع كلمة المرور",
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ادخل اسم المستخدم الخاص بك !",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.lightBlue,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Image(
                        image: AssetImage('images/forget.png'),
                        height: 180.0,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: user,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: "اسم المستخدم",
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.blueGrey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* نسيت ادخال اسم المستخدم";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      TextButton(
                      style: flatButtonStyle,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            _forget();
                          }
                        },
                      
                        child: Container(
                          child: Text(
                            "استرجاع الان",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 60.0,
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

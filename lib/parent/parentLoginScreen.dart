import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'package:noom_app2/styles.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ParentLoginScreen extends StatefulWidget {
  const ParentLoginScreen({Key key}) : super(key: key);

  @override
  _ParentLoginScreenState createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  var username = "";
  dynamic parent_id = 0;

  Future<List> _login() async {
    final response = await http.post(links().parnet_login, body: {
      "username": user.text,
      "password": pass.text,
    });
    print(response.body);
    var userData = json.decode(response.body);
    if (userData.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("انت غير مخول لك الدخول",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
      FocusScope.of(context).unfocus();
    } else {
      SharedPreferences parentLoggedInCheck =
          await SharedPreferences.getInstance();
      setState(() {
        username = userData[0]['username'];
        parent_id = userData[0]['parent_id'];

        print("parent_id = ${parent_id}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("اهلا بك حساب الابوين",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[800],
        ));

        parentLoggedInCheck.setString("parent_username", username);
        int id = int.parse(parent_id);
        print(parent_id.runtimeType);
        var c = int.parse(parent_id);
        print("C = ${c}");
        print(c.runtimeType);
        parentLoggedInCheck.setInt("parent_id", c);

        Future.delayed(Duration(seconds: 2), () {
          print("Ok logged in");

          Navigator.pushNamed(context, '/parentHomeScreen');
        });
      });
      ////

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
                Navigator.pushNamed(context, '/parentOptions');
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.lightBlueAccent,
              )),
          title: Text(
            "تسجيل الدخول الابوين",
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
                        "مرحباً بك من جديد - الابوين",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.lightBlue,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: AssetImage('images/noomLogo.png'),
                        height: 180.0,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: user,
                        textAlign: TextAlign.left,
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
                      TextFormField(
                        controller: pass,
                        textAlign: TextAlign.left,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
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
                            return "* نسيت ادخال كلمة المرور";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      TextButton(
                        style: flatButtonStyle,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            _login();
                            //Navigator.pushReplacementNamed(context, '/parentHomeScreen');
                          }
                        },
                        child: Container(
                          child: Text(
                            "ادخل الان!",
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
                      RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 25,
                            ),
                            children: [
                              TextSpan(text: "ليس لديك حساب ؟"),
                              TextSpan(
                                text: " انشاء حساب ",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("parent Register");
                                    Navigator.pushNamed(
                                        context, "/parentRegisterScreen");
                                  },
                              )
                            ],
                          )),
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
    ;
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ChildLoginScreen extends StatefulWidget {
  const ChildLoginScreen({Key key}) : super(key: key);

  @override
  _ChildLoginScreenState createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends State<ChildLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  var username = "";
  dynamic child_id = 0;

  @override
  void dispose() {
    super.dispose();
    user.dispose();
    pass.dispose();
  }

  void ClearInputs() {
    user.clear();
    pass.clear();
  }

  Future<List> _login() async {
    final response =
        await http.post("http://10.0.2.2/api/noom_app/ChildLogin.php", body: {
      "username": user.text,
      "password": pass.text,
    });
    print(response.body);
    var userData = json.decode(response.body);
    if (userData.length == 0) {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("انت غير مخول لك الدخول",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
      ClearInputs();
      FocusScope.of(context).unfocus();
    } else {
      SharedPreferences parentLoggedInCheck =
          await SharedPreferences.getInstance();
      setState(() {
        username = userData[0]['username'];
        child_id = userData[0]['child_id'];

        print("LOGIN child_id = ${child_id}");
        snackBarScafflod.currentState.showSnackBar(SnackBar(
          content: Text("اهلا بك حساب الطفل",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[800],
        ));

        parentLoggedInCheck.setString("parent_username", username);
        int id = int.parse(child_id);
        print(child_id.runtimeType);
        var c = int.parse(child_id);
        print("C = ${c}");
        print(c.runtimeType);
        parentLoggedInCheck.setInt("child_id", c);

        Future.delayed(Duration(seconds: 2), () {
          print("Ok logged in");

          Navigator.pushNamed(context, '/childHomeScreen');
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
                Navigator.pushNamed(context, '/loginOptions');
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.lightBlueAccent,
              )),
          title: Text(
            "تسجيل الدخول - الطفل",
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
                        "اهلا بك - الطفل!",
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
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            _login();
                          }
                        },
                        color: Colors.lightBlueAccent,
                        child: Container(
                          child: Text(
                            "دخول الان!",
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

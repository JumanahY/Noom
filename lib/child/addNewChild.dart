
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'package:noom_app2/styles.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AddNewChild extends StatefulWidget {
  const AddNewChild({Key key}) : super(key: key);

  @override
  _AddNewChildState createState() => _AddNewChildState();
}

class _AddNewChildState extends State<AddNewChild> {
  int parent_id;

  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();

  TextEditingController name = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  void dispose() {
    super.dispose();
    name.dispose();
    user.dispose();
    pass.dispose();
  }

  void ClearInputs() {
    name.clear();
    age.clear();
    user.clear();
    pass.clear();
  }

  Future CreateChildAccount(
      String name, String age, String user, String pass) async {
    final response = await http
        .post(links().add_new_child, body: {
      "name": name,
      "age": age,
      "username": user,
      "password": pass,
      "parent_id": parent_id.toString()
    });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم انشاء حساب للطفل بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.lightGreen[800],
      ));
      ClearInputs();
      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        Navigator.pushReplacementNamed(context, '/parentHomeScreen');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("حدثت مشكلة اثناء انشاء حساب للطفل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    }
  }

  void initState() {
    check();
    super.initState();
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parent_username = prefs.getString('parent_username');
    var parent_id = prefs.getInt('parent_id');
    print("parent_username = ${parent_username}");
    print("parent_id into = ${parent_id}");
    setData(parent_id);
  }

  void setData(id) {
    setState(() {
      parent_id = id.toInt();
    });
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
                color: Colors.lightBlue,
              )),
          title: Text(
            "اضافة بيانات طفل جديد",
            style: TextStyle(color: Colors.lightBlue),
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: AssetImage('images/child.png'),
                        height: 130.0,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: name,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "اسم الطفل ",
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
                            return "* نسيت ادخال اسم الطفل ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: age,
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "العمر",
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
                            return "* نسيت ادخال العمر للطفل ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
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
                        height: 30,
                      ),
                      TextButton(
                        style: flatButtonStyle,
                     
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            CreateChildAccount(
                                name.text, age.text, user.text, pass.text);
                          }
                        },
                      
                        child: Container(
                          child: Text(
                            "انشاء الحساب",
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
                        height: 30,
                      ),
                      TextButton(
                       style: flatButtonStyle,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                
                        child: Container(
                          child: Text(
                            "الغاء",
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

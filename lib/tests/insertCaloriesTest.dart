import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'package:noom_app2/styles.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class InsertColariesTest extends StatefulWidget {
  final String child_id;
  final String child_name;
  const InsertColariesTest({Key key, this.child_id, this.child_name})
      : super(key: key);

  @override
  State<InsertColariesTest> createState() => _InsertColariesTestState();
}

class _InsertColariesTestState extends State<InsertColariesTest> {
  int parent_id;
  dynamic date = "";
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();

  TextEditingController mealName = new TextEditingController();
  TextEditingController testValue = new TextEditingController();

  Future InsertColaresData(
      String testValue, String child_id, String mealName) async {
    final response = await http.post(links().insert_colaries, body: {
      "readingValue": testValue,
      "child_id": child_id,
      "mealName": mealName,
      "parent_id": parent_id.toString()
    });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم حفظ  الكربوهيدرات للطفل بنجاح",
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

  void dispose() {
    super.dispose();
    testValue.dispose();
  }

  void ClearInputs() {
    testValue.clear();
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
    DateTime now = DateTime.now();
    setState(() {
      parent_id = id.toInt();
      date = "${now.year}-${now.month}-${now.day}";
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
            "اضافة  كربوهيدرات جديده",
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
                        height: 30,
                      ),
                      Text(
                        "اسم الطفل : " + widget.child_name,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: testValue,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "ادخل مقدرا الكربوهيدرات",
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
                            return "* نسيت ادخال  ";
                          } else if (int.parse(value) > 300) {
                            return "* قيمة يجب ان تكون بين 0 ~ 300 ";
                          } else if (int.parse(value)  <5) {
                            return "* قيمة الفحص يجب ان تكون اكبر من الصفر ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: mealName,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "ادخل  اسم الوجبة",
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
                            return "* نسيت ادخال  اسم الوجبة ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        style: flatButtonStyle,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            InsertColaresData(
                                testValue.text, widget.child_id, mealName.text);
                          }
                        },
                        child: Container(
                          child: Text(
                            "حفظ الكربوهيدرات",
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

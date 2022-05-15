import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class InsertSugarTest extends StatefulWidget {
  final String child_id;
  final String child_name;
  const InsertSugarTest({Key key, this.child_id, this.child_name})
      : super(key: key);

  @override
  State<InsertSugarTest> createState() => _InsertSugarTestState();
}

class _InsertSugarTestState extends State<InsertSugarTest> {
  int parent_id;
  dynamic date = "";
  bool isEatingSugar = false;
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();

  TextEditingController testValue = new TextEditingController();

  Future InsertSugarData(
      String testValue, String child_id, bool isEatingSugar) async {
    final response = await http.post(
        "http://barhomoutlet.com/api/noom_app/insertSugarReading.php",
        body: {
          "readingValue": testValue,
          "isEatingSugar": isEatingSugar.toString(),
          "child_id": child_id,
          "parent_id": parent_id.toString()
        });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("تم حفظ فحص السكر للطفل بنجاح",
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
      snackBarScafflod.currentState.showSnackBar(SnackBar(
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
            "اضافة فحص سكري جديد",
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
                        controller: testValue,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "ادخل فحص السكري",
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
                            return "* نسيت ادخال فحص السكري ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Switch(
                            value: isEatingSugar,
                            onChanged: (value) {
                              setState(() {
                                isEatingSugar = value;
                                print(isEatingSugar);
                              });
                            },
                          ),
                          Text(
                            "هل اكل حلويات/سكر في الامس؟",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            InsertSugarData(
                                testValue.text, widget.child_id, isEatingSugar);
                          }
                        },
                        color: Colors.lightBlue,
                        child: Container(
                          child: Text(
                            "حفظ الفحص",
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
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.redAccent),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.redAccent,
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

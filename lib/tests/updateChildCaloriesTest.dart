import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'package:noom_app2/styles.dart';
import 'dart:async';

class UpdateChildCaloriesTest extends StatefulWidget {
  final String child_id;
  final String readingValue;
  final String test_id;
  final String readingDate;
  const UpdateChildCaloriesTest(
      {Key key,
      this.child_id,
      this.readingValue,
      this.test_id,
      this.readingDate})
      : super(key: key);
  @override
  State<UpdateChildCaloriesTest> createState() =>
      _UpdateChildCaloriesTestState();
}

class _UpdateChildCaloriesTestState extends State<UpdateChildCaloriesTest> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController testValue = new TextEditingController();
  String readingValue;
  String child_id;
  String test_id;
  String readingDate;

  @override
  void dispose() {
    super.dispose();
    testValue.dispose();
  }

  @override
  void initState() {
    print(widget.child_id);
    setState(() {
      readingValue = widget.readingValue;
      testValue.text = readingValue;
      child_id = widget.child_id;
      test_id = widget.test_id;
      readingDate = widget.readingDate;
    });
    super.initState();
  }

  Future UpdateCaloriesData(
      String testValue, String child_id, String test_id) async {
    final response = await http.post(links().update_Calories_test, body: {
      "readingValue": testValue,
      "child_id": child_id,
      "test_id": test_id.toString()
    });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم تعديل فحص للطفل بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.lightGreen[800],
      ));
      print("test" + testValue.toString());
      print("child:" + child_id.toString());
      print("testid:" + test_id.toString());

      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        Navigator.pushReplacementNamed(context, '/parentHomeScreen');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("حدثت مشكلة اثناء انشاء تعديل فحص للطفل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    }
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
            "  تعديل فحص ",
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
                        "تاريخ الفحص",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        readingDate,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: testValue,
                        textAlign: TextAlign.left,
                        maxLength: 3,
                        decoration: InputDecoration(
                          labelText: "ادخل فحص الكربوهيدرات",
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
                            return "* نسيت ادخال فحص ";
                          } else if (int.parse(value) > 300) {
                            return "* قيمة يجب ان تكون بين 0 ~ 300 ";
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
                            UpdateCaloriesData(testValue.text, widget.child_id,
                                widget.test_id);
                          }
                        },
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

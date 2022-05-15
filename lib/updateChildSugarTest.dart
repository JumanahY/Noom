import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateChildSugarTest extends StatefulWidget {
  final String child_id;
  final String readingValue;
  final String test_id;
  final String readingDate;
  const UpdateChildSugarTest(
      {Key key,
      this.child_id,
      this.readingValue,
      this.test_id,
      this.readingDate})
      : super(key: key);
  @override
  State<UpdateChildSugarTest> createState() => _UpdateChildSugarTestState();
}

class _UpdateChildSugarTestState extends State<UpdateChildSugarTest> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController testValue = new TextEditingController();
  String readingValue;
  String child_id;
  String test_id;
  String readingDate;
  bool isEatingSugar = false;

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

  Future UpdateSugarData(String testValue, String child_id, String test_id,
      bool isEatingSugar) async {
    final response = await http.post(
        "http://barhomoutlet.com/api/noom_app/updateSugarReading.php",
        body: {
          "readingValue": testValue,
          "child_id": child_id,
          "isEatingSugar": isEatingSugar.toString(),
          "test_id": test_id.toString()
        });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("تم تعديل فحص السكري للطفل بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.lightGreen[800],
      ));
      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        Navigator.pushReplacementNamed(context, '/parentHomeScreen');
      });
    } else {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("حدثت مشكلة اثناء انشاء تعديل فحص السكري للطفل",
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
            "  تعديل فحص سكري ",
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
                            UpdateSugarData(testValue.text, widget.child_id,
                                widget.test_id, isEatingSugar);
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

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateSleepInterval extends StatefulWidget {
  final String child_id;
  final String sleep_id;
  final String sleep_start;
  final String sleep_end;
  final String status;
  const UpdateSleepInterval(
      {Key key,
      this.child_id,
      this.sleep_id,
      this.sleep_start,
      this.sleep_end,
      this.status})
      : super(key: key);

  @override
  State<UpdateSleepInterval> createState() => _UpdateSleepIntervalState();
}

class _UpdateSleepIntervalState extends State<UpdateSleepInterval> {
  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  TextEditingController startTime = new TextEditingController();
  TextEditingController endTime = new TextEditingController();
  String sleep_id;
  String child_id;
  String sleep_start;
  String sleep_end = "";
  String status;

  @override
  void dispose() {
    startTime.dispose();
    endTime.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.child_id);
    setState(() {
      sleep_id = widget.sleep_id;
      startTime.text = widget.sleep_start;
      endTime.text = widget.sleep_end;
      child_id = widget.child_id;
      sleep_id = widget.sleep_id;
    });
    super.initState();
  }

  Future UpdateSleepData(String sleep_start, String sleep_end, String child_id,
      String sleep_id, String status) async {
    final response = await http.post(
        "http://barhomoutlet.com/api/noom_app/updateSleepInterval.php",
        body: {
          "sleep_start": sleep_start,
          "sleep_end": sleep_end,
          "child_id": child_id,
          "sleep_id": sleep_id.toString(),
          "status": status.toString()
        });

    var reqStatus = json.decode(response.body);

    if (reqStatus[0]['done'] == "true") {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("تم تعديل فترات النوم للطفل بنجاح",
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
        content: Text("حدثت مشكلة اثناء انشاء تعديل فترات النوم للطفل",
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
            "  تعديل فترات النوم ",
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
                        "وقت النوم",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      TextFormField(
                        controller: startTime,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "ادخل وقت النوم",
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
                            return "*نسيت ادخال وقت النوم ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "وقت الاستيقاظ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                      TextFormField(
                        controller: endTime,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: "ادخل وقت الاستيقاظ",
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
                            return "* نسيت ادخال وقت الاستيقاظ ";
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
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
                            UpdateSleepData(
                                startTime.text,
                                endTime.text,
                                widget.child_id,
                                widget.sleep_id,
                                widget.status);
                          }
                        },
                        color: Colors.lightBlue,
                        child: Container(
                          child: Text(
                            "حفظ  فترات النوم",
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

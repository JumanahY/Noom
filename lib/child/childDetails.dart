import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/ReportsScreen.dart';
import 'package:noom_app2/insightsScreen.dart';
import 'package:noom_app2/links.dart';
import 'package:noom_app2/tests/ChildCaloriesTest.dart';
import 'package:noom_app2/tests/insertCaloriesTest.dart';
import 'dart:async';

import '../tests/childSugarTests.dart';
import '../tests/insertSugarTest.dart';

import 'childSleepInterval.dart';

class ChildDetails extends StatefulWidget {
  final String parent_id;
  final String child_id;
  final String child_name;
  final String child_age;
  final String child_username;

  const ChildDetails(
      {Key key,
      this.parent_id,
      this.child_id,
      this.child_name,
      this.child_age,
      this.child_username})
      : super(key: key);

  @override
  _ChildDetailsState createState() => _ChildDetailsState();
}

class _ChildDetailsState extends State<ChildDetails> {
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  Future DeleteChild(String child_id) async {
    final response =
        await http.post(links().delete_child, body: {"child_id": child_id});

    var reqStatus = json.decode(response.body);
    print(reqStatus);

    if (reqStatus[0]['done'] == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم حذف الطفل بنجاح",
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("حدث خطأ",
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
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("رسوم بيانية"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("تقارير اسبوعية"),
                  ),
                ];
              },
              onSelected: ((value) {
                if (value == 0) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new InsightsScreen(child_id: widget.child_id)));
                } else if (value == 1) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ReportsScreen(child_id: widget.child_id)));
                }
              }),
            )
          ],
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              )),
          title: Text(
            "عرض تفاصيل الطفل" + widget.child_id,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    widget.child_name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.lightBlue[800],
                ),
                Container(
                  height: 240,
                  child: Image.asset(
                    "images/child.png",
                    height: MediaQuery.of(context).size.height / 3.5,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "اسم الطفل: ",
                  style: TextStyle(fontSize: 30.0, color: Colors.lightBlue),
                ),
                Text(
                  widget.child_name.toString(),
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "عمر الطفل: ",
                  style: TextStyle(fontSize: 30.0, color: Colors.lightBlue),
                ),
                Text(
                  widget.child_age.toString() + " سنة ",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "اسم المتسخدم الطفل: ",
                  style: TextStyle(fontSize: 30.0, color: Colors.lightBlue),
                ),
                Text(
                  widget.child_username.toString() + " ",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: InkWell(
                    onTap: () {
                      // DeleteChild(widget.child_id);
                      String child_id = widget.child_id.toString();
                      String child_name = widget.child_name.toString();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new InsertColariesTest(
                                      child_id: child_id,
                                      child_name: child_name)));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            "+ الكربوهيدرات",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue[500],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      // DeleteChild(widget.child_id);
                      String child_id = widget.child_id.toString();
                      String child_name = widget.child_name.toString();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ChildCaloriesTests(
                                      child_id: child_id,
                                      child_name: child_name)));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            "عرض الكربوهيدرات",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue[500],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // DeleteChild(widget.child_id);
                        String child_id = widget.child_id.toString();
                        String child_name = widget.child_name.toString();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new InsertSugarTest(
                                        child_id: child_id,
                                        child_name: child_name)));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "+ فحص سكري",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // DeleteChild(widget.child_id);
                        String child_id = widget.child_id.toString();
                        String child_name = widget.child_name.toString();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ChildSugarTests(
                                        child_id: child_id,
                                        child_name: child_name)));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "عرض بيانات السكري",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // DeleteChild(widget.child_id);
                        String child_id = widget.child_id.toString();
                        String child_name = widget.child_name.toString();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ChildSleepInterval(
                                        child_id: child_id,
                                        child_name: child_name)));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "عرض بيانات النوم",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlue[500],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        DeleteChild(widget.child_id);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "حذف بيانات الطفل",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[500],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

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
    final response = await http.post(
        "http://10.0.2.2/api/noom_app/DeleteChild.php",
        body: {"child_id": child_id});

    var reqStatus = json.decode(response.body);
    print(reqStatus);

    if (reqStatus[0]['done'] == "true") {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
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
      snackBarScafflod.currentState.showSnackBar(SnackBar(
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
            "عرض تفاصيل الطفل",
            style: TextStyle(color: Colors.lightBlue),
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
                  widget.child_username.toString() + " سنة ",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(15),
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

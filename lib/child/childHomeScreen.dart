import 'package:flutter/material.dart';
import 'package:noom_app2/links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'childChangePassword.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({Key key}) : super(key: key);

  @override
  _ChildHomeScreenState createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  var child_username = "";
  int child_id;
  int child_status;
  final snackBarScafflod = GlobalKey<ScaffoldState>();
  dynamic time = "";
  dynamic date = "";
  bool _isRunning = true;
  dynamic bgColor = Colors.white;
  bool _sleep = false;
  String btnTitle = "نوم الان";
  var currentTime = "";

  @override
  void initState() {
    check();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isRunning) {
        timer.cancel();
      }
      _getTime();
    });

    super.initState();
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var child_username = prefs.getString('parent_username');
    var child_id = prefs.getInt('child_id');
    var child_status = prefs.getInt('child_status');

    /// print("child_username = ${child_username}");
    print("child_id = ${child_id}");
    print("status = ${child_status}");
    setData(child_username, child_id, child_status);

    ///runApp(MaterialApp(home: email == null ? Login() : Home()));
  }

  void setData(user, id, st) {
    setState(() {
      child_username = user.toString();
      child_id = id.toInt();
      ////  print("st :${st}");
      if (st == 1) {
        _sleep = true;
        btnTitle = "نوم الان";
      } else {
        _sleep = false;
        btnTitle = "استيقاظ";
      }

      /// print("_sleep :${_sleep}");
      child_status = st.toInt();
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("child_username");
    prefs.remove("child_id");
    prefs.remove("child_status");
    Navigator.pushNamed(context, '/loginOptions');
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    var time = TimeOfDay.fromDateTime(DateTime.now());
    TimeOfDay.now().format(context);
    currentTime = TimeOfDay.fromDateTime(DateTime.now()).format(context);

    setState(() {
      date = new DateTime(now.year, now.month, now.day);
      currentTime = "${time.hourOfPeriod}:${time.minute}";

      date = "${now.year}-${now.month}-${now.day}";
      ////print(_sleep);
    });
  }

  Future UpdateSleep() async {
    final response = await http.post(
        links().insert_child_sleep,
        body: {
          "child_id": child_id.toString(),
          "date": date.toString(),
          "time": currentTime.toString(),
          "status": child_status.toString()
        });

    var reqStatus = json.decode(response.body);
    print(reqStatus);
    if (reqStatus[0]['done'] == "true") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("تم حفظ بيانات نومك بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.lightGreen[800],
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("حدثت مشكلة ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: snackBarScafflod,
          appBar: AppBar(
            title: Text("مرحباً ، ${child_username}"),
            backgroundColor: _sleep ? Colors.amber : Colors.black54,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  logout();
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    "مرحباً ، ${child_username}",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text("حساب الطفل - ${child_status} "),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("images/child.png"))),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.lightBlue,
                    size: 34,
                  ),
                  title: Text(
                    "الرئيسية",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.admin_panel_settings_sharp,
                    color: Colors.lightBlue,
                    size: 34,
                  ),
                  title: Text(
                    "تغيير كلمة المرور",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new ChildChangePassword(
                                    child_id: child_id.toString())));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.lightBlue,
                    size: 34,
                  ),
                  title: Text(
                    "تسجيل الخروج",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    logout();
                  },
                ),
              ],
            ),
          ),
          body: Center(
              child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _sleep
                    ? AssetImage("images/wake.jpeg")
                    : AssetImage("images/night.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentTime,
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          UpdateSleep();
                          setState(() {
                            if (!_sleep) {
                              _sleep = true;
                              btnTitle = "نوم الان";
                            } else {
                              _sleep = false;
                              btnTitle = "استيقاظ الان";
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _sleep ? Colors.amber : Colors.black54,
                          ),
                          width: 220,
                          child: Text(
                            "${btnTitle}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}

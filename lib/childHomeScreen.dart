import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'childChangePassword.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({Key key}) : super(key: key);

  @override
  _ChildHomeScreenState createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  var child_username = "";
  int child_id;

  @override
  void initState() {
    check();
    super.initState();
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var child_username = prefs.getString('parent_username');
    var child_id = prefs.getInt('child_id');
    print("child_username = ${child_username}");
    print("child_id = ${child_id}");
    setData(child_username, child_id);

    ///runApp(MaterialApp(home: email == null ? Login() : Home()));
  }

  void setData(user, id) {
    setState(() {
      child_username = user.toString();
      child_id = id.toInt();
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("child_username");
    prefs.remove("child_id");
    Navigator.pushNamed(context, '/loginOptions');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("مرحباً ، ${child_username}"),
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
                  accountEmail: Text("حساب الطفل"),
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
              child: Text(
                " child_id = ${child_id}",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

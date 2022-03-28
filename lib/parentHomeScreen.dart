import 'package:noom_app2/parentChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({Key key}) : super(key: key);

  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  var parent_username = "";
  int parent_id;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("مرحباً ، ${parent_username}"),
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
                    "مرحباً ، ${parent_username}",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text("حساب الابوين"),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("images/parent.png"))),
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
                    Icons.add_circle,
                    color: Colors.lightBlue,
                    size: 34,
                  ),
                  title: Text(
                    "اضافة طفل جديد",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/addNewChild");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.view_module,
                    color: Colors.lightBlue,
                    size: 34,
                  ),
                  title: Text(
                    "عرض اطفالي",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.lightBlue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/viewMyChildern");
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
                                new ParentChangePassword(
                                    parent_id: parent_id.toString())));
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
                " Parent_id = ${parent_id}",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parent_username = prefs.getString('parent_username');
    var parent_id = prefs.getInt('parent_id');
    print("parent_username = ${parent_username}");
    print("parent_id = ${parent_id}");
    setData(parent_username, parent_id);

    ///runApp(MaterialApp(home: email == null ? Login() : Home()));
  }

  void setData(user, id) {
    setState(() {
      parent_username = user.toString();
      parent_id = id.toInt();
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("parent_username");
    prefs.remove("parent_id");
    Navigator.pushNamed(context, '/loginOptions');
  }
}

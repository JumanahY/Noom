import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'child/childChangePassword.dart';
import 'links.dart';

class ReportsScreen extends StatefulWidget {
  final String child_id;
  const ReportsScreen({
    this.child_id,
  });
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var child_username = "";

  List list = [];
  List report = [];

  Future<List> fetchsugarreport() async {
    final response =
        await http.get(links().Sugarweeklyreport + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        report = json.decode(response.body);
      });
    }
    print(report[0]["readingDate"]);
    return report;
  }

  Future<List> fetchCloriesreport() async {
    final response = await http.get(links().weeklyreport + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        list = json.decode(response.body);
      });
    }
    print(list[0]["readingDate"]);
    return list;
  }

  void initState() {
    super.initState();
    check();
    fetchCloriesreport();
    fetchsugarreport();
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var child_username = prefs.getString('parent_username');
    print("child_username = ${child_username}");
  }

  void setData(user, id) {
    setState(() {
      child_username = user.toString();
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("child_username");
    prefs.remove("child_id");
    Navigator.pushNamed(context, '/loginOptions');
  }

  bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("مرحباً ، ${widget.child_id.toString()}"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "مرحباً ، ${child_username}",
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text("حساب الطفل"),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
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
                                  child_id: widget.child_id.toString())));
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xff262545),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              SizedBox(height: 50),
              Expanded(
                child: ListView(children: <Widget>[
                  Center(
                      child: Text(
                    'تقرير اسبوعي',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('التاريخ ')),
                          DataColumn(label: Text(' مستوى الجلوكوز')),
                        ],
                        rows: _createRows(),
                        headingTextStyle: TextStyle(color: Colors.white),
                        dataTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView(children: <Widget>[
                  Center(
                      child: Text(
                    'تقرير اسبوعي',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('الايام / الوجبات')),
                          DataColumn(label: Text(' الاولى')),
                          DataColumn(label: Text(' الثانية')),
                        ],
                        rows: _createClories(),
                        headingTextStyle: TextStyle(color: Colors.white),
                        dataTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataRow> _createRows() {
    return report
        .map((report) => DataRow(cells: [
              DataCell(Text(report['readingDate'].toString())),
              DataCell(Text(report['readingValue'])),
              // DataCell(Text(report['mealName']))
            ]))
        .toList();
  }

  List<DataRow> _createClories() {
    return list
        .map((list) => DataRow(cells: [
              DataCell(Text(list['readingDate'].toString())),
              DataCell(Text(list['readingValue'])),
              DataCell(Text(list['mealName']))
            ]))
        .toList();
  }
}

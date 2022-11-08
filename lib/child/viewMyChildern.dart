import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'childDetails.dart';

class ViewMyChildern extends StatefulWidget {
  const ViewMyChildern({Key key}) : super(key: key);

  @override
  _ViewMyChildernState createState() => _ViewMyChildernState();
}

class _ViewMyChildernState extends State<ViewMyChildern> {
  bool loading = true;
  List list;
  dynamic parent_id = "0";

  void initState() {
    super.initState();
    check();
    fetchMyChlid();
  }

  Future check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parent_username = prefs.getString('parent_username');
    parent_id = prefs.getInt('parent_id');

    /// print("PID : ${parent_id}");
    return parent_id;
  }

  Future<List> fetchMyChlid() async {
    int id = await check();
    print("ID => ${id.toString()}");
    print("---------------------------------");

    final response = await http.get(
        links().view_my_children+"${id.toString()}");
    if (response.statusCode == 200) {
      setState(() {
        list = json.decode(response.body);
        loading = false;
      });
    }
    print(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
         
          body: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(list[index]["name"] + " child Selected");
                        String child_id = list[index]['child_id'];
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ChildDetails(
                                        parent_id: list[index]['parent_id'],
                                        child_id: list[index]['child_id'],
                                        child_name: list[index]['name'],
                                        child_age: list[index]['age'],
                                        child_username: list[index]
                                            ['username'])));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            height: 100,
                            width: MediaQuery.of(context).size.width - 50,
                            color: Colors.transparent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 100,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('images/child.png'),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(list[index]["name"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.lightBlue[800],
                                          ),
                                          overflow: TextOverflow.visible),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        list[index]["username"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.lightBlue),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Old : " + list[index]["age"],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.lightBlue[800]),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
        ));
  }
}

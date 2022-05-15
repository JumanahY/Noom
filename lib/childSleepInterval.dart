import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'updateSleepInterval.dart';

class ChildSleepInterval extends StatefulWidget {
  final String child_id;
  final String child_name;
  const ChildSleepInterval({Key key, this.child_id, this.child_name})
      : super(key: key);

  @override
  State<ChildSleepInterval> createState() => _ChildSleepIntervalState();
}

class _ChildSleepIntervalState extends State<ChildSleepInterval> {
  bool loading = true;
  List list;

  void initState() {
    super.initState();
    //check();
    fetchChlidSleeps(widget.child_id);
  }

  Future<List> fetchChlidSleeps(child_id) async {
    String id = child_id;
    print("ID => ${id.toString()}");
    print("---------------------------------");

    final response = await http.get(
        "http://barhomoutlet.com/api/noom_app/fetchChildSleepIntervals.php?child_id=${id}");
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
              " عرض فترات نوم ${widget.child_name}",
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
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
                        var childname = list[index]["name"];
                        String child_id = list[index]['child_id'];
                        print("${child_id} child Selected");

                        var sleep_start = list[index]["sleep_start"];
                        var sleep_end = list[index]["sleep_end"];
                        var sleep_id = list[index]["sleep_id"];
                        var status = list[index]["status"];
                        print(list[index]);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new UpdateSleepInterval(
                                        child_id: child_id,
                                        sleep_id: sleep_id,
                                        sleep_start: sleep_start,
                                        sleep_end: sleep_end,
                                        status: status)));
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
                                      image: AssetImage('images/sleep.png'),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("تاريخ اليوم : ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.lightBlue[800],
                                              ),
                                              overflow: TextOverflow.visible),
                                          Text(list[index]["day_date"],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.lightBlue[800],
                                              ),
                                              overflow: TextOverflow.visible),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "وقت النوم: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.lightBlue),
                                          ),
                                          Text(
                                            list[index]["sleep_start"],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.lightBlue),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "وقت الاستيقاظ: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.lightBlue),
                                          ),
                                          Text(
                                            list[index]["sleep_end"] != null
                                                ? list[index]["sleep_end"]
                                                : "",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.lightBlue),
                                          ),
                                        ],
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

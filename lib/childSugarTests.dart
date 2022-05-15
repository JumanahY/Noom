import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'updateChildSugarTest.dart';

class ChildSugarTests extends StatefulWidget {
  final String child_id;
  final String child_name;
  const ChildSugarTests({Key key, this.child_id, this.child_name})
      : super(key: key);

  @override
  State<ChildSugarTests> createState() => _ChildSugarTestsState();
}

class _ChildSugarTestsState extends State<ChildSugarTests> {
  bool loading = true;
  List list;

  void initState() {
    super.initState();
    //check();
    fetchChlidSugarTests(widget.child_id);
  }

  Future<List> fetchChlidSugarTests(child_id) async {
    String id = child_id;
    print("ID => ${id.toString()}");
    print("---------------------------------");

    final response = await http.get(
        "http://barhomoutlet.com/api/noom_app/fetchChildSugarTests.php?child_id=${id}");
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
              " عرض فحوصات السكري ${widget.child_name}",
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
                        String child_id = list[index]['child_id'];
                        String readingValue = list[index]['readingValue'];
                        String sugurTest_id = list[index]['sugurTest_id'];
                        String readingDate = list[index]['readingDate'];
                        String eatSugar = list[index]['eatSugar'];
                        print(
                            "${sugurTest_id} sugurTest_id for child ${child_id} Selected");
                        print(list);

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new UpdateChildSugarTest(
                                        child_id: child_id,
                                        test_id: sugurTest_id,
                                        readingValue: readingValue,
                                        readingDate: readingDate)));
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
                                  width: 15,
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
                                          Text(list[index]["readingDate"],
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
                                            "قراءة الفحص:",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.lightBlue),
                                          ),
                                          Text(
                                            list[index]["readingValue"],
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
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              "اكل حلويات بالامس؟",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.lightBlue),
                                            ),
                                          ),
                                          if (list[index]["eatSugar"] ==
                                              "1") ...[
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "نعم",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ] else ...[
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "لا",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ],
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

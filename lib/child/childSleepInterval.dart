import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noom_app2/links.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'updateSleepInterval.dart';
import 'package:tflite_flutter/tflite_flutter.dart';


class ChildSleepInterval extends StatefulWidget {
  final String child_id;
  final String child_name;
  //final String sleep_start;
 // final String sleep_end;
  const ChildSleepInterval({Key key, this.child_id, this.child_name})
      : super(key: key);

  @override
  State<ChildSleepInterval> createState() => _ChildSleepIntervalState();
}

class _ChildSleepIntervalState extends State<ChildSleepInterval> {
  bool loading = false;
  List list;
  int sleepQaulty, glucose, _outputs;
  final DateTime start_d= DateTime.now();   //tril
  final DateTime end_d=DateTime.now();        //tril
  var predValue = "";
  int start_date,end_date, sd,ed, timeInBed;

  get predData => null;
  void initState() {
    super.initState();
    predValue = "click predict model button";
    loading=true;
    //check();
    fetchChlidSleeps(widget.child_id);

     loadModel().then((value) {
          setState(() {
            loading = false;
          });
        });
  }


  //load model from assests directory
 // loadModel() async {
 //     await Tflite.loadModel(
  //      model: "assests/model.tflite",

   //   );
   // }

    // preprocess for data, input start and end to sleep interval and rate colucos
     preprocessing() async {

     //convert date to millisecond
     start_date = start_d.millisecondsSinceEpoch;
     end_date = end_d.millisecondsSinceEpoch;

     sd = (start_date/1000).toInt();       //convert to second
     ed = (end_date/1000).toInt();
     timeInBed = ed- sd; //or input in second
     sleepQaulty = ((timeInBed/86000)*100).toInt();   //86000 is number seconds for 24 hours
     //int slpq=sleepQaulty.toInt();
     glucose=95;   // the gulcose input from user

        classify(sleepQaulty,glucose,timeInBed,sd,ed);
        }
     // classify
    Future classify(int sleepQaulty,int glucose, int timeInBed, int sd,int ed) async{
     var input=[
     [sleepQaulty, glucose,timeInBed, sd,ed] ];

        final interpreter = await Interpreter.fromAsset('model.tflite');

            var output = List.filled(1, 0).reshape([1, 1]);
            interpreter.run(input, output);
            print(output[0][0]);

            this.setState(() {
              predValue = output[0][0].toString();
              loading = false;
            });

     }

    // close tflite
   // void dispose(){
   //   Tflite.close();
    //  super.dispose();

   // }

  Future<List> fetchChlidSleeps(child_id) async {
    String id = child_id;
    print("ID => ${id.toString()}");
    print("---------------------------------");

    final response = await http.get(
        links().child_sleep_interval+"${id}");
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
                                      ),  ////////////////////
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
                                      /////////////////////////
                                      Row(
                                         mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                             children: [
                                                   Text(
                                                     "change the input values in code to get the prediction",
                                                      style: TextStyle(
                                                       fontSize: 20,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.lightBlue),
                                                         ),
                                                        Text(

                                                          "predict",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                           fontWeight: FontWeight.w500,
                                                            color: Colors.lightBlue),
                                                             onPressed: predData,
                                                            ),
                                                           SizedBox(height: 12),
                                                            Text(
                                                              "Predicted value :  $predValue ",
                                                               style: TextStyle(color: Colors.red, fontSize: 23),
                                                        ),

                                                     ],
                                              ),/////////////
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

  loadModel() {}
}

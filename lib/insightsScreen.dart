import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_chart/time_chart.dart';

import 'child/childChangePassword.dart';
import 'indcators.dart';
import 'links.dart';

class InsightsScreen extends StatefulWidget {
  final String child_id;
  const InsightsScreen({
    this.child_id,
  });
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  var child_username = "";

  List list = [];
  List sugarlist = [];
  List listSleep = [];
  Future<List> fetchMyChlidsleep() async {
    final response =
        await http.get(links().child_sleep_interval + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        listSleep = json.decode(response.body);
        print("gaming");
      });
    }
    print(listSleep[0]["day_date"].toString() +
        listSleep[0]["sleep_start"].toString());

    return listSleep;
  }

  Future<List> fetchMyChlid() async {
    final response = await http.get(links().graph_login + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        list = json.decode(response.body);
        print("gaming");
      });
    }
    print(list[0]["readingDate"]);
    return list;
  }

  Future<List> sugarGraph() async {
    final response = await http.get(links().graph_sugartest + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        sugarlist = json.decode(response.body);
        print("gaming");
      });
    }
    print(sugarlist[0]["readingDate"]);
    return sugarlist;
  }

  void initState() {
    super.initState();
    check();
    fetchMyChlidsleep();
    fetchMyChlid();

    sugarGraph();
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
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xff262545),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 100,
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.32,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff2c274c),
                            Color(0xff46426c),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Material(
                        color: Color(0xff2c274c),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const SizedBox(
                                  height: 37,
                                ),
                                const Text(
                                  'مستوى الكربوهيدرات',
                                  style: TextStyle(
                                    color: Color(0xff827daa),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 6.0),
                                    child: list.length < 7
                                        ? Text(
                                            "لا يظهر المخطط الا بعد اكتمال سبعة ادخالات ",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )
                                        : LineChart(
                                            sampleData1,
                                            swapAnimationDuration:
                                                const Duration(
                                                    milliseconds: 250),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'مستوى الجلوكوز  (السكر)',
                                  style: TextStyle(
                                    color: Color(0xff827daa),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 6.0),
                                    child: list.length < 7
                                        ? Text(
                                            "لا يظهر المخطط الا بعد اكتمال سبعة ادخالات ",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )
                                        : LineChart(
                                            sampleData2,
                                            swapAnimationDuration:
                                                const Duration(
                                                    milliseconds: 250),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'نظرة عامة ',
                                  style: TextStyle(
                                    color: Color(0xff827daa),
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                indcators(),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 6.0),
                                    child: list.length < 7
                                        ? Text(
                                            "لا يظهر المخطط الا بعد اكتمال سبعة ادخالات ",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          )
                                        : LineChart(
                                            sampleData3,
                                            swapAnimationDuration:
                                                const Duration(
                                                    milliseconds: 250),
                                          ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'مخطط ساعات النوم ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        TimeChart(
                                          data: _createGraph(),
                                          viewMode: ViewMode.weekly,
                                          chartType: ChartType.amount,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 300,
        maxY: 300,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 600,
        maxY: 600,
        minY: 0,
      );

  LineChartData get sampleData3 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData3,
        borderData: borderData,
        lineBarsData: lineBarsData3,
        minX: 0,
        maxX: 600,
        maxY: 600,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );
  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles2,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles2(),
        ),
      );
  FlTitlesData get titlesData3 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles2,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles2(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData1_2,
      ];

  List<LineChartBarData> get lineBarsData3 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = "1";
        break;
      case 50:
        text = "50";
        break;
      case 100:
        text = "100";
        break;
      case 150:
        text = "150";
        break;
      case 200:
        text = "200";
        break;
      case 250:
        text = "250";
        break;
      case 300:
        text = "300";
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget leftTitleWidgets2(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = "1";
        break;
      case 100:
        text = "100";
        break;
      case 200:
        text = "200";
        break;
      case 300:
        text = "300";
        break;
      case 400:
        text = "400";
        break;
      case 500:
        text = "500";
        break;
      case 600:
        text = "600";
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );
  SideTitles leftTitles2() => SideTitles(
        getTitlesWidget: leftTitleWidgets2,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text("${list[0]["readingDate"].toString()}", style: style);
        break;
      case 50:
        text = Text("${list[1]["readingDate"].toString()}", style: style);
        break;
      case 100:
        text = Text("${list[2]["readingDate"].toString()}", style: style);
        break;
      case 150:
        text = Text("${list[3]["readingDate"].toString()}", style: style);
        break;
      case 200:
        text = Text("${list[4]["readingDate"].toString()}", style: style);
        break;
      case 250:
        text = Text("${list[5]["readingDate"].toString()}", style: style);
        break;
      case 300:
        text = Text("${list[6]["readingDate"].toString()}", style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  Widget bottomTitleWidgets2(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text("${list[0]["readingDate"].toString()}", style: style);
        break;
      case 100:
        text = Text("${list[1]["readingDate"].toString()}", style: style);
        break;
      case 200:
        text = Text("${list[2]["readingDate"].toString()}", style: style);
        break;
      case 300:
        text = Text("${list[3]["readingDate"].toString()}", style: style);
        break;
      case 400:
        text = Text("${list[4]["readingDate"].toString()}", style: style);
        break;
      case 500:
        text = Text("${list[5]["readingDate"].toString()}", style: style);
        break;
      case 600:
        text = Text("${list[6]["readingDate"].toString()}", style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );
  SideTitles get bottomTitles2 => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets2,
      );
  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff4af699),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, double.parse(list[0]["readingValue"])),
          FlSpot(50, double.parse(list[1]["readingValue"])),
          FlSpot(100, double.parse(list[2]["readingValue"])),
          FlSpot(150, double.parse(list[3]["readingValue"])),
          FlSpot(200, double.parse(list[4]["readingValue"])),
          FlSpot(250, double.parse(list[5]["readingValue"])),
          FlSpot(300, double.parse(list[6]["readingValue"])),
        ],
      );
  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0xffaa4cfc),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, double.parse(sugarlist[0]["readingValue"])),
          FlSpot(100, double.parse(sugarlist[1]["readingValue"])),
          FlSpot(200, double.parse(sugarlist[2]["readingValue"])),
          FlSpot(300, double.parse(sugarlist[3]["readingValue"])),
          FlSpot(400, double.parse(sugarlist[4]["readingValue"])),
          FlSpot(500, double.parse(sugarlist[5]["readingValue"])),
          FlSpot(600, double.parse(sugarlist[6]["readingValue"])),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff27b6fc),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, double.parse(listSleep[0]["sleeplength"])),
          FlSpot(4, double.parse(listSleep[1]["sleeplength"])),
          FlSpot(8, double.parse(listSleep[2]["sleeplength"])),
          FlSpot(12, double.parse(listSleep[3]["sleeplength"])),
          FlSpot(16, double.parse(listSleep[4]["sleeplength"])),
          FlSpot(20, double.parse(listSleep[5]["sleeplength"])),
          FlSpot(24, double.parse(listSleep[6]["sleeplength"])),
        ],
      );

  List<DateTimeRange> _createGraph() {
    return listSleep
        .map((listSleep) => DateTimeRange(
              start: DateTime.parse(
                  "${listSleep["day_date"].toString()} ${listSleep["sleep_start"].toString()}"),
              end: DateTime.parse(
                  "${listSleep["day_date"].toString()} ${listSleep["sleep_end"].toString()}"),
            ))
        .toList();
  }
}

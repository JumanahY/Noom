import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'child/childChangePassword.dart';
import 'links.dart';

class GraphsScreen extends StatefulWidget {
  final String child_id;
  const GraphsScreen({
    this.child_id,
  });
  @override
  State<GraphsScreen> createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  var child_username = "";

  List list = [];
  List report = [];

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

  Future<List> fetchreportdata() async {
    final response = await http.get(links().weeklyreport + widget.child_id);
    if (response.statusCode == 200) {
      setState(() {
        report = json.decode(response.body);
        print("report");
      });
    }
    print(report[0]["readingDate"]);
    return report;
  }

  void initState() {
    super.initState();
    check();
    fetchMyChlid();
    fetchreportdata();
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xff262545),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 36.0,
                    top: 24,
                  ),
                  child: Text(
                    'توضيحات',
                    style: TextStyle(
                      color: Color(
                        0xff6f6f97,
                      ),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 28,
                  right: 28,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
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
                              const Text(
                                'للطفل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
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
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      : LineChart(
                                          sampleData1,
                                          swapAnimationDuration:
                                              const Duration(milliseconds: 250),
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
                        rows: _createRows(),
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

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 3000,
        maxY: 3000,
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

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        // lineChartBarData1_2,
        // lineChartBarData1_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 100:
        text = "100";
        break;
      case 500:
        text = "500";
        break;
      case 1000:
        text = "1000";
        break;
      case 1500:
        text = "1500";
        break;
      case 2000:
        text = "2000";
        break;
      case 2500:
        text = "2500";
        break;
      case 3000:
        text = "3000";
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 100:
        text = Text("${list[0]["readingDate"].toString()}", style: style);
        break;
      case 500:
        text = Text("${list[1]["readingDate"].toString()}", style: style);
        break;
      case 1000:
        text = Text("${list[2]["readingDate"].toString()}", style: style);
        break;
      case 1500:
        text = Text("${list[3]["readingDate"].toString()}", style: style);
        break;
      case 2000:
        text = Text("${list[4]["readingDate"].toString()}", style: style);
        break;
      case 2500:
        text = Text("${list[5]["readingDate"].toString()}", style: style);
        break;
      case 3000:
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

  FlGridData get gridData => FlGridData(show: true);

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
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true),
        spots: [
          FlSpot(100, double.parse(list[0]["readingValue"])),
          FlSpot(500, double.parse(list[1]["readingValue"])),
          FlSpot(1000, double.parse(list[2]["readingValue"])),
          FlSpot(1500, double.parse(list[3]["readingValue"])),
          FlSpot(2000, double.parse(list[4]["readingValue"])),
          FlSpot(2500, double.parse(list[5]["readingValue"])),
          FlSpot(3000, double.parse(list[6]["readingValue"])),
        ],
      );

  List<DataRow> _createRows() {
    return report
        .map((report) => DataRow(cells: [
              DataCell(Text(report['readingDate'].toString())),
              DataCell(Text(report['readingValue'])),
              DataCell(Text(report['mealName']))
            ]))
        .toList();
  }
}

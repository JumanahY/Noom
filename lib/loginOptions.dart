import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:noom_app2/GraphScreen.dart';

import 'TrailsScreen.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key key}) : super(key: key);

  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("texs"),
                  content: Text("thelrjlkdfjklsdjfkldsjflkds"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Dont'\t Allow")),
                    TextButton(
                        onPressed: () => AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((_) => Navigator.pop(context)),
                        child: Text("Allow")),
                  ],
                ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تطبيق النوم"),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 4,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "اختر نوع المستخدم",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.lightBlueAccent),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/childLoginScreen");
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "images/child.png",
                          width: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "شاشة الطفل",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.lightBlueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/parentOptions");
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "images/parent.png",
                          width: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "شاشة الابوين",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.lightBlueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(onPressed: () {
                     Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new GraphsScreen(
                                child_id: 1.toString())));
                  }, child: Text("Grapgs")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:noom_app2/parent/parentChangePassword.dart';
import 'package:noom_app2/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'child/addNewChild.dart';
import 'child/childChangePassword.dart';
import 'child/childForgetPass.dart';
import 'child/childDetails.dart';
import 'child/childHomeScreen.dart';
import 'child/childLoginScreen.dart';
import 'loginOptions.dart';
import 'parent/parentHomeScreen.dart';
import 'parent/parentForgetPass.dart';
import 'parent/parentLoginScreen.dart';
import 'parent/parentOptions.dart';
import 'parent/parentRegisterScreen.dart';
import 'child/viewMyChildern.dart';

String parent_id = "";
String child_id = "";

void main() {
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    // 'resource://drawable/codex_logo',
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
          channelShowBadge: true,
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'تطبيق النوم',
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        routes: <String, WidgetBuilder>{
          "/welcomeScreen": (context) => new WelcomeScreen(),
          "/loginOptions": (context) => new LoginOptions(),
          "/parentOptions": (context) => new ParentOptions(),
          "/parentLoginScreen": (context) => new ParentLoginScreen(),
          "/parentRegisterScreen": (context) => new ParentRegisterScreen(),
          "/parentHomeScreen": (context) => new ParentHomeScreen(),
          "/parentForgetPass": (context) => new ParentForgetPass(),
          "/addNewChild": (context) => new AddNewChild(),
          "/viewMyChildern": (context) => new ViewMyChildern(),
          "/childDetails": (context) => new ChildDetails(),
          "/parentChangePassword": (context) => new ParentChangePassword(
                parent_id: parent_id,
              ),
          "/childLoginScreen": (context) => new ChildLoginScreen(),
          "/childHomeScreen": (context) => new ChildHomeScreen(),
         
          "/childChangePassword": (context) => new ChildChangePassword(
                child_id: child_id,
              ),
          "/childForgetPass": (context) => new ChildForgetPass(),
        });
  }
}

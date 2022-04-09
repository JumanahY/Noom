import 'package:noom_app2/parentChangePassword.dart';
import 'package:noom_app2/welcomeScreen.dart';
import 'package:flutter/material.dart';

import 'addNewChild.dart';
import 'childChangePassword.dart';
import 'childForgetPass.dart';
import 'childDetails.dart';
import 'childHomeScreen.dart';
import 'childLoginScreen.dart';
import 'loginOptions.dart';
import 'parentHomeScreen.dart';
import 'parentForgetPass.dart';
import 'parentLoginScreen.dart';
import 'parentOptions.dart';
import 'parentRegisterScreen.dart';
import 'viewMyChildern.dart';

String parent_id = "";
String child_id = "";

void main() {
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

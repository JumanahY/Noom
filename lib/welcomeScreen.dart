import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    var d = Duration(seconds: 2);
    Future.delayed(d, () {
      Navigator.pushNamed(context, "/loginOptions");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Center(
            child: Image(
          image: AssetImage('images/noomLogo.png'),
          height: 150,
        )),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.png'), fit: BoxFit.cover)),
      ),
    );
  }
}

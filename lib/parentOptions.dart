import 'package:flutter/material.dart';

class ParentOptions extends StatefulWidget {
  const ParentOptions({Key key}) : super(key: key);

  @override
  _ParentOptionsState createState() => _ParentOptionsState();
}

class _ParentOptionsState extends State<ParentOptions> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "خيارات الابوين",
            style: TextStyle(color: Colors.blue),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/loginOptions');
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.lightBlue,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "خيارات الابوين",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.lightBlueAccent),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    "images/parent.png",
                    height: 150,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/parentLoginScreen');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تسجيل الدخول الان!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minWidth: double.infinity,
                    height: 60,
                    color: Colors.lightBlueAccent,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.lightBlue),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/parentRegisterScreen");
                    },
                    //color: Colors.brown,
                    child: Container(
                      child: Text(
                        "انشاء حساب جديد",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 20,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 60.0,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  InkWell(
                    onTap: () {
                      print("forget");
                      Navigator.pushNamed(context, "/parentForgetPass");
                    },
                    child: Container(
                      child: Text(
                        "استرجاع كلمة المرور",
                        style: TextStyle(fontSize: 25, color: Colors.lightBlue),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

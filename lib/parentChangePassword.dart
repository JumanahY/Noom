import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ParentChangePassword extends StatefulWidget {
  final String parent_id;
  const ParentChangePassword({Key key, this.parent_id}) : super(key: key);

  @override
  _ParentChangePasswordState createState() => _ParentChangePasswordState();
}

class _ParentChangePasswordState extends State<ParentChangePassword> {
  @override
  void dispose() {
    super.dispose();
    pass1.dispose();
    pass2.dispose();
  }

  void ClearInputs() {
    pass1.clear();
    pass2.clear();
  }

  final formKey = GlobalKey<FormState>();
  final snackBarScafflod = GlobalKey<ScaffoldState>();

  TextEditingController pass1 = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();

  Future ChangePass(String pass1, String pass2, String parent_id) async {
    final response = await http.post(
        "http://10.0.2.2/api/noom_app/ParentChangePass.php",
        body: {"pass1": pass1, "pass2": pass2, "parent_id": parent_id});

    var reqStatus = json.decode(response.body);
    print(reqStatus);

    if (reqStatus[0]['done'] == "true") {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("تم تعديل كلمة المرور بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.lightGreen[800],
      ));
      ClearInputs();

      var d = Duration(seconds: 2);
      Future.delayed(d, () {
        Navigator.pushReplacementNamed(context, '/parentHomeScreen');
      });
    } else {
      snackBarScafflod.currentState.showSnackBar(SnackBar(
        content: Text("حدث خطأ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red[800],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          key: snackBarScafflod,
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
              "تغيير كلمة المرور ",
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Image(
                                    image: AssetImage("images/chgPass.png"),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: pass1,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    labelText: "كلمة المرور الجديدة",
                                    labelStyle:
                                        TextStyle(color: Colors.lightBlue),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "نسيت ادخال كلمة المرور الجديدة";
                                    }
                                    return null;
                                  },
                                  cursorColor: Colors.grey,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: pass2,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    labelText: "تاكيد كلمة المرور",
                                    labelStyle:
                                        TextStyle(color: Colors.lightBlue),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "نسيت ادخال تاكيد كلمة المرور";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 80,
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.lightBlue),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      var pa1 = pass1.text;
                                      var pa2 = pass2.text;

                                      if (pa1 != pa2) {
                                        snackBarScafflod.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "كلمة المرور الجديدة غير متطابقة",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold)),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.red[800],
                                        ));
                                        ClearInputs();
                                      } else if (pa1 == pa2) {
                                        String parent_id =
                                            widget.parent_id.toString();

                                        ChangePass(
                                            pass1.text, pass2.text, parent_id);
                                      }
                                    }
                                  },
                                  color: Colors.lightBlue,
                                  child: Container(
                                    child: Text(
                                      "تغييير كلمة المرور",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    height: 60.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.redAccent),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.redAccent,
                                  child: Container(
                                    child: Text(
                                      "الغاء",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    height: 60.0,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}

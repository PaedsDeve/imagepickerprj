import 'package:flutter/material.dart';
import 'package:imagepickerprj/DBProvider.dart';
import 'package:imagepickerprj/LoginController.dart';
import 'package:imagepickerprj/RegisterUser.dart';
import 'package:imagepickerprj/SampleController.dart';
import 'package:imagepickerprj/SampleRegister.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'Docs Management System';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => new _MyStatefulWidgetState();
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Database db = await DBProvider.internal().db;
            db.rawInsert(
                "INSERT INTO users (userid, passwd) VALUES('user1', 'user1')");

            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String btnText = "";

  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  _showUsers() async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DBProvider().initDb();

    // show the results: print all rows in the db
    print(await db.query("users"));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              focusNode: focusNode,
              validator: (value) {
                if (value.isEmpty)
                  return "Username required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'User Name'),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              validator: (value) {
                if (value.isEmpty)
                  return "Password required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                //_showUsers();
                _submit();
              },
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _clearField,
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: Text(
                'Register',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _registerUser();
                //_submit();
              },
            ),
          ),
        ],
      ),
    );
  }

  _registerUser() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUser()));
  }

  void _login() async {
    final allRows = await LoginController()
        .getLogin(nameController.text, passwordController.text);

    if (allRows.length <= 0) {
      showAlertDialog(context);
      FocusScope.of(context).requestFocus(focusNode);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SampleRegister()));
      //allRows.forEach((row) => userArray.add(Users.fromMap(row)));
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert Dialog"),
      content: Text("User id does not exist or user status is inactive"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _clearField() {
    nameController.text = "";
    passwordController.text = "";
    formKey.currentState.reset();
  }

  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      _login();
    }
  }

  changeText(String txt) {
    txt = "werwe";
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
}
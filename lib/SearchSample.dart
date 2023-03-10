import 'package:flutter/material.dart';
import 'package:imagepickerprj/DBProvider.dart';
import 'package:imagepickerprj/SampleRegister.dart';
import 'package:sqflite/sqflite.dart';
import 'SampleController.dart';

class SearchSample extends StatelessWidget {
  const SearchSample({Key key}) : super(key: key);

  static const String _title = 'Docs Management System';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        title: _title,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: const MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => new _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController SampleIDController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String btnText = "";

  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
                'Search Sample',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: SampleIDController,
              autofocus: true,
              focusNode: focusNode,
              validator: (value) {
                if (value.isEmpty)
                  return "Username required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Sample ID'),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: Text(
                'Search',
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
                'Sample Entry',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _gotoSampleEntry();
              },
            ),
          ),
        ],
      ),
    );
  }

  _gotoSampleEntry() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SampleRegister()));
  }

  void _searchSampleID() async {
    final allRows =
        await SampleController().getSampleInfo(SampleIDController.text);

    if (allRows.length <= 0) {
      showAlertDialog(context);
      FocusScope.of(context).requestFocus(focusNode);
    } else {
      Database db = await DBProvider().initDb();
      print(await db.query("sampleentry"));
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
      content: Text("Sample does not exist"),
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
    formKey.currentState.reset();
    SampleIDController.text = "";
  }

  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
      _searchSampleID();
    }
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Atividade 1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text('Atividade 1')),
          body: SumWidget(),
        ));
  }
}

class SumWidget extends StatefulWidget {
  @override
  _SumWidgetState createState() => _SumWidgetState();
}

class _SumWidgetState extends State<SumWidget> {
  String _result = 'RESULT';
  final _formkey = GlobalKey<FormState>();
  final field1Controller = TextEditingController();
  final field2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
          Field(field1Controller),
          Field(field2Controller),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    color: Colors.grey,
                    child: Text('Sum'),
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        _calculateSum();
                      }
                    })),
          ]),
          Text(_result)
        ])));
  }

  void _calculateSum() {
    setState(() {
      int sum =
          int.parse(field1Controller.text) + int.parse(field2Controller.text);
      _result = '$sum';
    });
  }
}

class Field extends StatelessWidget {
  final TextEditingController fieldController;

  Field(this.fieldController);

  @override 
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
            hintText: 'Enter a Number',
        ),
        controller: fieldController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some value';
          }
          return null;
        },
    );
  }
}

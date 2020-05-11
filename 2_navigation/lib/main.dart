import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
        home: View1(),
));

class View1 extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Atividade 2')
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Form(
                key: _formkey,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                            controller: _textFieldController,
                            decoration: InputDecoration(
                                hintText: 'Enter a message',
                            ),
                            validator: (value) {
                              if( value.isEmpty ) {
                                return 'Please enter a message';
                              }
                              return null;
                            }
                        ),
                    ),
                    FlatButton( 
                        child: Text('Send'),
                        color: Colors.grey,
                        onPressed: (){
                          if( _formkey.currentState.validate() ) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => View2(_textFieldController.text)),
                            );
                          }
                        }
                    ),
                  ]
                )
            )
        )
    );
  }
}

class View2 extends StatelessWidget {
  String message;

  View2(this.message);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Atividade 2')
        ),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(message),
        )
    );
  }
}


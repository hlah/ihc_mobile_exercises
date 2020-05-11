import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

void main() => runApp(MaterialApp(
        home: AccelWidget(),
  )
);


class AccelWidget extends StatefulWidget {
  @override
  _AccelWidgetState createState() => _AccelWidgetState();
}

class _AccelWidgetState extends State<StatefulWidget> {
  bool _accelAvailable = false;
  List<double> _accelData = List.filled(3, 0.0);
  StreamSubscription _accelSubscription;

  @override initState() {
    _checkAccelerometerStatus();
    super.initState();
  }

  @override dispose() {
    _stopAccelerometer();
    super.dispose();
  }

  void _checkAccelerometerStatus() async {
    await SensorManager()
        .isSensorAvailable(Sensors.LINEAR_ACCELERATION)
        .then((result){
          setState((){
            _accelAvailable = result;
            _startAccelerometer();
          });
        });
  }

  Future<void> _startAccelerometer() async {
    if(_accelSubscription != null) return;
    if(_accelAvailable) {
      final stream = await SensorManager().sensorUpdates(
          sensorId: Sensors.LINEAR_ACCELERATION,
          interval: Sensors.SENSOR_DELAY_FASTEST,
      );
      _accelSubscription = stream.listen((sensorEvent){
        setState((){
          _accelData = sensorEvent.data;

          if( _accelData[0] > 30.0 || _accelData[1] > 30.0 || _accelData[2] > 30.0 ) {
            _stopAccelerometer();
            Navigator.push( 
                context,
                MaterialPageRoute(builder: (context) => CorrectPosition()),
            ).whenComplete(() => _startAccelerometer());
          }
        });
      });
    }
  }

  void _stopAccelerometer() {
    if(_accelSubscription == null) return;
    _accelSubscription.cancel();
    _accelSubscription = null;
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar( title: Text('Atividade 3') ),
          body: Row(
              children: <Widget>[
                ValueField('X:', _accelData[0].toStringAsFixed(2)),
                ValueField('Y:', _accelData[1].toStringAsFixed(2)),
                ValueField('Z:', _accelData[2].toStringAsFixed(2)),
              ],
          ),
    );
  }
}

class ValueField extends StatelessWidget {
  String label;
  String value;

  ValueField(this.label, this.value);

  @override 
  Widget build(BuildContext context) {
    return Expanded(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
                controller: TextEditingController()..text = value,
                decoration: InputDecoration(
                    labelText: label,
                ),
                readOnly: true,
            )
    )
    );
  }
}

class CorrectPosition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text('Atividade 3') ),
        body: Center(
            child: Text('Posição correta'),
        )
    );
  }
}

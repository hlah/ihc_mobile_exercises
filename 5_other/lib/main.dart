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
  static final PROXIMITY_TYPE = 8;
  bool _proxSensorAvailable = false;
  List<double> _proxSensorData = List.filled(1, 0.0);
  StreamSubscription _proxSensorSubscription;

  @override initState() {
    _checkProxSensorStatus();
    super.initState();
  }

  @override dispose() {
    _stopProxSensor();
    super.dispose();
  }

  void _checkProxSensorStatus() async {
    await SensorManager()
        .isSensorAvailable(PROXIMITY_TYPE)
        .then((result){
          setState((){
            print('proximity sensor available: ${result}');
            _proxSensorAvailable = result;
            _startProxSensor();
          });
        });
  }

  Future<void> _startProxSensor() async {
    if(_proxSensorSubscription != null) return;
    if(_proxSensorAvailable) {
      final stream = await SensorManager().sensorUpdates(
          sensorId: PROXIMITY_TYPE,
          interval: Sensors.SENSOR_DELAY_FASTEST,
      );
      _proxSensorSubscription = stream.listen((sensorEvent){
        setState((){
          _proxSensorData = sensorEvent.data;
        });
      });
    }
  }

  void _stopProxSensor() {
    if(_proxSensorSubscription == null) return;
    _proxSensorSubscription.cancel();
    _proxSensorSubscription = null;
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar( title: Text('Atividade 5') ),
          body: Row(
              children: <Widget>[
                ValueField('Proximity:', _proxSensorData[0].toStringAsFixed(2)),
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


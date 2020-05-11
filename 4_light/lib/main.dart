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
  static final LIGHT_TYPE = 5;
  bool _lightSensorAvailable = false;
  List<double> _lightSensorData = List.filled(1, 0.0);
  StreamSubscription _lightSensorSubscription;

  @override initState() {
    _checkLightSensorStatus();
    super.initState();
  }

  @override dispose() {
    _stopLightSensor();
    super.dispose();
  }

  void _checkLightSensorStatus() async {
    await SensorManager()
        .isSensorAvailable(LIGHT_TYPE)
        .then((result){
          setState((){
            print('accelerator sensor available: ${result}');
            _lightSensorAvailable = result;
            _startLightSensor();
          });
        });
  }

  Future<void> _startLightSensor() async {
    if(_lightSensorSubscription != null) return;
    if(_lightSensorAvailable) {
      final stream = await SensorManager().sensorUpdates(
          sensorId: LIGHT_TYPE,
          interval: Sensors.SENSOR_DELAY_FASTEST,
      );
      _lightSensorSubscription = stream.listen((sensorEvent){
        setState((){
          _lightSensorData = sensorEvent.data;
        });
      });
    }
  }

  void _stopLightSensor() {
    if(_lightSensorSubscription == null) return;
    _lightSensorSubscription.cancel();
    _lightSensorSubscription = null;
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar( title: Text('Atividade 4') ),
          body: Row(
              children: <Widget>[
                ValueField('Light:', _lightSensorData[0].toStringAsFixed(2)),
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


import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MaterialApp(
        home: LocationWidget(),
));

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Location _location;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void _enableService() {
    _location.requestService().then((result){
      _serviceEnabled = result;
      if(_serviceEnabled) {
        print('Service enabled');
        _hasPermission();
      } else {
        print('Could not enable service');
      }
    });
  }

  void _hasPermission() {
    _location.hasPermission().then((result){
      _permissionGranted = result;
      if(_permissionGranted == PermissionStatus.granted) {
        print('Location granted');
        _getLocation();
      } else {
        _requestPermission();
      }
    });
  }

  void _requestPermission() {
    _location.requestPermission().then((result){
      _permissionGranted = result;
      if(_permissionGranted == PermissionStatus.granted) {
        print('Location granted');
        _getLocation();
      } else {
        print('Could not get permission');
      }
    });
  }

  void _getLocation() {
    _location.getLocation().then((result){
      setState((){
        _locationData = result;
      });
    });
  }

  @override
  void initState() {
    _location = Location();

    _location.serviceEnabled().then((result){
      _serviceEnabled = result;
      if(_serviceEnabled) {
        print('Service enabled');
        _hasPermission();
      } else {
        _enableService();
      }
    });

    /*
    _serviceEnabled = await _location._serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if(!_serviceEnabled) {
        print('Could not enable location service');
        return;
      }
    }
    print('Location service enabled!');

    _permissionGranted = await _location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted) {
        print('Could not get location permission');
        return;
      }
    }
    print('Location allowed!');
    */

  }

  @override
  Widget build(BuildContext context) {
    Widget locationWidget = Text('Loading coordinates...');
    if( _locationData != null ) {
      locationWidget = Row(
          children: <Widget>[
            ValueField('Longitude:', '${_locationData.longitude}'),
            ValueField('Latitude:', '${_locationData.latitude}'),
          ]
      );
    }

    return Scaffold(
        appBar: AppBar( title: Text('Atividade 6') ),
        body: locationWidget,
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

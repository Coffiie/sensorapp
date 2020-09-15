import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensorapp/theme.dart';
import 'package:sensors/sensors.dart';

class SensorScreen extends StatelessWidget {
  StreamSubscription<AccelerometerEvent> _streamAccelero;
  StreamSubscription<UserAccelerometerEvent> _streamUserAccelero;

  StreamSubscription<GyroscopeEvent> _streamGyro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor App"),
        backgroundColor: themeColors[0],
      ),
      body: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Text('Accelerometer'),
                    onPressed: () => _streamAccelero = accelerometerEvents
                            .listen((AccelerometerEvent event) {
                          print(event);
                        })),
                RaisedButton(
                    child: Text('User Accelerometer'),
                    onPressed: () => _streamUserAccelero =
                            userAccelerometerEvents
                                .listen((UserAccelerometerEvent event) {
                          print(event);
                        })),
                RaisedButton(
                    child: Text('Gyro'),
                    onPressed: () => _streamGyro =
                            gyroscopeEvents.listen((GyroscopeEvent event) {
                          print(event);
                        })),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Text('Pause Acc'),
                    onPressed: () => _streamAccelero.pause()),
                RaisedButton(
                    child: Text('Pause User Acc'),
                    onPressed: () => _streamUserAccelero.pause()),
                RaisedButton(
                    child: Text('Pause Gyro'),
                    onPressed: () => _streamGyro.pause()),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Text('Res Acc'),
                    onPressed: () => _streamAccelero.resume()),
                RaisedButton(
                    child: Text('Res User Acc'),
                    onPressed: () => _streamUserAccelero.resume()),
                RaisedButton(
                    child: Text('Res Gyro'),
                    onPressed: () => _streamGyro.resume()),
              ]),
          Row(
            children: <Widget>[
              RaisedButton(
                  child: Text("get current location"),
                  onPressed: () async {
                    Position position = await Geolocator().getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    print("Altitude:" + position.altitude.toString());
                    print("Latitude:" + position.latitude.toString());
                    print("longitude:" + position.longitude.toString());
                    print("Speed:" + position.speed.toString());
                  })
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensorapp/theme.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  List<double> calculateAngles(
      double accel_value_x, double accel_value_y, double accel_value_z) {
    // Using x y and z from accelerometer, calculate x and y angles
    double result;
    double x2, y2, z2; //24 bit

    // Lets get the deviations from our baseline
    double x_val = accel_value_x - (-0.18);
    double y_val = accel_value_y - (-0.04);
    double z_val = accel_value_z - 4000;

    // Work out the squares
    x2 = (x_val * x_val);
    y2 = (y_val * y_val);
    z2 = (z_val * z_val);

    //X Axis
    result = sqrt(y2 + z2);
    result = x_val / result;
    double accel_angle_x = atan(result);

    //Y Axis
    result = sqrt(x2 + z2);
    result = y_val / result;
    double accel_angle_y = atan(result);

    result = sqrt(y2 + x2);
    result = z_val / result;
    double accel_angle_z = atan(result);

    return [accel_angle_x, accel_angle_y, accel_angle_z];
  }

  double alt = 0;

  double long = 0;

  double lat = 0;

  double speed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor App"),
        backgroundColor: themeColors[0],
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.white])),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: StreamBuilder<UserAccelerometerEvent>(
                  stream: userAccelerometerEvents,
                  builder: (builderCtx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text("ACCELEROMETER DATA",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          Text("Z: ${snapshot.data.z}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text("X: ${snapshot.data.x}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          Text("Y: ${snapshot.data.y}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      );
                    }
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    child: Text("get current location"),
                    onPressed: () async {
                      Position position = await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      setState(() {
                        alt = position.altitude;
                        lat = position.latitude;
                        long = position.longitude;
                        speed = position.speed;
                      });
                    })
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("GPS DATA",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                Text("Altitude: $alt",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Longitude: $long",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Latitude: $lat",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text("Speed: $speed",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            )
          ],
        ),
      ]),
    );
  }
}

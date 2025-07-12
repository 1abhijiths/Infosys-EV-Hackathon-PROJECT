import 'package:flutter/material.dart';
import 'charging_station_screen.dart';

void main() {
  runApp(ChargingStationApp());
}

class ChargingStationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EV Charging Station Finder',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChargingStationHomePage(),
    );
  }
}
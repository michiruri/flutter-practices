import 'package:flutter/material.dart';

class WeatherDetailsComponent extends StatelessWidget {
  const WeatherDetailsComponent({
    super.key,
    required this.temp,
    required this.feelsLike,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.pressure,
  });

  final double temp;
  final double feelsLike;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final int pressure;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'Weather Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Temperature'),
              trailing: Text(' ${temp.toInt()}°'),
            ),
            Divider(),
            ListTile(
              title: Text('Feels Like'),
              trailing: Text(' ${feelsLike.toInt()}°'),
            ),
            Divider(),
            ListTile(
              title: Text('Max Temperature'),
              trailing: Text(' ${maxTemp.toInt()}°'),
            ),
            Divider(),
            ListTile(
              title: Text('Min Temperature'),
              trailing: Text(' ${minTemp.toInt()}°'),
            ),
            Divider(),
            ListTile(title: Text('Humidity'), trailing: Text('$humidity%')),
            Divider(),
            ListTile(title: Text('Pressure'), trailing: Text('$pressure hPa')),
            Divider(),
          ],
        ),
      ),
    );
  }
}

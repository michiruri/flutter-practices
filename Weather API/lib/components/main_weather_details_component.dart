import 'package:flutter/material.dart';

class MainWeatherDetailsComponent extends StatelessWidget {
  const MainWeatherDetailsComponent({
    super.key,
    required this.weatherIcon,
    required this.description,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
  });

  final String weatherIcon;
  final String description;
  final double temp;
  final double maxTemp;
  final double minTemp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(weatherIcon),
        Text(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          description.toUpperCase(),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 96,
                color: Colors.white,
              ),
              ' ${temp.toInt()}°',
            ),
            Positioned(
              bottom: 0,
              child: Text(
                'H:${maxTemp.toInt()}°/L:${minTemp.toInt()}°   ',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade200),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

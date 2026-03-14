import 'dart:convert';

import 'package:capitis_mad2_assignment_5/components/location_details_component.dart';
import 'package:capitis_mad2_assignment_5/components/main_weather_details_component.dart';
import 'package:capitis_mad2_assignment_5/components/weather_details_component.dart';
import 'package:capitis_mad2_assignment_5/screens/searched_weather_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class LocationWeatherDetailsScreen extends StatefulWidget {
  const LocationWeatherDetailsScreen({super.key});

  @override
  State<LocationWeatherDetailsScreen> createState() =>
      _LocationWeatherDetailsScreenState();
}

class _LocationWeatherDetailsScreenState
    extends State<LocationWeatherDetailsScreen> {
  Position? position;
  Placemark? placemark;
  String address = '';
  Map weather = {};
  String weatherIcon = 'https://openweathermap.org/img/wn/01n@4x.png';
  double temp = 0;
  double feelsLike = 0;
  double minTemp = 0;
  double maxTemp = 0;
  String description = '';
  int humidity = 0;
  int pressure = 0;

  Future<bool> checkLocationServicePermission() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      showSnackBarMessage(
        'Location services is disabled. Please enable it in Settings for the app to work.',
      );
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBarMessage(
          'Location permission denied. Please enable it in Settings for the app to work.',
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showSnackBarMessage(
        'Location permission denied. Please enable it in Settings for the app to work.',
      );
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    if (!await checkLocationServicePermission()) {
      return;
    }
    position = await Geolocator.getCurrentPosition();
    getLocationAddress();
    fetchWeatherData();
    setState(() {});
  }

  Future<void> getLocationAddress() async {
    if (position != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude,
          position!.longitude,
        );
        if (placemarks.isNotEmpty) {
          placemark = placemarks.first;
          address =
              '${placemark?.street}, ${placemark?.locality}, ${placemark?.subAdministrativeArea}, ${placemark?.administrativeArea}, ${placemark?.country}';
        }
      } catch (error) {
        showSnackBarMessage('No address information can be found.');
      }
    }
    setState(() {});
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> fetchWeatherData() async {
    String apiKey = '579bf8616854075aae588bf8cf72fda4';
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position?.latitude}&lon=${position?.longitude}&appid=$apiKey',
    );
    Response response = await get(url);
    if (response.statusCode == 200) {
      weather = jsonDecode(response.body);
      weatherIcon =
          'https://openweathermap.org/img/wn/${weather['weather'][0]['icon']}@4x.png';
      initWeatherVariables();
    }
    setState(() {});
  }

  void initWeatherVariables() {
    convertKelvinToCelcius();
    description = weather['weather'][0]['description'];
    humidity = weather['main']['humidity'];
    pressure = weather['main']['pressure'];
  }

  void convertKelvinToCelcius() {
    temp = weather['main']['temp'] - 273.15;
    feelsLike = weather['main']['feels_like'] - 273.15;
    minTemp = weather['main']['temp_min'] - 273.15;
    maxTemp = weather['main']['temp_max'] - 273.15;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Icon(Icons.location_on),
          title: Text(
            address,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          trailing: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            child: IconButton(
              onPressed:
                  () => Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => SearchedWeatherDetailsScreen(),
                    ),
                  ),
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MainWeatherDetailsComponent(
                weatherIcon: weatherIcon,
                description: description,
                temp: temp,
                maxTemp: maxTemp,
                minTemp: minTemp,
              ),
              SizedBox(height: 80),
              WeatherDetailsComponent(
                temp: temp,
                feelsLike: feelsLike,
                maxTemp: maxTemp,
                minTemp: minTemp,
                humidity: humidity,
                pressure: pressure,
              ),
              LocationDetailsComponent(position: position),
            ],
          ),
        ),
      ),
    );
  }
}

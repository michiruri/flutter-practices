import 'dart:convert';

import 'package:capitis_mad2_assignment_5/components/main_weather_details_component.dart';
import 'package:capitis_mad2_assignment_5/components/weather_details_component.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';

class SearchedWeatherDetailsScreen extends StatefulWidget {
  const SearchedWeatherDetailsScreen({super.key});

  @override
  State<SearchedWeatherDetailsScreen> createState() =>
      _SearchedWeatherDetailsScreenState();
}

class _SearchedWeatherDetailsScreenState
    extends State<SearchedWeatherDetailsScreen> {
  Location? location;
  Placemark? placemark;
  String address = 'No location searched yet.';
  Map weather = {};
  String weatherIcon = 'https://openweathermap.org/img/wn/01n@4x.png';
  double temp = 0;
  double feelsLike = 0;
  double minTemp = 0;
  double maxTemp = 0;
  String description = '';
  int humidity = 0;
  int pressure = 0;

  final addressCtrl = TextEditingController();

  Future<void> getLocationFromUserInput() async {
    if (addressCtrl.text.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(addressCtrl.text);
        if (locations.isNotEmpty) {
          location = locations.first;
          getLocationAddress();
          fetchWeatherData();
        }
      } catch (error) {
        showSnackBarMessage(error.toString());
      }
    }
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> getLocationAddress() async {
    if (location != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location!.latitude,
          location!.longitude,
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

  Future<void> fetchWeatherData() async {
    String apiKey = '579bf8616854075aae588bf8cf72fda4';
    Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${location?.latitude}&lon=${location?.longitude}&appid=$apiKey',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: addressCtrl,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(),
              hintText: 'Search Location',
            ),
            onSubmitted: (value) => getLocationFromUserInput(),
            cursorColor: Colors.grey,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: IconButton(
                onPressed: () => getLocationFromUserInput(),
                icon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.location_on),
                title: Text(
                  address,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherModel {
  final double temperature;
  final String weatherCondition;
  final String weatherIcon;

  WeatherModel({
    required this.temperature,
    required this.weatherCondition,
    required this.weatherIcon,
  });

  factory WeatherModel.fromJSON(Map<String, dynamic> json) {
    int fetchedWeatherCondition = json["weather"][0]["id"];
    String _weatherCondition;
    String _weatherIcon;

    if (fetchedWeatherCondition >= 200 && fetchedWeatherCondition < 300) {
      _weatherCondition = "Thunderstorm";
      _weatherIcon = "weather_storm.json";
    } else if (fetchedWeatherCondition >= 300 &&
        fetchedWeatherCondition < 400) {
      _weatherCondition = "Light Rain";
      _weatherIcon = "weather_rain.json";
    } else if (fetchedWeatherCondition >= 500 &&
        fetchedWeatherCondition < 600) {
      _weatherCondition = "Rain";
      _weatherIcon = "weather_rain.json";
    } else if (fetchedWeatherCondition >= 600 &&
        fetchedWeatherCondition < 700) {
      _weatherCondition = "Snowy";
      _weatherIcon = "weather_snow.json";
    } else if (fetchedWeatherCondition >= 700 &&
        fetchedWeatherCondition < 800) {
      _weatherCondition = "Foggy";
      _weatherIcon = "weather_fog.json";
    } else if (fetchedWeatherCondition == 800) {
      _weatherCondition = "Sunny";
      _weatherIcon = "weather_sun.json";
    } else if (fetchedWeatherCondition > 800) {
      _weatherCondition = "Cloudy";
      _weatherIcon = "weather_cloud.json";
    } else {
      _weatherCondition = "Null";
      _weatherIcon = "assets/weather_sun.json";
    }

    return WeatherModel(
      temperature: json["main"]["temp"].toDouble(),
      weatherCondition: _weatherCondition,
      weatherIcon: _weatherIcon,
    );
  }
}

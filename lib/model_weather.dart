import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weather/weather.dart';

class WeatherModel {
  WeatherFactory weatherFactory = WeatherFactory("b339ff60e5a74e53a3f553077025b0f6", language: Language.ENGLISH);

  Future<double?> fetchTemperature() async {
    Weather response = await weatherFactory.currentWeatherByCityName("Markham");
    double? temperature = response.temperature?.celsius;
    print(temperature);
    return temperature;
  }
}

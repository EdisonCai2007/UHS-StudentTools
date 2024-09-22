import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolfpackapp/models_services/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = "http://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse("$baseUrl?q=$cityName&appid=${dotenv.env['WEATHER_API_KEY']}&units=metric"));
    if (response.statusCode == 200) {
      return WeatherModel.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch weather information!");
    }
  }
}
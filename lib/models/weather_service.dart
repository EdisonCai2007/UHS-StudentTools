import 'dart:convert';

import 'package:wolfpackapp/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String BASEURL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = "b339ff60e5a74e53a3f553077025b0f6";

  Future<WeatherModel> fetchWeather(String cityName) async {
    print("$BASEURL?q=$cityName&appid=$apiKey&units=metric");
    final response = await http.get(Uri.parse("${BASEURL}q=$cityName&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      print(WeatherModel.fromJSON(jsonDecode(response.body)));
      return WeatherModel.fromJSON(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception("Failed to fetch weather");
    }
  }
}
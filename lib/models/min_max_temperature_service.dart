import 'dart:convert';

import 'package:wolfpackapp/models/min_max_temperature_model.dart';
import 'package:http/http.dart' as http;

class MinMaxTemperatureService {
  final String baseUrl = "https://api.open-meteo.com/v1/gem?latitude=43.8581034&longitude=-79.3368891&daily=temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=1";

  Future<MinMaxTemperatureModel> fetchMinMaxTemperature() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return MinMaxTemperatureModel.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch min/max temperature!");
    }
  }
}
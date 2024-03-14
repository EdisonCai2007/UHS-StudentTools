import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wolfpackapp/models/weather_model.dart';
import 'package:wolfpackapp/models/weather_service.dart';

class DailyWeatherOverviewContainer extends StatefulWidget {
  const DailyWeatherOverviewContainer({super.key});

  @override
  State<DailyWeatherOverviewContainer> createState() => _DailyWeatherOverviewContainerState();
}

class _DailyWeatherOverviewContainerState extends State<DailyWeatherOverviewContainer> {
  WeatherService weatherService = WeatherService();
  WeatherModel? weather;

  fetchWeather() async {
    try {
      var weatherResponse = await weatherService.fetchWeather("markham");
      setState(() {
        weather = weatherResponse;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [BoxShadow(blurRadius: 10)],
      ),
      height: 400,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Text("${weather?.temperature.round()}°C")
        ],
      ),
    );
  }
}
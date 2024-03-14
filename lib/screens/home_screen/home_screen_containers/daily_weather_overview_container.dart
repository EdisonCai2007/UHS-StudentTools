import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wolfpackapp/model_weather.dart';

class DailyWeatherOverviewContainer extends StatefulWidget {
  const DailyWeatherOverviewContainer({super.key});

  @override
  State<DailyWeatherOverviewContainer> createState() => _DailyWeatherOverviewContainerState();
}

class _DailyWeatherOverviewContainerState extends State<DailyWeatherOverviewContainer> {
  double temperature = WeatherModel().fetchTemperature() as double;

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
          Text("$temperature"),
        ],
      ),
    );
  }
}
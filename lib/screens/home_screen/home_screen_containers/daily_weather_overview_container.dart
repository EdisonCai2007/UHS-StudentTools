import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wolfpackapp/models/weather_model.dart';
import 'package:wolfpackapp/models/weather_service.dart';

class DailyWeatherOverviewContainer extends StatefulWidget {
  const DailyWeatherOverviewContainer({super.key});

  @override
  State<DailyWeatherOverviewContainer> createState() =>
      _DailyWeatherOverviewContainerState();
}

class _DailyWeatherOverviewContainerState
    extends State<DailyWeatherOverviewContainer> {
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
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 60,
            transformAlignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("${weather?.weatherCondition}",
                  style: GoogleFonts.lato(
                      fontSize: 30, fontWeight: FontWeight.w800)),
            ),
          ),
          Container(
            height: 180,
            transformAlignment: Alignment.center,
            child: Lottie.asset(weather!.weatherIcon,),
          ),
          Text("${weather?.temperature.round()}°C",
              style: GoogleFonts.lato(
                fontSize: 40, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

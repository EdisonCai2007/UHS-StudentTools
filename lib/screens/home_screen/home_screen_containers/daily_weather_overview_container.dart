import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wolfpackapp/models/min_max_temperature_model.dart';
import 'package:wolfpackapp/models/min_max_temperature_service.dart';
import 'package:wolfpackapp/models/weather_model.dart';
import 'package:wolfpackapp/models/weather_service.dart';

class DailyWeatherOverviewContainer extends StatefulWidget {
  const DailyWeatherOverviewContainer({super.key});

  @override
  State<DailyWeatherOverviewContainer> createState() =>
      _DailyWeatherOverviewContainerState();
}

class _DailyWeatherOverviewContainerState extends State<DailyWeatherOverviewContainer> {
  final WeatherService weatherService = WeatherService();
  WeatherModel? weather;

  MinMaxTemperatureService minMaxTemperatureService =
      MinMaxTemperatureService();
  MinMaxTemperatureModel? minMaxTemperature;

  fetchWeather() async {
    try {
      final weatherResponse = await weatherService.fetchWeather("markham");
      setState(() {
        weather = weatherResponse;
      });
    } catch (e) {
      print(e);
    }
  }

  fetchMinMaxTemperature() async {
    try {
      var minMaxTemperatureResponse = await minMaxTemperatureService.fetchMinMaxTemperature();
      setState(() {
        minMaxTemperature = minMaxTemperatureResponse;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
    fetchMinMaxTemperature();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [BoxShadow(blurRadius: 10)],
      ),
      height: 370,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top:20, left: 20,right: 20),
      child: weather == null ? const CircularProgressIndicator(

      ) :
      Column(
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
            child: Lottie.asset("weather_cloud.json",
                delegates: LottieDelegates(values: [
                  ValueDelegate.dropShadow(['**'],
                      value: DropShadow(
                        color: Theme.of(context).shadowColor,
                        distance: 0,
                        direction: 0,
                        radius: 5,
                      ))
                ])),
          ),
          Text("${weather?.temperature.round()}°C",
              style:
                  GoogleFonts.lato(fontSize: 40, fontWeight: FontWeight.w800)),
          const SizedBox(height: 15),
          Row(
            children: [
              Text("${minMaxTemperature?.minTemperature.round()}",
                  style: GoogleFonts.lato(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  width: 300,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.red],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      thumbColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(
                          elevation: 5, pressedElevation: 5),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    child: Slider(
                      min: minMaxTemperature?.minTemperature.round().toDouble() ?? 0,
                      max: minMaxTemperature?.maxTemperature.round().toDouble() ?? 100,
                      value: weather?.temperature ?? 0,
                      onChanged: (value) => weather!.temperature,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text("${minMaxTemperature?.maxTemperature.round()}",
                  style: GoogleFonts.lato(
                      fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

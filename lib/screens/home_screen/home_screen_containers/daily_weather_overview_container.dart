import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wolfpackapp/models_services/min_max_temperature_model.dart';
import 'package:wolfpackapp/models_services/min_max_temperature_service.dart';
import 'package:wolfpackapp/models_services/weather_model.dart';
import 'package:wolfpackapp/models_services/weather_service.dart';

class DailyWeatherOverviewContainer extends StatefulWidget {
  const DailyWeatherOverviewContainer({super.key});

  @override
  State<DailyWeatherOverviewContainer> createState() =>
      _DailyWeatherOverviewContainerState();
}

class _DailyWeatherOverviewContainerState extends State<DailyWeatherOverviewContainer> {
  final WeatherService weatherService = WeatherService();
  WeatherModel? weather;

  MinMaxTemperatureService minMaxTemperatureService = MinMaxTemperatureService();
  MinMaxTemperatureModel? minMaxTemperature;

  fetchWeather() async {
    try {
      final weatherResponse = await weatherService.fetchWeather("Markham");
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
      print('Unable to fetch min/max temperature!');
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
        boxShadow: const [BoxShadow(blurRadius: 5)],
      ),
      height: 300,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top:20, left: 20,right: 20),
      child: (weather == null || minMaxTemperature == null) ? const Center(
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      ) :
      Column(
        children: [
          Container(
            height: 60,
            transformAlignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.none,
              child: Text("${weather?.weatherCondition}",
                  style: GoogleFonts.roboto(
                      fontSize: 30, fontWeight: FontWeight.w800)),
            ),
          ),
          Container(
            height: 100,
            transformAlignment: Alignment.center,
            child: Lottie.asset(weather!.weatherIcon,
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
          FittedBox(
            fit: BoxFit.contain,
            child: Text(weather!.temperature.round() > (minMaxTemperature?.maxTemperature.round() ?? 100) ?
            "${minMaxTemperature?.maxTemperature.round()}°C" :
            weather!.temperature.round() < (minMaxTemperature?.minTemperature.round() ?? 0) ?
            "${minMaxTemperature?.minTemperature.round()}°C" :
            "${weather!.temperature.round()}°C",
                  style:
                      GoogleFonts.roboto(fontSize: 40, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text("${minMaxTemperature?.minTemperature.round()}",
                  style: GoogleFonts.roboto(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 10,
                  padding: EdgeInsets.zero,
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
                          elevation: 5, pressedElevation: 5, enabledThumbRadius: 10),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Slider(
                        min: minMaxTemperature?.minTemperature.roundToDouble() ?? 0,
                        max: minMaxTemperature?.maxTemperature.roundToDouble() ?? 100,
                        value: weather!.temperature.round() > (minMaxTemperature?.maxTemperature.round() ?? 100) ?
                          minMaxTemperature!.maxTemperature.roundToDouble() :
                          weather!.temperature.round() < (minMaxTemperature?.minTemperature.round() ?? 0) ?
                          minMaxTemperature!.minTemperature.roundToDouble() :
                          weather!.temperature.roundToDouble(),
                        onChanged: (value) => weather!.temperature.roundToDouble(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text("${minMaxTemperature?.maxTemperature.round()}",
                  style: GoogleFonts.roboto(
                      fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

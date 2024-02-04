import 'package:flutter/material.dart';

class DailyWeatherOverviewContainer extends Container {
  DailyWeatherOverviewContainer({super.key});

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
    );
  }
}
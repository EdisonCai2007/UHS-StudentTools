import 'package:flutter/material.dart';

class ScheduleOverviewContainer extends Container{
  ScheduleOverviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        boxShadow: const [
          BoxShadow(blurRadius: 10)
        ],
      ),
      height: 300,
      margin: const EdgeInsets.only(top: 50, left: 30, right: 30,),
      padding: const EdgeInsets.all(50),
    );
  }
}
import 'package:flutter/material.dart';

class TeachAssistOverviewContainer extends Container {
  TeachAssistOverviewContainer({super.key});

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
      padding: const EdgeInsets.all(50),
    );
  }
}

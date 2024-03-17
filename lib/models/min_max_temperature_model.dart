class MinMaxTemperatureModel {
  final double minTemperature;
  final double maxTemperature;

  MinMaxTemperatureModel({
    required this.minTemperature,
    required this.maxTemperature
  });

  factory MinMaxTemperatureModel.fromJSON(Map<String, dynamic> json) {
    return MinMaxTemperatureModel(
      minTemperature: json["daily"]["temperature_2m_min"][0],
      maxTemperature: json["daily"]["temperature_2m_max"][0]
    );
  }
}

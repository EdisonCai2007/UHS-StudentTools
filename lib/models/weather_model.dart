
class WeatherModel {
  final double temperature;
  final String weatherCondition;

  WeatherModel({
    required this.temperature,
    required this.weatherCondition,
  });

  factory WeatherModel.fromJSON(Map<String, dynamic> json) {
    return WeatherModel(
        temperature: json["main"]["temp"].toDouble(),
        weatherCondition: json["weather"][0]["main"],
    );
  }
}

class WeatherModel {
  final double temperature;
  final String weatherCondition;
  final String weatherIcon;

  WeatherModel({
    required this.temperature,
    required this.weatherCondition,
    required this.weatherIcon,
  });

  factory WeatherModel.fromJSON(Map<String, dynamic> json) {
    int fetchedWeatherCondition = json["weather"][0]["id"];
    String weatherCondition;
    String weatherIcon;

    if (fetchedWeatherCondition >= 200 && fetchedWeatherCondition < 300) {
      weatherCondition = "Thunderstorm";
      weatherIcon = "assets/weather_storm.json";
    } else if (fetchedWeatherCondition >= 300 && fetchedWeatherCondition < 400) {
      weatherCondition = "Light Rain";
      weatherIcon = "assets/weather_rain.json";
    } else if (fetchedWeatherCondition >= 500 && fetchedWeatherCondition < 600) {
      weatherCondition = "Rain";
      weatherIcon = "assets/weather_rain.json";
    } else if (fetchedWeatherCondition >= 600 && fetchedWeatherCondition < 700) {
      weatherCondition = "Snowy";
      weatherIcon = "assets/weather_snow.json";
    } else if (fetchedWeatherCondition >= 700 && fetchedWeatherCondition < 800) {
      weatherCondition = "Foggy";
      weatherIcon = "assets/weather_fog.json";
    } else if (fetchedWeatherCondition == 800) {
      weatherCondition = "Sunny";
      weatherIcon = "assets/weather_sun.json";
    } else if (fetchedWeatherCondition > 800) {
      weatherCondition = "Cloudy";
      weatherIcon = "assets/weather_cloud.json";
    } else {
      weatherCondition = "Null";
      weatherIcon = "assets/weather_cloud.json";
    }

    return WeatherModel(
      temperature: json["main"]["temp"].toDouble(),
      weatherCondition: weatherCondition,
      weatherIcon: weatherIcon,
    );
  }
}

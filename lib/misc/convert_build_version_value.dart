class ConvertBuildVersionValue {
  static double toValue(String str) {
    var strValues = str.split('.');

    var convertedVersionValue =
        double.parse(strValues[0]) * 10000 +
        double.parse(strValues[1]) * 100 +
        double.parse(strValues[2]) +
        double.parse(strValues[3]) / 10000
    ;

    return convertedVersionValue;
  }
}
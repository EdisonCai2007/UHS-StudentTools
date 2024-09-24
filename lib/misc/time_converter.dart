class TimeConverter {
  static String get12Format(String timeIn24Format) {
    if (timeIn24Format == '') {
      return '';
    }

    late String meridiem;

    int firstColonIndex = timeIn24Format.indexOf(':');
    int hours = int.parse(timeIn24Format.substring(0, firstColonIndex));

    if (hours > 11 && hours < 24) {
      meridiem = 'PM';
    } else {
      meridiem = 'AM';
    }

    if (hours > 12) {
      hours -= 12;
    }

    return '$hours${timeIn24Format.substring(firstColonIndex, timeIn24Format.length - 3)} $meridiem';
  }
}
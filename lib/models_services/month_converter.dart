class MonthConverter {
  static String? getMonthStr(int numMonth) {
    switch (numMonth) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
    }

    return null;
  }

  static int? getMonthNum(String strMonth) {
    switch (strMonth) {
      case 'January' || 'Jan':
        return 1;
      case 'February' || 'Feb':
        return 2;
      case 'March' || 'Mar':
        return 3;
      case 'April' || 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'June' || 'Jun':
        return 6;
      case 'July' || 'Jul':
        return 7;
      case 'August' || 'Aug':
        return 8;
      case 'September' || 'Sep' || 'Sept':
        return 9;
      case 'October' || 'Oct':
        return 10;
      case 'November' || 'Nov':
        return 11;
      case 'December' || 'Dec':
        return 12;
    }

    return null;
  }
}
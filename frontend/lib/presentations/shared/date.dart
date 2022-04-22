
class Date {
  static const _kMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static const _kDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Return the name of the month for the given month number (1-12).
  static getMonthName(int month) {
    return _kMonthNames[month - 1];
  }

  /// Return the name of the day for the given weekday number (1-7).
  static getDayName(int day) {
    return _kDayNames[day - 1];
  }
}
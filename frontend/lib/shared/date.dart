
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
  static String getMonthName(int month) {
    return _kMonthNames[month - 1];
  }

  /// Return the name of the day for the given weekday number (1-7).
  static String getDayName(int day) {
    return _kDayNames[day - 1];
  }

  /// Return true if the given [DateTime] have the same day, month and year.
  static bool isTheSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Return true if the given [DateTime] have the same month and year.
  static bool isTheSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month;
  }

  /// Return true if the given [DateTime] have the same year.
  static bool isTheSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }
}
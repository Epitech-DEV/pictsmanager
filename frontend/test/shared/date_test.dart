
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/date.dart';


void main() {
  group("Testing [Date.getDayName] method", () {
    test("The first day is Monday and it's index is 1", () {
      expect(Date.getDayName(1), 'Monday');
    });

    test("The last day is Sunday and it's index is 7", () {
      expect(Date.getDayName(7), 'Sunday');
    });
    test('The following date : 2022-04-22 12:13:14Z should return Friday for the day', () {
      DateTime date = DateTime.parse('2022-04-22 12:13:14Z');
      expect(Date.getDayName(date.weekday), 'Friday');
    });
  });

  group("Testing [Date.getMonthName] method", () {
    test("The first month is January and it's index is 1", () {
      expect(Date.getMonthName(1), 'January');
    });

    test("The last month is December and it's index is 12", () {
      expect(Date.getMonthName(12), 'December');
    });

    test('The following date : 2022-04-22 12:13:14Z should return April for the month', () {
      DateTime date = DateTime.parse('2022-04-22 12:13:14Z');
      expect(Date.getMonthName(date.month), 'April');
    });
  });

  group("Testing [Date.isTheSameDay] method", () {
    test('Dates should have the same day if they have the same year, month, day, hour, minute and seconds', () {
      DateTime date1 = DateTime.parse('2022-04-22 12:13:14Z');
      DateTime date2 = DateTime.parse('2022-04-22 12:13:14Z');
      expect(Date.isTheSameDay(date1, date2), true);
    });

    test('Dates should have the same day if they have, at least, the same year, month and day', () {
      DateTime date1 = DateTime.parse('2022-04-22 09:02:36Z');
      DateTime date2 = DateTime.parse('2022-04-22 12:13:14Z');
      expect(Date.isTheSameDay(date1, date2), true);
    });
  });

  group("Testing [Date.isTheSameMonth] method", () {
    test('Dates should have the same month if they have the same year, month, day, hour, minute and seconds', () {
      DateTime date1 = DateTime.parse('2022-04-22 12:13:14Z');
      DateTime date2 = DateTime.parse('2022-04-22 12:13:14Z');
      expect(Date.isTheSameMonth(date1, date2), true);
    });

    test('Dates should have the same day if they have, at least, the same year and month', () {
      DateTime date1 = DateTime.parse('2022-04-22 09:02:36Z');
      DateTime date2 = DateTime.parse('2022-04-12 12:13:14Z');
      expect(Date.isTheSameMonth(date1, date2), true);
    });
  });
}
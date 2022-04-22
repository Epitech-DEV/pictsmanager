
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/presentations/shared/date.dart';


void main() {
  test("The first month is January and it's index is 1", () {
    expect(Date.getMonthName(1), 'January');
  });

  test("The last month is December and it's index is 12", () {
    expect(Date.getMonthName(12), 'December');
  });

  test("The first day is Monday and it's index is 1", () {
    expect(Date.getDayName(1), 'Monday');
  });

  test("The last day is Sunday and it's index is 7", () {
    expect(Date.getDayName(7), 'Sunday');
  });

  test('The following date : 2022-04-22 12:13:14Z should return April for the month', () {
    DateTime date = DateTime.parse('2022-04-22 12:13:14Z');
    expect(Date.getMonthName(date.month), 'April');
  });

  test('The following date : 2022-04-22 12:13:14Z should return Friday for the day', () {
    DateTime date = DateTime.parse('2022-04-22 12:13:14Z');
    expect(Date.getDayName(date.weekday), 'Friday');
  });
}
import 'package:flutter/material.dart';

class BookedDates {
  final String roomId;
  final List<DateTimeRange> dates;

  BookedDates({
    required this.roomId,
    required this.dates,
  });

  bool isAvailable(DateTimeRange startdate, DateTimeRange enddate) {
    for (var date in dates) {
      if (date.start.isBefore(enddate.end) &&
          date.end.isAfter(startdate.start)) {
        return false;
      }
    }
    return true;
  }
}

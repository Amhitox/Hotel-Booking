import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  static final DateFormat timeFormatter = DateFormat('HH:mm');

  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }

  static String formatTime(DateTime date) {
    return timeFormatter.format(date);
  }
}

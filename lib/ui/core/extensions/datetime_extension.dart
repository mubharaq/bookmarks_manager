import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {
  DateTime get _value => this?.toLocal() ?? DateTime.now();

  String date() => DateFormat('MMMM d, yyyy').format(_value);

  String dateHeader() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(_value.year, _value.month, _value.day);

    final formatted = DateFormat('d MMMM, yyyy').format(_value);

    if (dateOnly == today) {
      return 'Today, $formatted';
    } else if (dateOnly == yesterday) {
      return 'Yesterday, $formatted';
    }
    return formatted;
  }

  String timeOnly() => DateFormat('h:mma').format(_value);

  String getTimeBasedGreeting() {
    final hour = _value.hour;

    return hour < 12
        ? 'Good morning'
        : hour < 18
        ? 'Good afternoon'
        : 'Good evening';
  }
}

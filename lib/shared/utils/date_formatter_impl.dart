// lib/shared/utils/date_formatter_impl.dart

import 'package:intl/intl.dart';
import 'date_formatter.dart';

class DateFormatterImpl implements IDateFormatter {
  const DateFormatterImpl();

  @override
  String format(DateTime date, {String pattern = 'yyyy/MM/dd'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  @override
  int toUnixTimestamp(DateTime date) {
    return date.toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  DateFormatterImpl get formatter => this; // 他APIサービスで再利用するために公開
}

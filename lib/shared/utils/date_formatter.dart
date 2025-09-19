// lib/shared/utils/date_formatter.dart

abstract class IDateFormatter {
  /// DateTimeを指定のパターンで文字列に変換
  String format(DateTime date, {String pattern});

  /// UNIXタイムスタンプ (UTC, 秒単位)
  int toUnixTimestamp(DateTime date);
}

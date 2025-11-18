import 'package:intl/intl.dart';

DateTime? parseFlexibleDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;

  // 共通前処理：トリム
  String s = dateStr.trim();

  // --- 1) ISO8601（標準）ならそのまま ---
  try {
    return DateTime.parse(s);
  } catch (_) {}

  // --- 2) スラッシュをハイフンに変換して再チャレンジ ---
  try {
    final fixed = s.replaceAll('/', '-');
    return DateTime.parse(fixed);
  } catch (_) {}

  // --- 3) intl パッケージで複数形式を試す ---
  // 必要に応じて種類を増やせる
  final formats = [
    DateFormat('yyyy/MM/dd HH:mm:ss'),
    DateFormat('yyyy-MM-dd HH:mm:ss'),
    DateFormat('yyyy/MM/dd'),
    DateFormat('yyyy-MM-dd'),
  ];

  for (final f in formats) {
    try {
      return f.parse(s);
    } catch (_) {}
  }

  return null; // どうしても解析できない場合
}

// lib/shared/utils/date_formatter_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'date_formatter.dart';
import 'date_formatter_impl.dart';

final dateFormatterProvider = Provider<IDateFormatter>((ref) {
  return const DateFormatterImpl();
});

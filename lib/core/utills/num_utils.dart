import 'package:intl/intl.dart';

String? formatAmount(num? amount) {
  if (amount == null) return null;
  final formatter = NumberFormat('#,##0', 'en_IN'); // For Indian format
  return formatter.format(amount);
}

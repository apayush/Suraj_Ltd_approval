import 'package:intl/intl.dart';

String? formatAmount(num? amount) {
  try {
    if (amount == null) return null;
    final formatter = NumberFormat.decimalPattern('en_IN'); // correct
    return formatter.format(amount);
  } catch (e) {
    return null;
  }
}

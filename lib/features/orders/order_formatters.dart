import 'package:intl/intl.dart';

final _pkrFormat = NumberFormat.decimalPattern('en_PK');

String formatPaisa(int paisa) => 'PKR ${_pkrFormat.format(paisa ~/ 100)}';

int? parseRupeesToPaisa(String value) {
  final normalized = value.trim().replaceAll(',', '');
  final rupees = int.tryParse(normalized);
  return rupees == null ? null : rupees * 100;
}

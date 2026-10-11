import 'dart:typed_data';

class BackupValidationResult {
  const BackupValidationResult({
    required this.databaseBytes,
    required this.sourceSchemaVersion,
    required this.createdAt,
  });

  final Uint8List databaseBytes;
  final int sourceSchemaVersion;
  final DateTime createdAt;
}

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;

  @override
  String toString() => message;
}

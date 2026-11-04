class SchoolApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic> errors;

  const SchoolApiException(
    this.message, {
    this.statusCode,
    this.errors = const {},
  });

  @override
  String toString() => message;
}


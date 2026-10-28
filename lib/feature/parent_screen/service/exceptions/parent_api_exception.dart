// Custom API Exception
class ParentApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic> errors;

  const ParentApiException(
    this.message, {
    this.statusCode,
    this.errors = const {},
  });

  @override
  String toString() => message;
}

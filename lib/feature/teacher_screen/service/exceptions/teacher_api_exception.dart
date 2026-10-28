//  teacher api exception
class TeacherApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic> errors;

  const TeacherApiException(
    this.message, {
    this.statusCode,
    this.errors = const {},
  });

  @override
  String toString() => message;
}

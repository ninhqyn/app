class FavoriteResponse {
  final bool success;
  final String? message;
  final int? statusCode;

  FavoriteResponse({
    required this.success,
    this.message,
    this.statusCode,
  });
}
class TokenModel {
  final String accessToken;
  final String refreshToken;

  TokenModel(this.accessToken, this.refreshToken);

  // From JSON to TokenModel
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      json['accessToken'] ?? '',  // Use an empty string if 'tokeValue' is null
      json['refreshToken'] ?? '', // Use an empty string if 'refreshToken' is null
    );
  }

  // From TokenModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
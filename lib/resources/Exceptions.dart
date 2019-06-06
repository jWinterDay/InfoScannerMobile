import 'dart:convert';


class AuthException implements Exception {
  final int statusCode;
  final String message;

  //constructor
  AuthException({this.statusCode, this.message});

  factory AuthException.fromRawJson(String str) => AuthException.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory AuthException.fromJson(Map<String, dynamic> json)
    => new AuthException(
      statusCode: json["statusCode"],
      message: json["message"],
    );
  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
  };

  String toString() => '$statusCode, $message';
}
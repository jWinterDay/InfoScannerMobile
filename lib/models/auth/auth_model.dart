import 'dart:convert';
import 'package:flutter/foundation.dart';


class AuthModelState {
  AuthModel authModel;
  bool isLoading;
  Object error;

  //constructor
  AuthModelState({
    @required this.authModel,
    @required this.isLoading,
    @required this.error,
  });

  factory AuthModelState.initial() => AuthModelState(
    authModel: null,
    isLoading: false,
    error: null,
  );

  factory AuthModelState.loading() => AuthModelState(
    authModel: null,
    isLoading: true,
    error: null,
  );

  factory AuthModelState.error(Object error) => AuthModelState(
    authModel: null,
    isLoading: false,
    error: error,
  );

  AuthModelState copyWith({
    AuthModel authModel,
    bool isLoading,
    Object error
  }) =>
      AuthModelState(
        authModel: authModel ?? this.authModel,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );


  @override
  String toString() => '(authModel: $authModel, isLoading: $isLoading, error: $error)';
}

class AuthModel {
  String email;
  String password;

  //constructor
  AuthModel({
    this.email,
    this.password,
  });

  factory AuthModel.fromRawJson(String str) => AuthModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory AuthModel.fromJson(Map<String, dynamic> json) => new AuthModel(
    email: json["email"],
    password: json["password"],
  );
  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };

  @override
  String toString() => 'email: $email, password: $password';
}

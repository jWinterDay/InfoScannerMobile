import 'dart:convert';
import 'package:quiver/core.dart' as quiver;


class LoggedUserInfo {
  int userId;
  String firstName;
  String lastName;
  String email;
  String token;
  String refreshToken;
  List<dynamic> accessGroups;
  Object error;
  bool isLoading = false;

  //constructor
  LoggedUserInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.refreshToken,
    this.token,
    this.accessGroups,
    this.isLoading,
    this.error,
  });

  //constructor
  factory LoggedUserInfo.initial() =>
    LoggedUserInfo(
      isLoading: false,
    );

  //constructor
  factory LoggedUserInfo.loading() => 
    LoggedUserInfo(
      isLoading: true,
    );

  //constructor
  factory LoggedUserInfo.error(Object error) => 
    LoggedUserInfo(
      error: error,
      isLoading: false,
    );

  LoggedUserInfo copyWith({
    int userId,
    String firstName,
    String lastName,
    String email,
    String token,
    String refreshToken,
    List<dynamic> accessGroups,
    bool isLoading = false,
    Object error,
  }) =>
    LoggedUserInfo(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      accessGroups: accessGroups ?? this.accessGroups,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );

  factory LoggedUserInfo.fromRawJson(String str) => LoggedUserInfo.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory LoggedUserInfo.fromJson(Map<String, dynamic> json) => new LoggedUserInfo(
      userId: json["user_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      refreshToken: json["refresh_token"],
      token: json["token"],
      accessGroups: json["access_groups"],
      error: json["error"],
      isLoading: json["is_loading"] == null ? false : (json["is_loading"] as bool),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "refresh_token": refreshToken,
    "token": token,
    "access_groups": accessGroups,
    "error": error,
    "is_loading": isLoading,
  };

  bool operator == (o) =>
    o is LoggedUserInfo
    && userId == o.userId
    && email == o.email;

  int get hashCode => quiver.hash2(userId.hashCode, email.hashCode);

  @override
  String toString() {
    return
    """
    (
      userId: $userId,
      firstName: $firstName,
      lastName: $lastName,
      email: $email,
      refreshToken: $refreshToken,
      token: $token,
      accessGroups: $accessGroups,
      isLoading: $isLoading,
      error: $error
    )
    """;
  }
}
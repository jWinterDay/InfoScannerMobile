import 'dart:convert';
import 'package:quiver/core.dart' as quiver;

LoggedUserInfo loggedUserFromJson(String str) {
    final jsonData = json.decode(str);
    return LoggedUserInfo.fromMap(jsonData);
}

String loggedUserToJson(LoggedUserInfo data) {
    final dyn = data.toMap();
    return json.encode(dyn);
}

class LoggedUserInfo {
  int userId;
  String firstName;
  String lastName;
  int beginDate;//UTC
  int endDate;//UTC
  String email;
  String password;
  String refreshToken;

  //constructor
  LoggedUserInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.beginDate,
    this.endDate,
    this.email,
    this.password,
    this.refreshToken,
  });

  factory LoggedUserInfo.fromMap(Map<String, dynamic> json) => new LoggedUserInfo(
      userId: json["user_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      beginDate: json["begin_date"],
      endDate: json["end_date"],
      email: json["email"],
      password: json["password"],
      refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "begin_date": beginDate,
    "end_date": endDate,
    "email": email,
    "password": password,
    "refresh_token": refreshToken,
  };

  bool operator == (o) =>
    o is LoggedUserInfo 
    && firstName == o.firstName
    && lastName == o.lastName
    && email == o.email;

  int get hashCode => quiver.hash3(firstName.hashCode, lastName.hashCode, email.hashCode);

  @override
  String toString() {
    return
    """
    (
      userId: $userId,
      firstName: $firstName,
      lastName: $lastName,
      beginDate: $beginDate,
      endDate: $endDate,
      email: $email,
      password: $password,
      refreshToken: $refreshToken,
    )
    """;
  }
}
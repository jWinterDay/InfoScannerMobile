import 'dart:convert';
import 'package:quiver/core.dart' as quiver;

LoggedUserInfo loggedUserFromJson(String str) {
  if (str == null)
    return null;

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
  String fullName;
  String email;
  String token;
  String refreshToken;
  String message;
  List<dynamic> roles;

  bool _inFetchState = false;
  bool get inFetchState => _inFetchState;
  set inFetchState(state) => _inFetchState = state;

  //constructor
  LoggedUserInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.refreshToken,
    this.token,
    this.message,
    this.roles,
  });

  //constructor
  LoggedUserInfo.inprogress() {
    this.inFetchState = true;
  }

  //state
  //userConnectState get state => _state;
  //set state(state) => _state = state;

  factory LoggedUserInfo.fromMap(Map<String, dynamic> json) => new LoggedUserInfo(
      userId: json["user_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      fullName: json["full_name"],
      email: json["email"],
      refreshToken: json["refresh_token"],
      token: json["token"],
      message: json["message"],
      roles: json["roles"],//(json["roles"] as List<dynamic>).cast<String>()//["roles"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "email": email,
    "refresh_token": refreshToken,
    "token": token,
    "message": message,
    "roles": roles,
    //"in_fetch_state": inFetchState
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
      fullName: $fullName,
      email: $email,
      refreshToken: $refreshToken,
      token: $token,
      message: $message,
      roles: $roles,
      inFetchState: $inFetchState
    )
    """;
  }
}
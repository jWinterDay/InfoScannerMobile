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
  String email;
  String token;
  String refreshToken;
  List<dynamic> accessGroups;
  int serverMinusCurTimeSec;

  Exception _exception;
  Exception get exception => _exception;
  set exception(exc) => _exception = exc;

  bool _inFetchState = false;
  bool get inFetchState => _inFetchState;
  set inFetchState(state) => _inFetchState = state;

  //constructor
  LoggedUserInfo({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.refreshToken,
    this.token,
    this.accessGroups,
    this.serverMinusCurTimeSec,
  });

  //constructor
  LoggedUserInfo.inprogress() {
    this.inFetchState = true;
  }

  factory LoggedUserInfo.fromMap(Map<String, dynamic> json) => new LoggedUserInfo(
      userId: json["user_id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      refreshToken: json["refresh_token"],
      token: json["token"],
      accessGroups: json["access_groups"],
      serverMinusCurTimeSec: json["server_minus_cur_time_sec"],
  );

  Map<String, dynamic> toMap() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "refresh_token": refreshToken,
    "token": token,
    "access_groups": accessGroups,
    "server_minus_cur_time_sec": serverMinusCurTimeSec,
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
      inFetchState: $inFetchState,
      serverMinusCurTimeSec : $serverMinusCurTimeSec
    )
    """;
  }
}
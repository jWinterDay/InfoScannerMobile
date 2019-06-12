class WsMessage {
  Object message;

  //constructor
  WsMessage({this.message});

  WsMessage copyWith({
    Object message
  }) =>
    WsMessage(
      message: message ?? this.message,
    );

  @override
  String toString() => '$message';
}
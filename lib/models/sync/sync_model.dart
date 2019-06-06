class SyncModel {
  String message;

  bool _inFetchState = false;
  bool get inFetchState => _inFetchState;
  set inFetchState(state) => _inFetchState = state;

  //constructor
  SyncModel({this.message});

  //constructor
  SyncModel.inprogress({this.message}) {
    this.inFetchState = true;
  }

  @override
  String toString() {
    return
    """
    (
      message: $message,
      inFetchState: $inFetchState
    )
    """;
  }
}
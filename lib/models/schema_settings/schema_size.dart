import 'dart:convert';

class SchemaSizeState {
  final bool isLoading;
  final Object error;
  final SizeParam sizeParam;

  //constructor
  SchemaSizeState({
    this.isLoading,
    this.error,
    this.sizeParam,
  });

  SchemaSizeState copyWith({
    final bool isLoading,
    final Object error,
    final SizeParam sizeParam,
  }) =>
    SchemaSizeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sizeParam: sizeParam ?? this.sizeParam,
    );

  factory SchemaSizeState.fromRawJson(String str) => SchemaSizeState.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory SchemaSizeState.fromJson(Map<String, dynamic> json) => new SchemaSizeState(
    isLoading: json["is_loading"],
    error: json["error"],
    sizeParam: SizeParam.fromJson(json["size_param"]),
  );
  Map<String, dynamic> toJson() => {
    "is_loading": isLoading,
    "error": error,
    "size_param": sizeParam.toJson(),
  };

  @override
  String toString() => '(isLoading: $isLoading, error: $error, sizeParam: $sizeParam)';
}

class SizeParam {
  final int width;
  final int height;

  //constructor
  SizeParam({
    this.width,
    this.height,
  });

  SizeParam copyWith({
    final int width,
    final int height,
  }) =>
    SizeParam(
      width: width ?? this.width,
      height: height ?? this.height,
    );

  factory SizeParam.fromRawJson(String str) => SizeParam.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SizeParam.fromJson(Map<String, dynamic> json) => new SizeParam(
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
  };

  @override
  String toString() => '(width: $width, height: $height)';
}

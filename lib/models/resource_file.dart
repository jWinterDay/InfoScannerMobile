import 'dart:convert';

ResourceFile resourceFileFromJson(String str) {
  final jsonData = json.decode(str);
  return ResourceFile.fromJson(jsonData);
}

String resourceFileToJson(ResourceFile data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ResourceFile {
  double algTimeSec;
  String calculateMethod;
  int compressValue;
  String convertedImageData64;
  String imageData64;
  bool isCalculated;
  String originalName;
  int projectId;
  int realHeight;
  int realWidth;
  int resourceFileId;
  int schemaTypeId;
  String unixBeginDate;

  ResourceFile({
    this.algTimeSec,
    this.calculateMethod,
    this.compressValue,
    this.convertedImageData64,
    this.imageData64,
    this.isCalculated,
    this.originalName,
    this.projectId,
    this.realHeight,
    this.realWidth,
    this.resourceFileId,
    this.schemaTypeId,
    this.unixBeginDate,
  });

  factory ResourceFile.fromJson(Map<String, dynamic> json) => new ResourceFile(
    algTimeSec: json["algTimeSec"] == null ? null : json["algTimeSec"].toDouble(),
    calculateMethod: json["calculateMethod"] == null ? null : json["calculateMethod"],
    compressValue: json["compressValue"] == null ? null : json["compressValue"],
    convertedImageData64: json["convertedImageData64"] == null ? null : json["convertedImageData64"],
    imageData64: json["imageData64"] == null ? null : json["imageData64"],
    isCalculated: json["isCalculated"] == null ? null : json["isCalculated"],
    originalName: json["originalName"] == null ? null : json["originalName"],
    projectId: json["projectId"] == null ? null : json["projectId"],
    realHeight: json["realHeight"] == null ? null : json["realHeight"],
    realWidth: json["realWidth"] == null ? null : json["realWidth"],
    resourceFileId: json["resourceFileId"] == null ? null : json["resourceFileId"],
    schemaTypeId: json["schemaTypeId"] == null ? null : json["schemaTypeId"],
    unixBeginDate: json["unixBeginDate"] == null ? null : json["unixBeginDate"],
  );

  Map<String, dynamic> toJson() => {
    "algTimeSec": algTimeSec == null ? null : algTimeSec,
    "calculateMethod": calculateMethod == null ? null : calculateMethod,
    "compressValue": compressValue == null ? null : compressValue,
    "convertedImageData64": convertedImageData64 == null ? null : convertedImageData64,
    "imageData64": imageData64 == null ? null : imageData64,
    "isCalculated": isCalculated == null ? null : isCalculated,
    "originalName": originalName == null ? null : originalName,
    "projectId": projectId == null ? null : projectId,
    "realHeight": realHeight == null ? null : realHeight,
    "realWidth": realWidth == null ? null : realWidth,
    "resourceFileId": resourceFileId == null ? null : resourceFileId,
    "schemaTypeId": schemaTypeId == null ? null : schemaTypeId,
    "unixBeginDate": unixBeginDate == null ? null : unixBeginDate,
  };
}

import 'dart:convert';

ResourceFileData resourceFileDataFromJson(String str) {
  final jsonData = json.decode(str);
  return ResourceFileData.fromJson(jsonData);
}

String resourceFileDataToJson(ResourceFileData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ResourceFileData {
  String coordinates;
  int diyResourceId;
  String imageData;
  int resourceFileDataId;
  int resourceFileId;

  ResourceFileData({
    this.coordinates,
    this.diyResourceId,
    this.imageData,
    this.resourceFileDataId,
    this.resourceFileId,
  });

  factory ResourceFileData.fromJson(Map<String, dynamic> json) => new ResourceFileData(
    coordinates: json["coordinates"] == null ? null : json["coordinates"],
    diyResourceId: json["diyResourceId"] == null ? null : json["diyResourceId"],
    imageData: json["imageData"] == null ? null : json["imageData"],
    resourceFileDataId: json["resourceFileDataId"] == null ? null : json["resourceFileDataId"],
    resourceFileId: json["resourceFileId"] == null ? null : json["resourceFileId"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates == null ? null : coordinates,
    "diyResourceId": diyResourceId == null ? null : diyResourceId,
    "imageData": imageData == null ? null : imageData,
    "resourceFileDataId": resourceFileDataId == null ? null : resourceFileDataId,
    "resourceFileId": resourceFileId == null ? null : resourceFileId,
  };
}

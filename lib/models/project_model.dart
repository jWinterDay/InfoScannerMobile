// To parse this JSON data, do
// final project = projectFromJson(jsonString);

import 'dart:convert';
import 'package:quiver/core.dart' as quiver;
//import 'package:intl/intl.dart';

import 'package:info_scanner_mobile/resources/common.dart';

Project projectFromJson(dynamic json) {
  return Project.fromMap(json);
}

Project projectFromStr(String str) {
  final jsonData = json.decode(str);
  return Project.fromMap(jsonData);
}

String projectToJson(Project data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

//final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

class Project {
  int projectId;

  String name;
  String note;

  int unixBeginDate;//UTC
  int unixEndDate;//UTC
  int isOwnProject;
  
  String projectGuid;
  String deviceGuid;
  int unixSyncDate;
  String syncDeviceGuid;
  
  String lastOperation;
  int unixLastChangeDate;

  //constructor
  Project({
    this.projectId,
    this.name,
    this.unixBeginDate,
    this.unixEndDate,
    this.note,
    this.projectGuid,
    this.deviceGuid,
    this.unixSyncDate,
    this.syncDeviceGuid,
    this.isOwnProject,
    this.lastOperation,
    this.unixLastChangeDate
  });

  factory Project.fromMap(Map<String, dynamic> json) {
    return
      new Project(
        projectId: json["project_id"],
        name: json["name"],
        unixBeginDate: json["unix_begin_date"],
        unixEndDate: json["unix_end_date"],
        note: json["note"],
        projectGuid: json["project_guid"],
        deviceGuid: json["device_guid"],
        unixSyncDate: json["unix_sync_date"],
        syncDeviceGuid: json["sync_device_guid"],
        isOwnProject: Common.boolToInt(json["is_own_project"]),
        lastOperation: json["last_operation"],
        unixLastChangeDate: json["unix_last_change_date"],
      );
  }

  Map<String, dynamic> toMap() => {
    "project_id": projectId,
    "name": name,
    "unix_begin_date": unixBeginDate,
    "unix_end_date": unixEndDate,
    "note": note,
    "project_guid": projectGuid,
    "device_guid": deviceGuid,
    "unix_sync_date": unixSyncDate,
    "sync_device_guid": syncDeviceGuid,
    "is_own_project": isOwnProject,
    "last_operation": lastOperation,
    "unix_last_change_date": unixLastChangeDate
  };

  bool operator == (o) => 
    o is Project 
    && projectGuid == o.projectGuid
    && name == o.name
    && deviceGuid == o.deviceGuid;

  int get hashCode => quiver.hash3(projectGuid.hashCode, name.hashCode, deviceGuid.hashCode);

  @override
  String toString() {
    return
    """
    (
      projectId: $projectId,
      name: $name,
      unixBeginDate: $unixBeginDate,
      unixEndDate: $unixEndDate,
      note: $note,
      projectGuid: $projectGuid,
      deviceGuid: $deviceGuid,
      unixSyncDate: $unixSyncDate,
      syncDeviceGuid: $syncDeviceGuid,
      isOwnProject: $isOwnProject,
      lastOperation: $lastOperation,
      unixLastChangeDate: $unixLastChangeDate
    )
    """;
  }
}
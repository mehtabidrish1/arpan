// To parse this JSON data, do
//
//     final trainingSurveyQuestionModel = trainingSurveyQuestionModelFromJson(jsonString);

import 'dart:convert';

TrainingHandHoldingModuleModel trainingSurveyQuestionModelFromJson(
        String str) =>
    TrainingHandHoldingModuleModel.fromJson(json.decode(str));

String trainingSurveyQuestionModelToJson(TrainingHandHoldingModuleModel data) =>
    json.encode(data.toJson());

class TrainingHandHoldingModuleModel {
  TrainingHandHoldingModuleModel({
    this.pageNumber,
    this.pageSize,
    this.fetchedRecords,
    this.totalRecords,
    this.nextPage,
    this.nextPageAvailabe,
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  int? nextPage;
  bool? nextPageAvailabe;
  List<TrainingHandHoldingModuleData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory TrainingHandHoldingModuleModel.fromJson(Map<String, dynamic> json) =>
      TrainingHandHoldingModuleModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"] == null
            ? null
            : json["NextPageAvailabe"].toString() == 'true' ||
                    json["NextPageAvailabe"].toString() == '1'
                ? true
                : false,
        data: json["Data"] == null
            ? []
            : TrainingHandHoldingModuleData.listFromJson(json['Data']),
        succeeded: json["Succeeded"] == null
            ? null
            : json["Succeeded"].toString() == 'true' ||
                    json["Succeeded"].toString() == '1'
                ? true
                : false,
        errors: json["Errors"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "PageNumber": pageNumber,
        "PageSize": pageSize,
        "FetchedRecords": fetchedRecords,
        "TotalRecords": totalRecords,
        "NextPage": nextPage,
        "NextPageAvailabe": nextPageAvailabe,
        "Data": data == null ? [] : data,
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

class TrainingHandHoldingModuleData {
  TrainingHandHoldingModuleData({
    this.ID,
    this.TypeOfSession,
    this.Module,
  });

  int? ID;
  String? TypeOfSession;
  String? Module;

  factory TrainingHandHoldingModuleData.fromJson(Map<String, dynamic> json) =>
      TrainingHandHoldingModuleData(
        ID: json['ID'],
        TypeOfSession: json['TypeOfSession'],
        Module: json['Module'],
      );

  Map<String, dynamic> toJson() => {
        'ID': ID,
        'TypeOfSession': TypeOfSession,
        'Module': Module,
      };

  static List<TrainingHandHoldingModuleData> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TrainingHandHoldingModuleData>[]
        : json
            .map((value) => TrainingHandHoldingModuleData.fromJson(value))
            .toList();
  }
}

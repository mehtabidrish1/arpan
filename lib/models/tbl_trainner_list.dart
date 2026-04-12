// To parse this JSON data, do
//
//     final trainingSurveyQuestionModel = trainingSurveyQuestionModelFromJson(jsonString);

import 'dart:convert';

TrainerList trainingSurveyQuestionModelFromJson(String str) =>
    TrainerList.fromJson(json.decode(str));

String trainingSurveyQuestionModelToJson(TrainerList data) =>
    json.encode(data.toJson());

class TrainerList {
  TrainerList({
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
  List<TrainerModel>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory TrainerList.fromJson(Map<String, dynamic> json) =>
      TrainerList(
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
            : TrainerModel.listFromJson(json['Data']),
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

class TrainerModel {
  TrainerModel({
    this.empID,
    this.name,
    this.designationID
  });

  String? empID;
  String? name;
  int? designationID;
 
  factory TrainerModel.fromJson(Map<String, dynamic> json) =>
      TrainerModel(
        empID: json['EmpID'],
        name: json['Name'],
        designationID: json['DesignationID']
      );

  Map<String, dynamic> toJson() => {
        'EmpID': empID,
        'Name': name,
        'DesignationID':designationID
      };

  static List<TrainerModel> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TrainerModel>[]
        : json.map((value) => TrainerModel.fromJson(value)).toList();
  }
}

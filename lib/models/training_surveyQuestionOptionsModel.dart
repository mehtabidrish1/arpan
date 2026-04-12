// To parse this JSON data, do
//
//     final trainingSurveyQuestionOptionsModel = trainingSurveyQuestionOptionsModelFromJson(jsonString);

import 'dart:convert';

TrainingSurveyQuestionOptionsModel trainingSurveyQuestionOptionsModelFromJson(
        String str) =>
    TrainingSurveyQuestionOptionsModel.fromJson(json.decode(str));

String trainingSurveyQuestionOptionsModelToJson(
        TrainingSurveyQuestionOptionsModel data) =>
    json.encode(data.toJson());

class TrainingSurveyQuestionOptionsModel {
  TrainingSurveyQuestionOptionsModel({
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
  List<TrainingSurveyQuestionOptionsDatum>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory TrainingSurveyQuestionOptionsModel.fromJson(
          Map<String, dynamic> json) =>
      TrainingSurveyQuestionOptionsModel(
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
            : List<TrainingSurveyQuestionOptionsDatum>.from(json["Data"]!
                .map((x) => TrainingSurveyQuestionOptionsDatum.fromJson(x))),
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
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

class TrainingSurveyQuestionOptionsDatum {
  TrainingSurveyQuestionOptionsDatum({
    this.surveyId,
    this.questionOptionId,
    this.text,
    this.sequence,
    this.questionId,
    this.point,
    this.active,
    this.isOther,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.skippedQuestionIds,
    this.skippedQuestions,
    this.deletedBy,
    this.deletedOn,
    this.textHindi,
    this.textMarathi
  });
 

  int? surveyId;
  int? questionOptionId;
  String? text;
  int? sequence;
  String? questionId;
  int? point;
  int? active;
  int? isOther;
  String? createdOn;
  String? createdBy;
  String? updatedOn;
  String? updatedBy;
  String? skippedQuestionIds;
  String? skippedQuestions;
  String? deletedBy;
  String? deletedOn;
  String? textHindi;
   String? textMarathi;

  factory TrainingSurveyQuestionOptionsDatum.fromJson(
          Map<String, dynamic> json) =>
      TrainingSurveyQuestionOptionsDatum(
        surveyId: json['SurveyId'],
        questionOptionId: json['QuestionOptionId'],
        text: json['Text'],
        textHindi:json['TextHindi'],
        textMarathi:json['TextMarathi'],

        sequence: json['Sequence'],
        questionId: json['QuestionID'],

        point: json['Point'],

        active: 1,
        isOther: json['isOther'] == null
            ? 0
            : json['isOther'] == true
                ? 1
                : json['isOther'] == false
                    ? 0
                    : json['isOther'],
        createdOn: json['CreatedOn'],
        createdBy: json['CreatedBy'],
        updatedOn: json['UpdatedOn'],
        updatedBy: json['UpdatedBy'],
        skippedQuestionIds: json['SkippedQuestionIds'],
        skippedQuestions: json['SkippedQuestions'],
        deletedBy: json['DeletedBy'],
        deletedOn: json['DeletedOn'],
      );

  Map<String, dynamic> toJson() => {
        'SurveyId': surveyId,
        'QuestionOptionId': questionOptionId,
        'Text': text,
        'Sequence': sequence,
        'QuestionID': questionId,
        'Point': point,
        'Active': active,
        'isOther': isOther,
        'CreatedOn': createdOn,
        'CreatedBy': createdBy,
        'UpdatedOn': updatedOn,
        'UpdatedBy': updatedBy,
        'SkippedQuestionIds': skippedQuestionIds,
        'SkippedQuestions': skippedQuestions,
        'DeletedBy': deletedBy,
        'DeletedOn': deletedOn,
        'TextMarathi':textMarathi,
        'TextHindi':textHindi,
      };
}

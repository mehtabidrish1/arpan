// To parse this JSON data, do
//
//     final trainingSurveyQuestionModel = trainingSurveyQuestionModelFromJson(jsonString);

import 'dart:convert';

TrainingSurveyQuestionModel trainingSurveyQuestionModelFromJson(String str) =>
    TrainingSurveyQuestionModel.fromJson(json.decode(str));

String trainingSurveyQuestionModelToJson(TrainingSurveyQuestionModel data) =>
    json.encode(data.toJson());

class TrainingSurveyQuestionModel {
  TrainingSurveyQuestionModel({
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
  List<TrainingSurveyQuestionDatum>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory TrainingSurveyQuestionModel.fromJson(Map<String, dynamic> json) =>
      TrainingSurveyQuestionModel(
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
            : TrainingSurveyQuestionDatum.listFromJson(json['Data']),
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

class TrainingSurveyQuestionDatum {
  TrainingSurveyQuestionDatum({
    this.surveyId,
    this.questionId,
    this.questionBankCategoryId,
    this.questionNo,
    this.question,
    this.questionInstructions,
    this.maxLength,
    this.questionTypeId,
    this.isOther,
    this.isQuestionMandatory,
    this.ratingStartValue,
    this.ratingEndValue,
    this.active,
    this.createdOn,
    this.createdBy,
    this.updatedOn,
    this.updatedBy,
    this.deletedBy,
    this.deletedOn,
    this.isSkipLogic,
    this.isDependent,
    this.condition,
    this.questionHindi,
    this.questionMarathi,
    this.questionInstructionsHindi,
    this.questionInstructionsMarathi
  });

  int? surveyId;
  String? questionId;
  int? questionBankCategoryId;
  String? questionNo;
  String? question;
  String? questionInstructions;
  int? maxLength;
  int? questionTypeId;
  int? isOther;
  int? isQuestionMandatory;
  int? ratingStartValue;
  int? ratingEndValue;
  int? active;
  String? createdOn;
  String? createdBy;
  String? updatedOn;
  String? updatedBy;
  String? deletedBy;
  String? deletedOn;
  int? isSkipLogic;
  int? isDependent;
  String? condition;
  String? questionHindi;
   String? questionMarathi;
    String? questionInstructionsHindi;
     String? questionInstructionsMarathi;

  factory TrainingSurveyQuestionDatum.fromJson(Map<String, dynamic> json) =>
      TrainingSurveyQuestionDatum(
        surveyId: json['SurveyId'],
        questionId: json['QuestionID'],
        questionBankCategoryId: json['QuestionBankCategoryID'],
        questionNo: json['QuestionNo'],
        question: json['Question'],
        questionInstructions: json['QuestionInstructions'],
        maxLength: json['MaxLenght'],
        questionTypeId: json['QuestionTypeID'],
        isOther: json['IsOther'] == null
            ? 0
            : json['IsOther'] == true
                ? 1
                : json['IsOther'] == false
                    ? 0
                    : json['IsOther'],
        isQuestionMandatory: json['IsQuestionMandatory'] == null
            ? 0
            : json['IsQuestionMandatory'] == true
                ? 1
                : json['IsQuestionMandatory'] == false
                    ? 0
                    : json['IsQuestionMandatory'],
        // isQuestionMandatory: 1,
        ratingStartValue: json['RatingStartValue'],
        ratingEndValue: json['RatingEndValue'],
        active: 1,
        createdOn: json['CreatedOn'],
        createdBy: json['CreatedBy'],
        updatedOn: json['UpdatedOn'],
        updatedBy: json['UpdatedBy'],
        deletedBy: json['DeletedBy'],
        deletedOn: json['DeletedOn'],
        isSkipLogic: json['IsSkipLogic'] == null
            ? 0
            : json['IsSkipLogic'] == true
                ? 1
                : json['IsSkipLogic'] == false
                    ? 0
                    : json['IsSkipLogic'],
        isDependent: json['IsDependent'] == null
            ? 0
            : json['IsDependent'] == true
                ? 1
                : json['IsDependent'] == false
                    ? 0
                    : json['IsDependent'],
        condition: json['condition'],
        questionHindi:json['QuestionHindi'],
        questionMarathi:json['QuestionMarathi'],
        questionInstructionsHindi:json['QuestionInstructionsHindi'],
        questionInstructionsMarathi:json['QuestionInstructionsMarathi'],


      );

  Map<String, dynamic> toJson() => {
      'QuestionHindi':questionHindi,
      'QuestionMarathi':questionMarathi,
      'QuestionInstructionsHindi':questionInstructionsHindi,
      'QuestionInstructionsMarathi':questionInstructionsMarathi,

        'SurveyId': surveyId,
        'QuestionID': questionId,
        'QuestionBankCategoryID': questionBankCategoryId,
        'QuestionNo': questionNo,
        'Question': question,
        'QuestionInstructions': questionInstructions,
        'MaxLenght': maxLength,
        'QuestionTypeID': questionTypeId,
        'IsOther': isOther,
        'IsQuestionMandatory': isQuestionMandatory,
        'RatingStartValue': ratingStartValue,
        'RatingEndValue': ratingEndValue,
        'Active': active,
        'CreatedOn': createdOn,
        'CreatedBy': createdBy,
        'UpdatedOn': updatedOn,
        'UpdatedBy': updatedBy,
        'DeletedBy': deletedBy,
        'DeletedOn': deletedOn,
        'IsSkipLogic': isSkipLogic,
        'IsDependent': isDependent,
        'condition': condition,
      };

  static List<TrainingSurveyQuestionDatum> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TrainingSurveyQuestionDatum>[]
        : json
            .map((value) => TrainingSurveyQuestionDatum.fromJson(value))
            .toList();
  }
}

// To parse this JSON data, do
//
//     final participantTrainingRegistrationModel = participantTrainingRegistrationModelFromJson(jsonString);

import 'dart:convert';

ParticipantTrainingRegistrationModel
    participantTrainingRegistrationModelFromJson(String str) =>
        ParticipantTrainingRegistrationModel.fromJson(json.decode(str));

String participantTrainingRegistrationModelToJson(
        ParticipantTrainingRegistrationModel data) =>
    json.encode(data.toJson());

class ParticipantTrainingRegistrationModel {
  ParticipantTrainingRegistrationModel({
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
  List<ParticipantTrainingRegistrationDatum>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory ParticipantTrainingRegistrationModel.fromJson(
          Map<String, dynamic> json) =>
      ParticipantTrainingRegistrationModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: json["Data"] == null
            ? []
            : List<ParticipantTrainingRegistrationDatum>.from(json["Data"]!
                .map((x) => ParticipantTrainingRegistrationDatum.fromJson(x))),
        succeeded: json["Succeeded"],
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

class ParticipantTrainingRegistrationDatum {
  ParticipantTrainingRegistrationDatum({
    this.trainerName,
    this.trainingType,
    this.trainingTheme,
    this.otherTheme,
    this.TopicsCoveredName,
  });

  String? trainerName;
  String? trainingType;
  String? trainingTheme;
  String? otherTheme;
  String? TopicsCoveredName;

  factory ParticipantTrainingRegistrationDatum.fromJson(
          Map<String, dynamic> json) =>
      ParticipantTrainingRegistrationDatum(
        trainerName: json["TrainerName"],
        trainingType: json["TrainingType"],
        trainingTheme: json["TrainingTheme"],
        otherTheme: json["OtherTheme"],
        TopicsCoveredName:json.containsKey('TopicsCoveredName')?json['TopicsCoveredName']:''
      );

  Map<String, dynamic> toJson() => {
        "TrainerName": trainerName,
        "TrainingType": trainingType,
        "TrainingTheme": trainingTheme,
        "OtherTheme": otherTheme,
        'TopicsCoveredName':TopicsCoveredName
      };
  static List<ParticipantTrainingRegistrationDatum> listFromJson(
      List<dynamic> json) {
    return json == null
        ? <ParticipantTrainingRegistrationDatum>[]
        : json
            .map((value) =>
                new ParticipantTrainingRegistrationDatum.fromJson(value))
            .toList();
  }
}

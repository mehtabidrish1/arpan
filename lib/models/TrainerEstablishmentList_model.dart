// To parse this JSON data, do
//
//     final trainerEstablishmentModel = trainerEstablishmentModelFromJson(jsonString);

import 'dart:convert';

TrainerEstablishmentModel trainerEstablishmentModelFromJson(String str) =>
    TrainerEstablishmentModel.fromJson(json.decode(str));

String trainerEstablishmentModelToJson(TrainerEstablishmentModel data) =>
    json.encode(data.toJson());

class TrainerEstablishmentModel {
  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  bool? nextPage;
  bool? nextPageAvailabe;
  List<TrainerEstablishmentDatum>? data;
  bool? succeeded;
  String? errors;
  String? message;

  TrainerEstablishmentModel({
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

  factory TrainerEstablishmentModel.fromJson(Map<String, dynamic> json) =>
      TrainerEstablishmentModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"] == null
            ? null
            : json["NextPage"].toString() == 'true' ||
                    json["NextPage"].toString() == '1'
                ? true
                : false,
        nextPageAvailabe: json["NextPageAvailabe"] == null
            ? null
            : json["NextPageAvailabe"].toString() == 'true' ||
                    json["NextPageAvailabe"].toString() == '1'
                ? true
                : false,
        data: json["Data"] == null
            ? []
            : List<TrainerEstablishmentDatum>.from(json["Data"]!
                .map((x) => TrainerEstablishmentDatum.fromJson(x))),
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

class TrainerEstablishmentDatum {
  String? establishmentCode;
  String? name;
  bool? active;
  int? ministryId;
  int? state;
  String? district;
  String? block;
  int? pincode;

  TrainerEstablishmentDatum({
    this.establishmentCode,
    this.name,
    this.active,
    this.ministryId,
    this.state,
    this.district,
    this.block,
    this.pincode,
  });

  factory TrainerEstablishmentDatum.fromJson(Map<String, dynamic> json) =>
      TrainerEstablishmentDatum(
        establishmentCode: json["EstablishmentCode"],
        name: json["Name"],
        active: json["Active"] == null
            ? null
            : json["Active"].toString() == 'true' ||
                    json["Active"].toString() == '1'
                ? true
                : false,
        ministryId: json["MinistryId"],
        state: json["State"],
        district: json["District"],
        block: json["Block"],
        pincode: json["Pincode"],
      );

  Map<String, dynamic> toJson() => {
        "EstablishmentCode": establishmentCode,
        "Name": name,
        "Active": active.toString(),
        "MinistryId": ministryId,
        "State": state,
        "District": district,
        "Block": block,
        "Pincode": pincode,
      };
}

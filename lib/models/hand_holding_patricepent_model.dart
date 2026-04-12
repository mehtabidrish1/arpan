import '../table_model/tbl_Training_HandHolding_Particepent.dart';
import '../table_model/tbl_master_model.dart';

class HandHoldingParicepentModel {
  HandHoldingParicepentModel({
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
  String? nextPage;
  bool? nextPageAvailabe;
  List<TrainingHandHoldingParticepent>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory HandHoldingParicepentModel.fromJson(Map<String, dynamic> json) =>
      HandHoldingParicepentModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<TrainingHandHoldingParticepent>.from(json["Data"]
            .map((x) => TrainingHandHoldingParticepent.fromJson(x))),
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
        "Data": List<TrainingHandHoldingParticepent>.from(
            data!.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

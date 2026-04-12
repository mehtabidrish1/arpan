import '../table_model/tblTraningIndirectData_list.dart';
import '../table_model/tbl_master_model.dart';
import '../table_model/training_indirect_data_model.dart';

class TblTraningIndirectDataAllModel {
  TblTraningIndirectDataAllModel({
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
  List<TrainingIndirectData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory TblTraningIndirectDataAllModel.fromJson(Map<String, dynamic> json) =>
      TblTraningIndirectDataAllModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<TrainingIndirectData>.from(
            json["Data"].map((x) => TrainingIndirectData.fromJson(x))),
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
        "Data": List<TrainingIndirectData>.from(data!.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

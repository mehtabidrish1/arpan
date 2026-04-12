import '../table_model/tbl_master_model.dart';

class MasterDropDownModel {
  MasterDropDownModel({
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
  List<TblMasterModel>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory MasterDropDownModel.fromJson(Map<String, dynamic> json) =>
      MasterDropDownModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<TblMasterModel>.from(
            json["Data"].map((x) => TblMasterModel.fromJson(x))),
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
        "Data": List<TblMasterModel>.from(data!.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

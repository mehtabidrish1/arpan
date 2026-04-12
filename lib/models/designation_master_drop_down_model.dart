import '../table_model/tbl_designation_model.dart';

class DesignationMasterDropDownModel {
  DesignationMasterDropDownModel({
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
  List<TblDesignationModel>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory DesignationMasterDropDownModel.fromJson(Map<String, dynamic> json) =>
      DesignationMasterDropDownModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<TblDesignationModel>.from(
            json["Data"].map((x) => TblDesignationModel.fromJson(x))),
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
        "Data": List<TblDesignationModel>.from(data!.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

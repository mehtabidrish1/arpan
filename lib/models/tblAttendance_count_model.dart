import '../table_model/tblAttendance_count.dart';
import '../table_model/tbl_master_model.dart';

class AttendanceCountModel {
  AttendanceCountModel({
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
  List<TblAttendanceCount>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory AttendanceCountModel.fromJson(Map<String, dynamic> json) =>
      AttendanceCountModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: TblAttendanceCount.listFromJson(json['Data']),
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
        "Data": data,
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
      };
}

import 'package:arpan/models/tbl_partial_attendance_data.dart';

import '../table_model/tbl_master_model.dart';
import '../table_model/tbl_session_attendance.dart';

class PartialAttendanceDetailModel {
  PartialAttendanceDetailModel({
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
  List<TblBatchPartialAttendanceData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory PartialAttendanceDetailModel.fromJson(Map<String, dynamic> json) =>
      PartialAttendanceDetailModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data:TblBatchPartialAttendanceData.listFromJson(json["Data"]),
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

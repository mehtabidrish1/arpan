// To parse this JSON data, do
//
//     final teacherGradeMasterDropDownModel = teacherGradeMasterDropDownModelFromJson(jsonString);

import 'dart:convert';

import '../table_model/tbl_teacher_grade_model.dart';

TeacherGradeMasterDropDownModel teacherGradeMasterDropDownModelFromJson(String str) => TeacherGradeMasterDropDownModel.fromJson(json.decode(str));

String teacherGradeMasterDropDownModelToJson(TeacherGradeMasterDropDownModel data) => json.encode(data.toJson());

class TeacherGradeMasterDropDownModel {
    int pageNumber;
    int pageSize;
    int fetchedRecords;
    int totalRecords;
    dynamic nextPage;
    bool nextPageAvailabe;
    List<TblTeacherGradeModel> data;
    bool succeeded;
    dynamic errors;
    dynamic message;

    TeacherGradeMasterDropDownModel({
        required this.pageNumber,
        required this.pageSize,
        required this.fetchedRecords,
        required this.totalRecords,
        required this.nextPage,
        required this.nextPageAvailabe,
        required this.data,
        required this.succeeded,
        required this.errors,
        required this.message,
    });

    factory TeacherGradeMasterDropDownModel.fromJson(Map<String, dynamic> json) => TeacherGradeMasterDropDownModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<TblTeacherGradeModel>.from(json["Data"].map((x) => TblTeacherGradeModel.fromJson(x))),
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
        "Data": List<TblTeacherGradeModel>.from(data.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
    };
}

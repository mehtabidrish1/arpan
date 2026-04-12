// To parse this JSON data, do
//
//     final qRcodeMasterModel = qRcodeMasterModelFromJson(jsonString);

import 'dart:convert';

import '../table_model/qr_code_model.dart';

QRcodeMasterModel qRcodeMasterModelFromJson(String str) => QRcodeMasterModel.fromJson(json.decode(str));

String qRcodeMasterModelToJson(QRcodeMasterModel data) => json.encode(data.toJson());

class QRcodeMasterModel {
    int pageNumber;
    int pageSize;
    int fetchedRecords;
    int totalRecords;
    dynamic nextPage;
    bool nextPageAvailabe;
    List<QrCodeModel> data;
    bool succeeded;
    dynamic errors;
    dynamic message;

    QRcodeMasterModel({
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

    factory QRcodeMasterModel.fromJson(Map<String, dynamic> json) => QRcodeMasterModel(
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        fetchedRecords: json["FetchedRecords"],
        totalRecords: json["TotalRecords"],
        nextPage: json["NextPage"],
        nextPageAvailabe: json["NextPageAvailabe"],
        data: List<QrCodeModel>.from(json["Data"].map((x) => QrCodeModel.fromJson(x))),
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
        "Data": List<QrCodeModel>.from(data.map((x) => x.toJson())),
        "Succeeded": succeeded,
        "Errors": errors,
        "Message": message,
    };
}

// To parse this JSON data, do
//
//     final tblIndividualPartner = tblIndividualPartnerFromJson(jsonString);

import 'dart:convert';

TblIndividualPartner tblIndividualPartnerFromJson(String str) =>
    TblIndividualPartner.fromJson(json.decode(str));

String tblIndividualPartnerToJson(TblIndividualPartner data) =>
    json.encode(data.toJson());

class TblIndividualPartner {
  int? id;
  String? individualPartnerCode;
  String? partnerName;
  String? email;
  String? phoneNo;
  int? govtPvt;
  String? ministry;
  int? govtType;
  String? remark;
  int? country;
  int? state;
  int? district;
  int? block;
  int? pin;
  String? latitude;
  String? longitude;
  String? location;
  String? addressLine1;
  String? addressLine2;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;

  TblIndividualPartner({
    this.id,
    this.individualPartnerCode,
    this.partnerName,
    this.email,
    this.phoneNo,
    this.govtPvt,
    this.ministry,
    this.govtType,
    this.remark,
    this.country,
    this.state,
    this.district,
    this.block,
    this.pin,
    this.latitude,
    this.longitude,
    this.location,
    this.addressLine1,
    this.addressLine2,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });

  factory TblIndividualPartner.fromJson(Map<String, dynamic> json) =>
      TblIndividualPartner(
        id: json["Id"],
        individualPartnerCode: json["IndividualPartnerCode"],
        partnerName: json["PartnerName"],
        email: json["Email"],
        phoneNo: json["PhoneNo"],
        govtPvt: json["GovtPvt"],
        ministry: json["Ministry"],
        govtType: json["GovtType"],
        remark: json["Remark"],
        country: json["Country"],
        state: json["State"],
        district: json["District"],
        block: json["Block"],
        pin: json["Pin"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        location: json["Location"],
        addressLine1: json["AddressLine1"],
        addressLine2: json["AddressLine2"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "IndividualPartnerCode": individualPartnerCode,
        "PartnerName": partnerName,
        "Email": email,
        "PhoneNo": phoneNo,
        "GovtPvt": govtPvt,
        "Ministry": ministry,
        "GovtType": govtType,
        "Remark": remark,
        "Country": country,
        "State": state,
        "District": district,
        "Block": block,
        "Pin": pin,
        "Latitude": latitude,
        "Longitude": longitude,
        "Location": location,
        "AddressLine1": addressLine1,
        "AddressLine2": addressLine2,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn,
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn,
      };
}

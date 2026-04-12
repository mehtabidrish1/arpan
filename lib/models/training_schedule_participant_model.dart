// To parse this JSON data, do
//
//     final trainingScheduleParticipantModel = trainingScheduleParticipantModelFromJson(jsonString);

import 'dart:convert';

TrainingScheduleParticipantModel trainingScheduleParticipantModelFromJson(
        String str) =>
    TrainingScheduleParticipantModel.fromJson(json.decode(str));

String trainingScheduleParticipantModelToJson(
        TrainingScheduleParticipantModel data) =>
    json.encode(data.toJson());

class TrainingScheduleParticipantModel {
  // int? id;
//  String? particitantGuid;
  String? scheduleGuid;
  // String? timestamp;
  String? email;
  String? fullName;
  String? dob;
  String? gender;
  String? phoneNo;
  String? designation;
  String? organisationName;
  String? organisationCode;
  String? pinCode;
  String? attendedArpanSessionChildSexualAbuse;
  String? monthYearAttendSession;
  String? stateId;
  String? districtId;
  String? blockId;
  String? createdBy;
  String? createdOn;
  // String? updatedOn;
  // String? updatedBy;
  // String? phoneNoTen;
  String? languageId;
  int? isEdited;
  String? registrationGuid;
  String? latitude;
  String? longitude;
  String? otherState;
  String? otherDistrict;
  String? otherBlock;
  String? otherDesignation;
  String? teacherGrade;
  String? udiseCode;

  TrainingScheduleParticipantModel(
      {this.scheduleGuid,
      this.email,
      this.fullName,
      this.dob,
      this.gender,
      this.phoneNo,
      this.designation,
      this.organisationName,
      this.organisationCode,
      this.pinCode,
      this.attendedArpanSessionChildSexualAbuse,
      this.monthYearAttendSession,
      this.stateId,
      this.districtId,
      this.blockId,
      this.createdBy,
      this.createdOn,
      this.languageId,
      this.isEdited,
      this.registrationGuid,
      this.latitude,
      this.longitude,
      this.otherState,
      this.otherDistrict,
      this.otherBlock,
      this.otherDesignation,
      this.teacherGrade,
      this.udiseCode});

  factory TrainingScheduleParticipantModel.fromJson(
          Map<String, dynamic> json) =>
      TrainingScheduleParticipantModel(
        scheduleGuid: json["ScheduleGuid"],
        email: json["Email"],
        fullName: json["FullName"],
        dob: json["DOB"],
        gender: json["Gender"],
        phoneNo: json["PhoneNo"],
        designation: json["Designation"],
        organisationName: json["OrganisationName"],
        organisationCode: json["OrganisationCode"],
        pinCode: json["PinCode"],
        attendedArpanSessionChildSexualAbuse:
            json["AttendedArpansessionChildSexualAbuse"],
        monthYearAttendSession: json["MonthYearAttendSession"],
        stateId: json["StateID"],
        districtId: json["DistrictID"],
        blockId: json["BlockID"].toString(),
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        languageId: json["LanguageID"],
        isEdited: json["IsEdited"],
        registrationGuid: json["RegistrationGuid"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        otherState: json["OtherState"],
        otherDistrict: json["OtherDistrict"],
        otherBlock: json["OtherBlock"],
        otherDesignation: json["OtherDesignation"],
        teacherGrade: json["TeacherGrade"],
        udiseCode: json["UDISECode"],
      );

  Map<String, dynamic> toJson() => {
        "ScheduleGuid": scheduleGuid,
        "Email": email,
        "FullName": fullName,
        "DOB": dob,
        "Gender": gender,
        "PhoneNo": phoneNo,
        "Designation": designation,
        "OrganisationName": organisationName,
        "OrganisationCode": organisationCode,
        "PinCode": pinCode,
        "AttendedArpansessionChildSexualAbuse":
            attendedArpanSessionChildSexualAbuse,
        "MonthYearAttendSession": monthYearAttendSession,
        "StateID": stateId,
        "DistrictID": districtId,
        "BlockID": blockId,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn,
        "LanguageID": languageId,
        "IsEdited": isEdited,
        "RegistrationGuid": registrationGuid,
        "Latitude": latitude,
        "Longitude": longitude,
        "OtherState": otherState,
        "OtherDistrict": otherDistrict,
        "OtherBlock": otherBlock,
        "OtherDesignation": otherDesignation,
        "TeacherGrade": teacherGrade,
        "UDISECode": udiseCode,
      };

  static List<TrainingScheduleParticipantModel> listFromJson(
      List<dynamic>? json) {
    return json == null
        ? <TrainingScheduleParticipantModel>[]
        : json
            .map((value) => TrainingScheduleParticipantModel.fromJson(value))
            .toList();
  }
}

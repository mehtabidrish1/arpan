class ParticipantRegistrationPost {
  List<ParticipantRegistration>? participantRegistration;

  ParticipantRegistrationPost({this.participantRegistration});

  ParticipantRegistrationPost.fromJson(Map<String, dynamic> json) {
    if (json['ParticipantRegistration'] != null) {
      participantRegistration = <ParticipantRegistration>[];
      json['ParticipantRegistration'].forEach((v) {
        participantRegistration!.add(ParticipantRegistration.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (participantRegistration != null) {
      data['ParticipantRegistration'] =
          participantRegistration!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticipantRegistration {
  String? Designation;
  String? participantGuid;
  String? scheduleGuid;
  String? FullName;
  String? Timestamp;
  String? email;
  String? TehsilName;
  String? approvalStatus;
  String? phoneNo;
  String? gender;

  String? city;
  String? zipPostalPinCode;
  String? organisationName;
  String? attendedArpansessionChildSexualAbuse;
  String? monthYearAttendSession;
  String? phoneNoTen;

  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? RegistrationGuid;
  ParticipantRegistration({
    this.participantGuid,
    this.scheduleGuid,
    this.FullName,
    this.Timestamp,
    this.email,
    this.TehsilName,
    this.approvalStatus,
    this.phoneNo,
    this.gender,
    this.city,
    this.zipPostalPinCode,
    this.organisationName,
    this.attendedArpansessionChildSexualAbuse,
    this.monthYearAttendSession,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.phoneNoTen,
    this.Designation,
    this.RegistrationGuid,
  });

  ParticipantRegistration.fromJson(Map<String, dynamic> json) {
    participantGuid = json['ParticipantGuid'];
    RegistrationGuid = json['RegistrationGuid'];
    scheduleGuid = json['ScheduleGuid'];
    FullName = json['FullName'];
    // TehsilName = json['TehsilName'];
    email = json['Email'];
    TehsilName = json['TehsilName'];
    Designation = json['Designation'];
    approvalStatus = json['ApprovalStatus'];
    phoneNo = json['PhoneNo'];
    gender = json['Gender'];
    city = json['City'];
    zipPostalPinCode = json['ZipPostalPinCode'];
    organisationName = json['OrganisationName'];
    attendedArpansessionChildSexualAbuse =
        json['AttendedArpansessionChildSexualAbuse'];
    monthYearAttendSession = json['MonthYearAttendSession'];
    createdBy = json['CreatedBy'];
    createdOn = json["CreatedOn"];
    updatedBy = json["UpdatedBy"];
    updatedOn = json["UpdatedOn"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreatedBy'] = createdBy;
    data['CreatedOn'] = createdOn;
    data['UpdatedBy'] = updatedBy;
    data['UpdatedOn'] = updatedOn;

    data['ParticipantGuid'] = participantGuid;
    data['RegistrationGuid'] = RegistrationGuid;

    data['FullName'] = FullName;
    data['TehsilName'] = TehsilName;
    data['Email'] = email;
    data['Designation'] = Designation;
    data['ApprovalStatus'] = approvalStatus;
    data['PhoneNo'] = phoneNo;
    data['Gender'] = gender;
    data['City'] = city;
    data['ZipPostalPinCode'] = zipPostalPinCode;
    data['OrganisationName'] = organisationName;
    data['AttendedArpansessionChildSexualAbuse'] =
        attendedArpansessionChildSexualAbuse;
    data['MonthYearAttendSession'] = monthYearAttendSession;
    return data;
  }
}

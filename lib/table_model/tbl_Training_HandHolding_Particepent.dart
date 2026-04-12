class TrainingHandHoldingParticepent {
  String? particitantGuid;
  String? scheduleGuid;
  String? timestamp;
  String? email;
  String? fullName;
  String? gender;
  String? phoneNo;
  String? designation;
  String? organisationName;
  String? city;
  String? dob;
  String? tehsilName;
  String? pinCode;
  String? attendedArpanSessionChildSexualAbuse;
  String? monthYearAttendSession;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  String? phoneNoTen;
  String? HandHoldingGuid;
  int? IsEdited;
  String? stateId;
  String? districtId;
  String? OrganisationCode;
  String? otherDesignation;
  TrainingHandHoldingParticepent(
      {this.particitantGuid,
      this.scheduleGuid,
      this.timestamp,
      this.email,
      this.fullName,
      this.gender,
      this.phoneNo,
      this.designation,
      this.organisationName,
      this.dob,
      this.city,
      this.tehsilName,
      this.pinCode,
      this.attendedArpanSessionChildSexualAbuse,
      this.monthYearAttendSession,
      this.createdBy,
      this.createdOn,
      this.updatedOn,
      this.updatedBy,
      this.phoneNoTen,
      this.HandHoldingGuid,
      this.IsEdited,
      this.stateId,
      this.districtId,
      this.OrganisationCode,
      this.otherDesignation});

  factory TrainingHandHoldingParticepent.fromJson(Map<String, dynamic> json) {
    return TrainingHandHoldingParticepent(
      HandHoldingGuid:
          json.containsKey('HandHoldingGuid') ? json['HandHoldingGuid'] : '',
      particitantGuid: json['ParticitantGuid'],
      scheduleGuid: json['ScheduleGuid'],
      timestamp: json['Timestamp'],
      dob: json.containsKey('DOB') ? json['DOB'] : '',
      email: json['Email'],
      fullName: json['FullName'],
      gender: json['Gender'],
      phoneNo: json['PhoneNo'],
      designation: json['Designation'],
      organisationName: json['OrganisationName'],
      city: json['City'],
      tehsilName: json['TehsilName'],
      pinCode: json['PinCode'],
      attendedArpanSessionChildSexualAbuse:
          json['AttendedArpansessionChildSexualAbuse'],
      monthYearAttendSession: json['MonthYearAttendSession'],
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedOn: json['UpdatedOn'],
      updatedBy: json['UpdatedBy'],
      phoneNoTen: json['PhoneNoTen'],
      otherDesignation: json['OtherDesignation'],
      IsEdited: json.containsKey('IsEdited') ? json['IsEdited'] : 0,
      stateId: json.containsKey('StateId') ? json['StateId'] : '0',
      districtId: json.containsKey('DistrictId') ? json['DistrictId'] : '0',
      OrganisationCode:
          json.containsKey('OrganisationCode') ? json['OrganisationCode'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HandHoldingGuid': HandHoldingGuid,
      'ParticitantGuid': particitantGuid,
      'ScheduleGuid': scheduleGuid,
      'Timestamp': timestamp,
      'Email': email,
      'FullName': fullName,
      'Gender': gender,
      'PhoneNo': phoneNo,
      'DOB': dob,
      'Designation': designation,
      'OrganisationName': organisationName,
      'City': city,
      'TehsilName': tehsilName,
      'PinCode': pinCode,
      'AttendedArpansessionChildSexualAbuse':
          attendedArpanSessionChildSexualAbuse,
      'MonthYearAttendSession': monthYearAttendSession,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'UpdatedOn': updatedOn,
      'UpdatedBy': updatedBy,
      'PhoneNoTen': phoneNoTen,
      'IsEdited': IsEdited,
      'StateId': stateId,
      'DistrictId': districtId,
      'OrganisationCode': OrganisationCode,
      'OtherDesignation': otherDesignation
    };
  }
}

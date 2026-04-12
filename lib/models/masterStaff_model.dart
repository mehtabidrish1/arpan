class MasterStaffModel {

  MasterStaffModel({
    this.id,
    this.modifiedOn,
    this.modifiedBy,
    this.createdOn,
    this.createdBy,
    this.active,
    this.aadharNo,
    this.alternateEmailID,
    this.alternateMobileNo,
    this.bloodGroup,
    this.childrenNo,
    this.city,
    this.country,
    this.currentAddress,
    this.dateImportedHR,
    this.department,
    this.designationID,
    this.dob,
    this.emailID,
    this.empID,
    this.externalCompany,
    this.fatherAge,
    this.fatherName,
    this.fatherProfession,
    this.fromTo,
    this.fromTo1,
    this.gender,
    this.hiringSource,
    this.isAadhar,
    this.isOther,
    this.isPan,
    this.jobLevel,
    this.joiningDate,
    this.keyResponsibilities,
    this.keyResponsibilities1,
    this.languageProficiency,
    this.leavingReason,
    this.leavingReason1,
    this.macID,
    this.maritalStatus,
    this.mobileNo,
    this.motherAge,
    this.motherName,
    this.motherProfession,
    this.nationality,
    this.oldEmpCode,
    this.organization,
    this.organization1,
    this.panNo,
    this.password,
    this.permanentAddress,
    this.piCheck,
    this.pIName,
    this.pinCode,
    this.position,
    this.position1,
    this.preferredArea,
    this.primaryAddress,
    this.primaryCity,
    this.primaryName,
    this.primaryPhone,
    this.primaryRelationship,
    this.profileImage,
    this.qualification,
    this.reference1,
    this.reference2,
    this.salary,
    this.salary1,
    this.secondaryAddress,
    this.secondaryCity,
    this.secondaryName,
    this.secondaryPhone,
    this.secondaryRelationship,
    this.smlName,
    this.smmName,
    this.smName,
    this.specialization,
    this.spouseName,
    this.spouseProfession,
    this.staffType,
    this.state,
    this.team,
    this.totalExperience,
  });

  int? id;
  String? empID;
  int? staffType;
  String? smName;
  String? smmName;
  String? smlName;
  String? externalCompany;
  int? gender;
  DateTime? dob;
  String? bloodGroup;
  String? joiningDate;
  int? totalExperience;
  String? preferredArea;
  int? country;
  int? state;
  int? city;
  String? password;
  int? designationID;
  String? mobileNo;
  String? alternateMobileNo;
  String? emailID;
  String? alternateEmailID;
  String? profileImage;
  String? currentAddress;
  String? permanentAddress;
  String? pinCode;
  String? specialization;
  String? qualification;

  // String? IMEI#01;
  // String? IMEI#02;
  String? macID;
  String? oldEmpCode;
  DateTime? dateImportedHR;
  String? department;
  String? jobLevel;
  String? hiringSource;
  String? pIName;
  String? nationality;
  String? languageProficiency;
  int? maritalStatus;
  String? spouseName;
  String? spouseProfession;
  String? childrenNo;
  String? fatherName;
  String? fatherProfession;
  String? fatherAge;
  String? motherName;
  String? motherProfession;
  String? motherAge;
  String? primaryName;
  String? secondaryName;
  String? primaryRelationship;
  String? secondaryRelationship;
  String? primaryPhone;
  String? secondaryPhone;
  String? primaryAddress;
  String? secondaryAddress;
  String? primaryCity;
  String? secondaryCity;
  String? fromTo;
  String? fromTo1;
  String? organization;
  String? organization1;
  String? keyResponsibilities;
  String? keyResponsibilities1;
  String? position;
  String? position1;
  String? salary;
  String? salary1;
  String? leavingReason;
  String? leavingReason1;
  String? reference1;
  String? reference2;
  String? aadharNo;
  String? panNo;
  int? isAadhar;
  int? isPan;
  int? isOther;
  int? piCheck;
  String? team;
  int? active;
  int? createdBy;
  DateTime? createdOn;
  int? modifiedBy;
  DateTime? modifiedOn;

  factory MasterStaffModel.fromJson(Map<String, dynamic> json) =>
      MasterStaffModel(
        id: json["ID"],
        aadharNo: json["AadharNo"],
        active: json["Active"],
        alternateEmailID: json["AlternateEmailID"],
        alternateMobileNo: json["AlternateMobileNo"],
        bloodGroup: json["BloodGroup"],
        childrenNo: json["ChildrenNo"],
        city: json["City"],
        country: json["Country"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        currentAddress: json["CurrentAddress"],
        totalExperience: json["TotalExperience"],
        team: json["Seam"],
        state: json["State"],
        staffType: json["StaffType"],
        spouseProfession: json["SpouseProfession"],
        spouseName: json["SpouseName"],
        specialization: json["Specialization"],
        smName: json["SmName"],
        smmName: json["SmmName"],
        smlName: json["SmlName"],
        secondaryRelationship: json["SecondaryRelationship"],
        secondaryPhone: json["SecondaryPhone"],
        secondaryName: json["SecondaryName"],
        secondaryCity: json["SecondaryCity"],
        secondaryAddress: json["SecondaryAddress"],
        salary1: json["Salary1"],
        salary: json["Salary"],
        reference2: json["Reference2"],
        reference1: json["Reference1"],
        qualification: json["Qualification"],
        profileImage: json["ProfileImage"],
        primaryRelationship: json["PrimaryRelationship"],
        primaryPhone: json["PrimaryPhone"],
        primaryCity: json["PrimaryCity"],
        primaryName: json["PrimaryName"],
        primaryAddress: json["PrimaryAddress"],
        preferredArea: json["PreferredArea"],
        position1: json["Position1"],
        position: json["Position"],
        pinCode: json["PinCode"],
        pIName: json["PIName"],
        piCheck: json["PiCheck"],
        permanentAddress: json["PermanentAddress"],
        password: json["Password"],
        panNo: json["PanNo"],
        organization1: json["Organization1"],
        organization: json["Organization"],
        oldEmpCode: json["OldEmpCode"],
        nationality: json["Nationality"],
        motherProfession: json["MotherProfession"],
        motherName: json["MotherName"],
        motherAge: json["MotherAge"],
        mobileNo: json["MobileNo"],
        maritalStatus: json["MaritalStatus"],
        macID: json["MacID"],
        leavingReason1: json["LeavingReason1"],
        leavingReason: json["LeavingReason"],
        languageProficiency: json["LanguageProficiency"],
        keyResponsibilities1: json["KeyResponsibilities1"],
        keyResponsibilities: json["KeyResponsibilities"],
        joiningDate: json["JoiningDate"],
        jobLevel: json["JobLevel"],
        isPan: json["IsPan"],
        isOther: json["IsOther"],
        isAadhar: json["IsAadhar"],
        hiringSource: json["HiringSource"],
        gender: json["Gender"],
        fromTo1: json["FromTo1"],
        fromTo: json["FromTo"],
        fatherProfession: json["FatherProfession"],
        fatherName: json["FatherName"],
        fatherAge: json["FatherAge"],
        externalCompany: json["ExternalCompany"],
        empID: json["EmpID"],
        emailID: json["EmailID"],
        dob: json["Dob"],
        designationID: json["DesignationID"],
        department: json["Department"],
        dateImportedHR: json["DateImportedHR"],
        modifiedBy: json["ModifiedBy"],
        modifiedOn: json["ModifiedOn"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ModifiedOn": modifiedOn,
        "ModifiedBy": modifiedBy,
        "DateImportedHR": dateImportedHR,
        "DesignationID": designationID,
        "Dob": dob,
        "EmailID": emailID,
        "EmpID": empID,
        "ExternalCompany": externalCompany,
        "FatherAge": fatherAge,
        "FatherProfession": fatherProfession,
        "FromTo": fromTo,
        "FromTo1": fromTo1,
        "Gender": gender,
        "HiringSource": hiringSource,
        "IsAadhar": isAadhar,
        "MobileNo": mobileNo,
        "MaritalStatus": maritalStatus,
        "MacID": macID,
        "LeavingReason1": leavingReason1,
        "leavingReason": leavingReason,
        "languageProficiency": languageProficiency,
        "keyResponsibilities1": keyResponsibilities1,
        "keyResponsibilities": keyResponsibilities,
        "joiningDate": joiningDate,
        "jobLevel": jobLevel,
        "isPan": isPan,
        "isOther": isOther,
        "MotherAge": motherAge,
        "AadharNo": aadharNo,
        "Active": active,
        "AlternateEmailID": alternateEmailID,
        "AlternateMobileNo": alternateMobileNo,
        "BloodGroup": bloodGroup,
        "ChildrenNo": childrenNo,
        "City": city,
        "Country": country,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn,
        "CurrentAddress": currentAddress,
        "TotalExperience": totalExperience,
        "Team": team,
        "State": state,
        "StaffType": staffType,
        "SpouseProfession": spouseProfession,
        "SpouseName": spouseName,
        "Specialization": specialization,
        "SmName": smName,
        "SmmName": smmName,
        "SmlName": smlName,
        "SecondaryRelationship": secondaryRelationship,
        "SecondaryPhone": secondaryPhone,
        "SecondaryName": secondaryName,
        "SecondaryCity": secondaryCity,
        "SecondaryAddress": secondaryAddress,
        "Salary1": salary1,
        "Salary": salary,
        "Reference2": reference2,
        "Reference1": reference1,
        "Qualification": qualification,
        "ProfileImage": profileImage,
        "PrimaryRelationship": primaryRelationship,
        "PrimaryPhone": primaryPhone,
        "PrimaryCity": primaryCity,
        "PrimaryName": primaryName,
        "PrimaryAddress": primaryAddress,
        "PreferredArea": preferredArea,
        "Position1": position1,
        "Position": position,
        "PinCode": pinCode,
        "PIName": pIName,
        "PiCheck": piCheck,
        "PermanentAddress": permanentAddress,
        "Password": password,
        "PanNo": panNo,
        "Organization1": organization1,
        "Organization": organization,
        "OldEmpCode": oldEmpCode,
        "Nationality": nationality,
        "MotherProfession": motherProfession,
        "MotherName": motherName,
      };

}

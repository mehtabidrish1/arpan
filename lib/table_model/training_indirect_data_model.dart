class TrainingIndirectData {
  String? indirectDataGuid;
  String? scheduleGuid;
  String? registrationGuid;
  String? sessionGuid;
  String? email;
  String? fullName;
  int? gender;
  String? dob;
  String? phoneNo;
  String? establishment;
  String? establishmentname;
  String? pinCode;
  int? toWhomHaveYouReachedOutWithArpanContent;
  int? howManyChildrenDidYouTrainThroughPseProgram;
  String? childrenIndicateTheModuleUsed;
  String? whenDidYouReachOutToChildrenYear1;
  String? whenDidYouReachOutToChildrenMonth1;
  String? whenDidYouReachOutToChildrenYear2;
  String? whenDidYouReachOutToChildrenMonth2;
  int? howManyAdultsDidYouTrainUsingArpanContent;
  String? adultIndicateTheModulePptUsed;
  String? whenDidYouReachOutToAdultsYear1;
  String? whenDidYouReachOutToAdultsMonth1;
  String? whenDidYouReachOutToAdultsYear2;
  String? whenDidYouReachOutToAdultsMonth2;
  String? ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  String? syncingDate;
  String? ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther;
  String? childrenIndicateTheModuleUsedOther;
  String? adultIndicateTheModulePptUsedOther;
  int? IsEdited;
  String? Have_you_trained_Adult_alone_or_jointly_with_others;
  String? If_jointly_with_how_many_others;
  String? organisationName;
  String? udiseCode;
  String? state;
  String? district;
  String? block;
  String? maleChild;
  String? femaleChild;
  String? otherChild;
  String? parents;
  String? teachers;
  String? jointParticipant;
  String? grade;

  TrainingIndirectData(
      {this.indirectDataGuid,
      this.scheduleGuid,
      this.registrationGuid,
      this.sessionGuid,
      this.email,
      this.fullName,
      this.gender,
      this.dob,
      this.phoneNo,
      this.establishment,
      this.pinCode,
      this.toWhomHaveYouReachedOutWithArpanContent,
      this.howManyChildrenDidYouTrainThroughPseProgram,
      this.childrenIndicateTheModuleUsed,
      this.whenDidYouReachOutToChildrenYear1,
      this.whenDidYouReachOutToChildrenMonth1,
      this.whenDidYouReachOutToChildrenYear2,
      this.whenDidYouReachOutToChildrenMonth2,
      this.howManyAdultsDidYouTrainUsingArpanContent,
      this.adultIndicateTheModulePptUsed,
      this.whenDidYouReachOutToAdultsYear1,
      this.whenDidYouReachOutToAdultsMonth1,
      this.whenDidYouReachOutToAdultsYear2,
      this.whenDidYouReachOutToAdultsMonth2,
      this.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy,
      this.createdBy,
      this.createdOn,
      this.updatedBy,
      this.updatedOn,
      this.syncingDate,
      this.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther,
      this.childrenIndicateTheModuleUsedOther,
      this.adultIndicateTheModulePptUsedOther,
      this.IsEdited,
      this.Have_you_trained_Adult_alone_or_jointly_with_others,
      this.If_jointly_with_how_many_others,
      this.organisationName,
      this.udiseCode,
      this.state,
      this.district,
      this.block,
      this.maleChild,
      this.femaleChild,
      this.otherChild,
      this.parents,
      this.teachers,
      this.jointParticipant,
      this.grade,
      this.establishmentname});

  factory TrainingIndirectData.fromJson(Map<String, dynamic> json) {
    return TrainingIndirectData(
      indirectDataGuid: json['IndirectDataGuid'],
      scheduleGuid: json['ScheduleGuid'],
      registrationGuid: json['RegistrationGuid'],
      sessionGuid: json['SessionGuid'],
      email: json['Email'],
      fullName: json['FullName'],
      gender: json['Gender'],
      phoneNo: json['PhoneNo'],
      dob: json.containsKey('DOB') ? json['DOB'] : '',
      establishment: json['Establishment'],
      establishmentname: json.containsKey('EstablishmentName')
          ? json['EstablishmentName']
          : '',
      pinCode: json['PinCode'],
      toWhomHaveYouReachedOutWithArpanContent:
          json['To_whom_have_you_reached_out_with_Arpan_content'],
      howManyChildrenDidYouTrainThroughPseProgram: json[
          'How_many_children_did_you_train_through_the_Personal_Safety_Education_PSE_program'],
      childrenIndicateTheModuleUsed: json['Children_Indicate_the_module_used'],
      whenDidYouReachOutToChildrenYear1:
          json['When_did_you_reach_out_to_Children_Year1'],
      whenDidYouReachOutToChildrenMonth1:
          json['When_did_you_reach_out_to_Children_Month1'],
      whenDidYouReachOutToChildrenYear2:
          json['When_did_you_reach_out_to_Children_Year2'],
      whenDidYouReachOutToChildrenMonth2:
          json['When_did_you_reach_out_to_Children_Month2'],
      howManyAdultsDidYouTrainUsingArpanContent:
          json['How_many_adults_did_you_train_using_Arpan_content'],
      adultIndicateTheModulePptUsed: json['Adult_Indicate_the_module_PPT_used'],
      whenDidYouReachOutToAdultsYear1:
          json['When_did_you_reach_out_to_adults_Year1'],
      whenDidYouReachOutToAdultsMonth1:
          json['When_did_you_reach_out_to_adults_Month1'],
      whenDidYouReachOutToAdultsYear2:
          json['When_did_you_reach_out_to_adults_Year2'],
      whenDidYouReachOutToAdultsMonth2:
          json['When_did_you_reach_out_to_adults_Month2'],
      ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy:
          json['If_you_have_chosen_Not_Yet_With_No_One_please_indicate_why'],
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedBy: json['UpdatedBy'],
      updatedOn: json['UpdatedOn'],
      syncingDate: json['SyncingDate'],
      ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther: json[
          'If_you_have_chosen_Not_Yet_With_No_One_please_indicate_why_other'],
      childrenIndicateTheModuleUsedOther:
          json['Children_Indicate_the_module_used_other'],
      adultIndicateTheModulePptUsedOther:
          json['Adult_Indicate_the_module_PPT_used_other'],
      IsEdited: json.containsKey('IsEdited') ? json['IsEdited'] : 0,
      Have_you_trained_Adult_alone_or_jointly_with_others: json.containsKey(
              'Have_you_trained_Adult_alone_or_jointly_with_others')
          ? json['Have_you_trained_Adult_alone_or_jointly_with_others']
              .toString()
          : '',
      If_jointly_with_how_many_others:
          json.containsKey('If_jointly_with_how_many_others')
              ? json['If_jointly_with_how_many_others'].toString()
              : '',
      organisationName: json["OrganisationName"],
      udiseCode: json["UDISECode"],
      state: json["State"],
      district: json["District"],
      block: json["Block"],
      maleChild: json["MaleChild"],
      femaleChild: json["FemaleChild"],
      otherChild: json["OtherChild"],
      parents: json["Parents"],
      teachers: json["Teachers"],
      jointParticipant: json["JointParticipant"],
      grade: json["Grade"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'IndirectDataGuid': indirectDataGuid,
      'ScheduleGuid': scheduleGuid,
      'RegistrationGuid': registrationGuid,
      'SessionGuid': sessionGuid,
      'Email': email,
      'FullName': fullName,
      'Gender': gender,
      'PhoneNo': phoneNo,
      'DOB': dob,
      'Establishment': establishment,
      'EstablishmentName': establishmentname,
      'PinCode': pinCode,
      'To_whom_have_you_reached_out_with_Arpan_content':
          toWhomHaveYouReachedOutWithArpanContent,
      'How_many_children_did_you_train_through_the_Personal_Safety_Education_PSE_program':
          howManyChildrenDidYouTrainThroughPseProgram,
      'Children_Indicate_the_module_used': childrenIndicateTheModuleUsed,
      'When_did_you_reach_out_to_Children_Year1':
          whenDidYouReachOutToChildrenYear1,
      'When_did_you_reach_out_to_Children_Month1':
          whenDidYouReachOutToChildrenMonth1,
      'When_did_you_reach_out_to_Children_Year2':
          whenDidYouReachOutToChildrenYear2,
      'When_did_you_reach_out_to_Children_Month2':
          whenDidYouReachOutToChildrenMonth2,
      'How_many_adults_did_you_train_using_Arpan_content':
          howManyAdultsDidYouTrainUsingArpanContent,
      'Adult_Indicate_the_module_PPT_used': adultIndicateTheModulePptUsed,
      'When_did_you_reach_out_to_adults_Year1': whenDidYouReachOutToAdultsYear1,
      'When_did_you_reach_out_to_adults_Month1':
          whenDidYouReachOutToAdultsMonth1,
      'When_did_you_reach_out_to_adults_Year2': whenDidYouReachOutToAdultsYear2,
      'When_did_you_reach_out_to_adults_Month2':
          whenDidYouReachOutToAdultsMonth2,
      'If_you_have_chosen_Not_Yet_With_No_One_please_indicate_why':
          ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'UpdatedBy': updatedBy,
      'UpdatedOn': updatedOn,
      'SyncingDate': syncingDate,
      'If_you_have_chosen_Not_Yet_With_No_One_please_indicate_why_other':
          ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther,
      'Children_Indicate_the_module_used_other':
          childrenIndicateTheModuleUsedOther,
      'Adult_Indicate_the_module_PPT_used_other':
          adultIndicateTheModulePptUsedOther,
      'IsEdited': IsEdited,
      'Have_you_trained_Adult_alone_or_jointly_with_others':
          Have_you_trained_Adult_alone_or_jointly_with_others,
      'If_jointly_with_how_many_others': If_jointly_with_how_many_others,
      "OrganisationName": organisationName,
      "UDISECode": udiseCode,
      "State": state,
      "District": district,
      "Block": block,
      "MaleChild": maleChild,
      "FemaleChild": femaleChild,
      "OtherChild": otherChild,
      "Parents": parents,
      "Teachers": teachers,
      "JointParticipant": jointParticipant,
      "Grade": grade,
    };
  }
}

class SurveyResponse {
  String? surveyId;
  String? mobileNo;
  String? registrationGuid;
  String? questionId;
  String? response;
  String? otherResponse;
  String? createdOn;
  String? scheduleGuid;
  String? languageID;
  int? isEdited;

  SurveyResponse(
      {this.surveyId,
      this.mobileNo,
      this.registrationGuid,
      this.questionId,
      this.response,
      this.otherResponse,
      this.createdOn,
      this.scheduleGuid,
      this.isEdited,
      this.languageID});

  // Map the SurveyResponse object to a Map of key-value pairs
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'SurveyId': surveyId,
      'MobileNo': mobileNo,
      'RegistrationGuid': registrationGuid,
      'QuestionID': questionId,
      'Response': response,
      'OtherResponse': otherResponse,
      'CreatedOn': createdOn,
      'ScheduleGuid': scheduleGuid,
      'LanguageID': languageID,
      'IsEdited': isEdited
    };
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'SurveyId': surveyId,
      'MobileNo': mobileNo,
      'RegistrationGuid': registrationGuid,
      'QuestionID': questionId,
      'Response': response,
      'OtherResponse': otherResponse,
      'CreatedOn': createdOn,
      'ScheduleGuid': scheduleGuid,
      'LanguageID': languageID,
      'IsEdited': isEdited
    };
  }

  // Map a Map of key-value pairs to a SurveyResponse object
  factory SurveyResponse.fromJson(Map<String, dynamic> map) {
    return SurveyResponse(
      surveyId: map['SurveyId'],
      mobileNo: map['MobileNo'],
      registrationGuid: map['RegistrationGuid'],
      questionId: map['QuestionID'],
      response: map['Response'],
      otherResponse: map['OtherResponse'],
      createdOn: map['CreatedOn'],
      languageID: map['LanguageID'],
      scheduleGuid: map.containsKey('ScheduleGuid') ? map['ScheduleGuid'] : '',
      isEdited: map.containsKey('IsEdited') ? map['IsEdited'] : 0,
    );
  }
}

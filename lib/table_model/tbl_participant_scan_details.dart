class ParticipantScanDetails {
  String? mobileNo;
  String? scheduleGuid;
  String? registrationGuid;
  String? surveyId;
  String? trainerName;
  String? firstDate;
  String? lastDate;
  String? topicsCoveredName;
  String? trainingName;
  String? blockName;
  String? typeOfGroup;
  int? isEdited;
  String? stateId;
  String? districtId;
  String? blockId;
  String? ministryId;
  // String? establishmentLists;
  String? individualPartnerLists;

  ParticipantScanDetails({
    this.mobileNo,
    this.scheduleGuid,
    this.registrationGuid,
    this.surveyId,
    this.trainerName,
    this.firstDate,
    this.lastDate,
    this.topicsCoveredName,
    this.trainingName,
    this.blockName,
    this.typeOfGroup,
    this.isEdited,
    this.stateId,
    this.districtId,
    this.blockId,
    this.ministryId,
    // this.establishmentLists,
    this.individualPartnerLists,
  });

  factory ParticipantScanDetails.fromJson(Map<String, dynamic> json) =>
      ParticipantScanDetails(
        mobileNo: json["MobileNo"],
        scheduleGuid: json["ScheduleGuid"],
        registrationGuid: json["RegistrationGuid"],
        surveyId: json["SurveyId"],
        trainerName: json["TrainerName"],
        firstDate: json["FirstDate"],
        lastDate: json["LastDate"],
        topicsCoveredName: json["TopicsCoveredName"],
        trainingName: json["TrainingName"],
        blockName: json["BlockName"],
        typeOfGroup: json["TypeOfGroup"],
        isEdited: json["IsEdited"],
        stateId: json["StateId"],
        districtId: json["DistrictId"],
        blockId: json["BlockId"],
        ministryId: json["MinistryId"],
        // establishmentLists: json["EstablishmentLists"],
        individualPartnerLists: json["IndividualPartnerLists"],
      );

  Map<String, dynamic> toJson() => {
        "MobileNo": mobileNo,
        "ScheduleGuid": scheduleGuid,
        "RegistrationGuid": registrationGuid,
        "SurveyId": surveyId,
        "TrainerName": trainerName,
        "FirstDate": firstDate,
        "LastDate": lastDate,
        "TopicsCoveredName": topicsCoveredName,
        "TrainingName": trainingName,
        "BlockName": blockName,
        "TypeOfGroup": typeOfGroup,
        "IsEdited": isEdited,
        "StateId": stateId,
        "DistrictId": districtId,
        "BlockId": blockId,
        "MinistryId": ministryId,
        // "EstablishmentLists": establishmentLists,
        "IndividualPartnerLists": individualPartnerLists,
      };

  static List<ParticipantScanDetails> listFromJson(List<dynamic>? json) {
    return json == null
        ? <ParticipantScanDetails>[]
        : json.map((value) => ParticipantScanDetails.fromJson(value)).toList();
  }
}

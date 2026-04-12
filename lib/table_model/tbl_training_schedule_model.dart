class TblTrainingSchedule {
  String? scheduleGuid;
  String? communicationYear;
  String? year;
  String? communicationEstablishment;
  String? trainingApproach;
  String? trainingType;
  String? trainingName;
  String? typeOfGroup;
  String? hostEstablishment;
  String? participantEstablishment;
  String? participantEstablishmentName;
  String? modeOfTraining;
  String? duration;
  String? firstDate;
  String? lastDate;
  String? mediumofInstruction;
  String? mediumofInstructionName;
  String? trainingTheme;
  String? topicsCovered;
  String? topicsCoveredName;
  String? trainer;
  String? trainerName;
  String? otherTheme;
  String? preSurveyId;
  String? postSurveyId;
  String? feedbackSurveyId;
  int? active;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  int? isEdited;
  String? UserId;

  String? StartTime;
  String? EndTime;
  int? stateId;
  String? districtId;
  String? blockId;
  String? isParticipant;
  String? participantStateId;
  String? participantDistrictId;
  String? participantBlockId;
  String? ministryId;

  TblTrainingSchedule({
    this.scheduleGuid,
    this.communicationYear,
    this.year,
    this.communicationEstablishment,
    this.trainingApproach,
    this.trainingType,
    this.trainingName,
    this.typeOfGroup,
    this.hostEstablishment,
    this.participantEstablishment,
    this.participantEstablishmentName,
    this.modeOfTraining,
    this.duration,
    this.firstDate,
    this.lastDate,
    this.mediumofInstruction,
    this.mediumofInstructionName,
    this.trainingTheme,
    this.topicsCovered,
    this.topicsCoveredName,
    this.trainer,
    this.trainerName,
    this.otherTheme,
    this.preSurveyId,
    this.postSurveyId,
    this.feedbackSurveyId,
    this.active,
    this.createdBy,
    this.createdOn,
    this.updatedOn,
    this.updatedBy,
    this.isEdited,
    this.UserId,
    this.StartTime,
    this.EndTime,
    this.stateId,
    this.districtId,
    this.blockId,
    this.isParticipant,
    this.participantStateId,
    this.participantDistrictId,
    this.participantBlockId,
    this.ministryId,
  });

  factory TblTrainingSchedule.fromJson(Map<String, dynamic> json) {
    return TblTrainingSchedule(
      scheduleGuid: json['ScheduleGuid'],
      communicationYear: json['CommunicationYear'],
      year: json['Year'],
      communicationEstablishment: json['CommunicationEstablishment'],
      trainingApproach: json['TrainingApproach'],
      trainingType: json['TrainingType'],
      trainingName: json['TrainingName'],
      typeOfGroup: json['TypeOfGroup'],
      hostEstablishment: json['HostEstablishment'],
      participantEstablishment: json['ParticipantEstablishment'],
      participantEstablishmentName: json['ParticipantEstablishmentName'],
      modeOfTraining: json['ModeOfTraining'],
      duration: json['Duration'],
      firstDate: json['FirstDate'],
      lastDate: json['LastDate'],
      mediumofInstruction: json['MediumofInstruction'],
      mediumofInstructionName: json['MediumofInstructionName'],
      trainingTheme: json['TrainingTheme'],
      topicsCovered: json['TopicsCovered'],
      topicsCoveredName: json['TopicsCoveredName'],
      trainer: json['Trainer'],
      trainerName: json['TrainerName'],
      otherTheme: json['OtherTheme'],
      preSurveyId: json['PreSurveyId'],
      postSurveyId: json['PostSurveyId'],
      feedbackSurveyId: json['FeedbackSurveyId'],
      active: json['Active'],
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedOn: json['UpdatedOn'],
      updatedBy: json['UpdatedBy'],
      isEdited: json['IsEdited'],
      UserId: json['UserId'],
      StartTime: json['StartTime'],
      EndTime: json['EndTime'],
      stateId: json['StateId'],
      districtId: json['DistrictId'],
      blockId: json['BlockId'],
      isParticipant: json["IsParticipant"],
      participantStateId: json["ParticipantStateId"],
      participantDistrictId: json["ParticipantDistrictId"],
      participantBlockId: json["ParticipantBlockId"],
      ministryId: json["MinistryId"],
    );
  }
  Map<String, dynamic> toJson() => {
        'ScheduleGuid': scheduleGuid,
        'CommunicationYear': communicationYear,
        'Year': year,
        'CommunicationEstablishment': communicationEstablishment,
        'TrainingApproach': trainingApproach,
        'TrainingType': trainingType,
        'TrainingName': trainingName,
        'TypeOfGroup': typeOfGroup,
        'HostEstablishment': hostEstablishment,
        'ParticipantEstablishment': participantEstablishment,
        'ParticipantEstablishmentName': participantEstablishmentName,
        'ModeOfTraining': modeOfTraining,
        'Duration': duration,
        'FirstDate': firstDate,
        'LastDate': lastDate,
        'MediumofInstruction': mediumofInstruction,
        'MediumofInstructionName': mediumofInstructionName,
        'TrainingTheme': trainingTheme,
        'TopicsCovered': topicsCovered,
        'TopicsCoveredName': topicsCoveredName,
        'Trainer': trainer,
        'TrainerName': trainerName,
        'OtherTheme': otherTheme,
        'PreSurveyId': preSurveyId,
        'PostSurveyId': postSurveyId,
        'FeedbackSurveyId': feedbackSurveyId,
        'Active': active,
        'CreatedBy': createdBy,
        'CreatedOn': createdOn,
        'UpdatedOn': updatedOn,
        'UpdatedBy': updatedBy,
        'IsEdited': isEdited,
        'UserId': UserId,
        'StartTime': StartTime,
        'EndTime': EndTime,
        'StateId': stateId,
        'DistrictId': districtId,
        'BlockId': blockId,
        "IsParticipant": isParticipant,
        "ParticipantStateId": participantStateId,
        "ParticipantDistrictId": participantDistrictId,
        "ParticipantBlockId": participantBlockId,
        "MinistryId": ministryId,
      };
}

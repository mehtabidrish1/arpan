import 'package:arpan/models/training_registration.dart';

class TrainingSchedule {
  String? scheduleGuid;
  String? CommunicationYear;
  String? Year;
  String? CommunicationEstablishment;
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
  String? tainer;
  String? trainerName;
  String? otherTheme;
  String? preSurveyId;
  String? postSurveyId;
  String? feedbackSurveyId;
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
  List<TrainingRegistration>? trainingResgistration;

  TrainingSchedule(
      {this.scheduleGuid,
      this.CommunicationYear,
      this.Year,
      this.CommunicationEstablishment,
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
      this.tainer,
      this.trainerName,
      this.otherTheme,
      this.preSurveyId,
      this.postSurveyId,
      this.feedbackSurveyId,
      this.trainingResgistration,
      this.StartTime,
      this.EndTime,
      this.stateId,
      this.districtId,
      this.blockId,
      this.isParticipant,
      this.participantStateId,
      this.participantDistrictId,
      this.participantBlockId,
      this.ministryId});

  factory TrainingSchedule.fromJson(Map<String, dynamic> json) =>
      TrainingSchedule(
        scheduleGuid: json["ScheduleGuid"],
        CommunicationYear: json["CommunicationYear"],
        Year: json["Year"],
        CommunicationEstablishment: json["CommunicationEstablishment"],
        trainingApproach: json["TrainingApproach"],
        trainingType: json["TrainingType"],
        trainingName: json["TrainingName"],
        typeOfGroup: json["TypeOfGroup"],
        hostEstablishment: json["HostEstablishment"],
        participantEstablishment: json["ParticipantEstablishment"],
        participantEstablishmentName: json["ParticipantEstablishmentName"],
        modeOfTraining: json["ModeOfTraining"],
        duration: json["Duration"],
        firstDate: json["FirstDate"],
        lastDate: json["LastDate"],
        mediumofInstruction: json["MediumofInstruction"],
        mediumofInstructionName: json["MediumofInstructionName"],
        trainingTheme: json["TrainingTheme"],
        topicsCovered: json["TopicsCovered"],
        topicsCoveredName: json["TopicsCoveredName"],
        tainer: json["Trainer"],
        trainerName: json["TrainerName"],
        otherTheme: json["OtherTheme"],
        preSurveyId: json["PreSurveyId"],
        postSurveyId: json["PostSurveyId"],
        feedbackSurveyId: json["FeedbackSurveyId"],
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
        trainingResgistration:
            TrainingRegistration.listFromJson(json['TrainingResgistration']),
      );

  Map<String, dynamic> toJson() => {
        "ScheduleGuid": scheduleGuid,
        "TrainingApproach": trainingApproach,
        "TrainingType": trainingType,
        "TrainingName": trainingName,
        "TypeOfGroup": typeOfGroup,
        "HostEstablishment": hostEstablishment,
        "ParticipantEstablishment": participantEstablishment,
        "ParticipantEstablishmentName": participantEstablishmentName,
        "ModeOfTraining": modeOfTraining,
        "Duration": duration,
        "FirstDate": firstDate,
        "LastDate": lastDate,
        "MediumofInstruction": mediumofInstruction,
        "MediumofInstructionName": mediumofInstructionName,
        "TrainingTheme": trainingTheme,
        "TopicsCovered": topicsCovered,
        "TopicsCoveredName": topicsCoveredName,
        "Tainer": tainer,
        "TrainerName": trainerName,
        "OtherTheme": otherTheme,
        "PreSurveyId": preSurveyId,
        "PostSurveyId": postSurveyId,
        "FeedbackSurveyId": feedbackSurveyId,
        "TrainingResgistration": trainingResgistration,
        'CommunicationYear': CommunicationYear,
        'Year': Year,
        'CommunicationEstablishment': CommunicationEstablishment,
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

  static List<TrainingSchedule> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TrainingSchedule>[]
        : json.map((value) => TrainingSchedule.fromJson(value)).toList();
  }
}

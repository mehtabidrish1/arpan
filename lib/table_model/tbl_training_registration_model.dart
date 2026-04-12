class TblTrainingRegistration {
  String? registrationGuid;
  String? scheduleGuid;
  String? participantEstablishment;
  String? participantEstablishmentName;
  String? mediumOfInstruction;
  String? topicsCovered;
  String? topicsCoveredName;
  String? trainer;
  String? trainerName;
  String? trainingCode;
  String? batchNo;
  String? syncingDate;
  String? countryId;
  String? stateId;
  String? districtId;
  int? active;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  int? isEdited;
  String? Block;
  String? observer;
  String? observerName;
  int? noInternet = 0;
  String? notes;
  String? trainingDate;
  String? batchVenue;

  TblTrainingRegistration(
      {this.registrationGuid,
      this.scheduleGuid,
      this.participantEstablishment,
      this.participantEstablishmentName,
      this.mediumOfInstruction,
      this.topicsCovered,
      this.topicsCoveredName,
      this.trainer,
      this.trainerName,
      this.trainingCode,
      this.batchNo,
      this.syncingDate,
      this.countryId,
      this.stateId,
      this.districtId,
      this.active,
      this.createdBy,
      this.createdOn,
      this.updatedOn,
      this.updatedBy,
      this.isEdited,
      this.batchVenue,
      this.Block,
      this.observer,
      this.observerName,
      this.noInternet,
      this.notes,
      this.trainingDate});

  factory TblTrainingRegistration.fromJson(Map<String, dynamic> json) {
    return TblTrainingRegistration(
      observer: json['Observer'],
      observerName: json['ObserverName'],
      registrationGuid: json['RegistrationGuid'],
      scheduleGuid: json['ScheduleGuid'],
      participantEstablishment: json['ParticipantEstablishment'],
      participantEstablishmentName: json['ParticipantEstablishmentName'],
      mediumOfInstruction: json['MediumofInstruction'],
      topicsCovered: json['TopicsCovered'],
      topicsCoveredName: json['TopicsCoveredName'],
      trainer: json['Trainer'],
      trainerName: json['TrainerName'],
      trainingCode: json['TrainingCode'],
      batchNo: json['BatchNo'],
      syncingDate: json['syncingdate'],
      countryId: json['CountryId'],
      stateId: json['StateId'],
      districtId: json['DistrictId'],
      batchVenue: json['BatchVenue'],
      active: 1,
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedOn: json['UpdatedOn'],
      updatedBy: json['UpdatedBy'],
      isEdited: json['IsEdited'],
      Block: json['Block'],
      noInternet: json['NoInternet'],
      notes: json.containsKey('Notes') ? json['Notes'] : '',
      trainingDate:
          json.containsKey('TrainingDate') ? json['TrainingDate'] : '',
    );
  }

  Map<String, dynamic> toJson() => {
        "Observer": observer,
        "ObserverName": observerName,
        'RegistrationGuid': registrationGuid,
        'ScheduleGuid': scheduleGuid,
        'ParticipantEstablishment': participantEstablishment,
        'ParticipantEstablishmentName': participantEstablishmentName,
        'MediumofInstruction': mediumOfInstruction,
        'TopicsCovered': topicsCovered,
        'TopicsCoveredName': topicsCoveredName,
        'Trainer': trainer,
        'TrainerName': trainerName,
        'TrainingCode': trainingCode,
        'BatchNo': batchNo,
        'syncingdate': syncingDate,
        'CountryId': countryId,
        'StateId': stateId,
        'DistrictId': districtId,
        'Active': 1,
        'CreatedBy': createdBy,
        'CreatedOn': createdOn,
        'UpdatedOn': updatedOn,
        'UpdatedBy': updatedBy,
        'IsEdited': isEdited,
        'Block': Block,
        'BatchVenue': batchVenue,
        'NoInternet': noInternet,
        'Notes': notes ?? '',
        'TrainingDate': trainingDate ?? ''
      };
}

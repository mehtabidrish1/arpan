class TblTrainingHandHolding {
  String? handHoldingGuid;
  String? scheduleGuid;
  String? year;
  String? trainingName;
  String? handHoldingDate;
  String? handHoldingIntervention;
  String? topicsCovered;
  String? topicsCoveredName;
  String? facilitatorName;
  String? observer;
  String? observerName;
  String? sessionParticipant;
  String? remark;
  String? other;
  int? active;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  String? SyncingDate;
  int? isEdited;
  String? Module;
  String? ModuleName;
  String? attendingPseArpanTraining;
  String? modeOfGroupMeeting;
  String? attendanceParticipantMobileNo;
  String? stateId;
  String? districtId;
  String? blockId;

  TblTrainingHandHolding({
    this.handHoldingGuid,
    this.scheduleGuid,
    this.year,
    this.trainingName,
    this.handHoldingDate,
    this.handHoldingIntervention,
    this.topicsCovered,
    this.topicsCoveredName,
    this.facilitatorName,
    this.observer,
    this.observerName,
    this.sessionParticipant,
    this.remark,
    this.other,
    this.active,
    this.createdBy,
    this.createdOn,
    this.updatedOn,
    this.updatedBy,
    this.SyncingDate,
    this.isEdited,
    this.Module,
    this.ModuleName,
    this.attendingPseArpanTraining,
    this.modeOfGroupMeeting,
    this.attendanceParticipantMobileNo,
    this.stateId,
    this.districtId,
    this.blockId,
  });

  factory TblTrainingHandHolding.fromJson(Map<String, dynamic> json) {
    return TblTrainingHandHolding(
        handHoldingGuid: json['HandHoldingGuid'],
        scheduleGuid: json['ScheduleGuid'],
        year: json['Year'],
        trainingName: json['TrainingName'],
        handHoldingDate: json['HandHoldingDate'],
        handHoldingIntervention: json['HandHoldingIntervention'],
        topicsCovered: json['TopicsCovered'],
        topicsCoveredName: json['TopicsCoveredName'],
        facilitatorName: json['FacilitatorName'],
        observer: json['Observer'],
        observerName: json['ObserverName'],
        sessionParticipant: json['SessionParticipant'],
        remark: json['Remark'],
        other: json['Other'],
        active: json['Active'],
        createdBy: json['CreatedBy'],
        createdOn: json['CreatedOn'],
        updatedOn: json['UpdatedOn'],
        updatedBy: json['UpdatedBy'],
        SyncingDate: json.containsKey('SyncingDate') ? json['SyncingDate'] : '',
        isEdited: json.containsKey('isEdited') ? json['isEdited'] : 0,
        Module: json['Module'],
        ModuleName: json['ModuleName'],
        attendingPseArpanTraining: json["AttendingPSEArpanTraining"],
        modeOfGroupMeeting: json["ModeOfGroupMeeting"],
        attendanceParticipantMobileNo: json["AttendanceParticipantMobileNo"],
        stateId: json["StateId"],
        districtId: json["DistrictId"],
        blockId: json["BlockId"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'HandHoldingGuid': handHoldingGuid,
      'ScheduleGuid': scheduleGuid,
      'Year': year,
      'TrainingName': trainingName,
      'HandHoldingDate': handHoldingDate,
      'HandHoldingIntervention': handHoldingIntervention,
      'TopicsCovered': topicsCovered,
      'TopicsCoveredName': topicsCoveredName,
      'FacilitatorName': facilitatorName,
      'Observer': observer,
      'ObserverName': observerName,
      'SessionParticipant': sessionParticipant,
      'Remark': remark,
      'Other': other,
      'Active': active,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'UpdatedOn': updatedOn,
      'UpdatedBy': updatedBy,
      'SyncingDate': SyncingDate,
      'isEdited': isEdited,
      'Module': Module,
      'ModuleName': ModuleName,
      "AttendingPSEArpanTraining": attendingPseArpanTraining,
      "ModeOfGroupMeeting": modeOfGroupMeeting,
      "AttendanceParticipantMobileNo": attendanceParticipantMobileNo,
      "StateId": stateId,
      "DistrictId": districtId,
      "BlockId": blockId
    };
  }
}

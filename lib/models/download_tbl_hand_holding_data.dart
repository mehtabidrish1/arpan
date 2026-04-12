class HandHoldingData {
  final List<HandHoldingItem>? data;
  final bool succeeded;
  final dynamic errors;
  final dynamic message;
  final dynamic nextPage;

  HandHoldingData(
      {this.data,
      required this.succeeded,
      this.errors,
      this.message,
      this.nextPage});

  factory HandHoldingData.fromJson(Map<String, dynamic> json) {
    return HandHoldingData(
        data: (json['Data'] as List<dynamic>?)
            ?.map((e) => HandHoldingItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        succeeded: json['Succeeded'] as bool? ?? false,
        errors: json['Errors'],
        message: json['Message'],
        nextPage: json['NextPage']);
  }
}

class HandHoldingItem {
  final String handHoldingGuid;
  final String scheduleGuid;
  final String year;
  final String trainingName;
  final String handHoldingDate;
  final String handHoldingIntervention;
  final String topicsCovered;
  final String topicsCoveredName;
  final String facilitatorName;
  final String observer;
  final String observerName;
  final String sessionParticipant;
  final String module;
  final String moduleName;
  final String remark;
  final String other;
  final String createdOn;
  final String createdBy;
  final String updatedOn;
  final String updatedBy;
  final String attendingPseArpanTraining;
  final String modeOfGroupMeeting;
  final String stateId;
  final String districtId;
  final String blockId;
  final List<Attendance>? attendances;

  HandHoldingItem({
    required this.handHoldingGuid,
    required this.scheduleGuid,
    required this.year,
    required this.trainingName,
    required this.handHoldingDate,
    required this.handHoldingIntervention,
    required this.topicsCovered,
    required this.topicsCoveredName,
    required this.facilitatorName,
    required this.observer,
    required this.observerName,
    required this.sessionParticipant,
    required this.module,
    required this.moduleName,
    required this.remark,
    required this.other,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
    required this.attendingPseArpanTraining,
    required this.modeOfGroupMeeting,
    required this.stateId,
    required this.districtId,
    required this.blockId,
    required this.attendances,
  });

  factory HandHoldingItem.fromJson(Map<String, dynamic> json) {
    return HandHoldingItem(
      handHoldingGuid: json['HandHoldingGuid'] as String? ?? '',
      scheduleGuid: json['ScheduleGuid'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      trainingName: json['TrainingName'] as String? ?? '',
      handHoldingDate: json['HandHoldingDate'] as String? ?? '',
      handHoldingIntervention: json['HandHoldingIntervention'] as String? ?? '',
      topicsCovered: json['TopicsCovered'] as String? ?? '',
      topicsCoveredName: json['TopicsCoveredName'] as String? ?? '',
      facilitatorName: json['FacilitatorName'] as String? ?? '',
      observer: json['Observer'] as String? ?? '',
      observerName: json['ObserverName'] as String? ?? '',
      sessionParticipant: json['SessionParticipant'] as String? ?? '',
      module: json['Module'] as String? ?? '',
      moduleName: json['ModuleName'] as String? ?? '',
      remark: json['Remark'] as String? ?? '',
      other: json['Other'] as String? ?? '',
      createdOn: json['CreatedOn'] as String? ?? '',
      createdBy: json['CreatedBy'] as String? ?? '',
      updatedOn: json['UpdatedOn'] as String? ?? '',
      updatedBy: json['UpdatedBy'] as String? ?? '',
      attendingPseArpanTraining:
          json['AttendingPSEArpanTraining'] as String? ?? '',
      modeOfGroupMeeting: json['ModeOfGroupMeeting'] as String? ?? '',
      stateId: json['StateId'] as String? ?? '',
      districtId: json['DistrictId'] as String? ?? '',
      blockId: json['BlockId'] as String? ?? '',
      attendances: (json['Attendances'] as List<dynamic>?)
          ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Attendance {
  final String handHoldingGuid;
  final String mobileNo;
  final String createdOn;
  final String createdBy;
  final String updatedOn;
  final String updatedBy;

  Attendance({
    required this.handHoldingGuid,
    required this.mobileNo,
    required this.createdOn,
    required this.createdBy,
    required this.updatedOn,
    required this.updatedBy,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      handHoldingGuid: json['HandHoldingGuid'] as String? ?? '',
      mobileNo: json['MobileNo'] as String? ?? '',
      createdOn: json['CreatedOn'] as String? ?? '',
      createdBy: json['CreatedBy'] as String? ?? '',
      updatedOn: json['UpdatedOn'] as String? ?? '',
      updatedBy: json['UpdatedBy'] as String? ?? '',
    );
  }
}

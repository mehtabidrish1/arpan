import 'package:arpan/models/training_registration_session.dart';

import '../utils/common.dart';

class TrainingRegistration {
  String? registrationGuid;
  String? scheduleGuid;
  String? participantEstablishment;
  String? participantEstablishmentName;
  String? mediumofInstruction;
  String? topicsCovered;
  String? topicsCoveredName;
  String? trainer;
  String? trainerName;
  String? trainingCode;
  String? batchNo;
  int? countryId;
  int? stateId;
  int? districtId;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  String? syncingdate;
  String? observer;
  String? observerName;
  int? noInternet;

  // List<TrainingRegistrationSessionModel>? trainingRegistrationSession;
  int? IsEdited;
  String? Block;
  String? notes;
  String? trainingDate;
  String? batchVenue;

  TrainingRegistration(
      {this.registrationGuid,
      this.scheduleGuid,
      this.participantEstablishment,
      this.participantEstablishmentName,
      this.mediumofInstruction,
      this.topicsCovered,
      this.topicsCoveredName,
      this.trainer,
      this.trainerName,
      this.trainingCode,
      this.batchNo,
      this.countryId,
      this.stateId,
      this.districtId,
      this.createdBy,
      this.createdOn,
      this.updatedOn,
      this.updatedBy,
      this.syncingdate,
      // this.trainingRegistrationSession,
      this.IsEdited,
      this.Block,
      this.batchVenue,
      this.observer,
      this.observerName,
      this.noInternet,
      this.notes,
      this.trainingDate});

  factory TrainingRegistration.fromJson(Map<String, dynamic> json) =>
      TrainingRegistration(
        observer: json['Observer'],
        observerName: json['ObserverName'],
        registrationGuid: json["RegistrationGuid"],
        scheduleGuid: json["ScheduleGuid"],
        participantEstablishment: json["ParticipantEstablishment"],
        participantEstablishmentName: json["ParticipantEstablishmentName"],
        mediumofInstruction: json["MediumofInstruction"],
        topicsCovered: json["TopicsCovered"],
        topicsCoveredName: json["TopicsCoveredName"],
        trainer: json["Trainer"],
        trainerName: json["TrainerName"],
        trainingCode: json["TrainingCode"],
        batchNo: json["BatchNo"],
        countryId: json["CountryId"],
        stateId: json["StateId"],
        districtId: json["DistrictId"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        updatedOn: json["UpdatedOn"],
        updatedBy: json["UpdatedBy"],
        syncingdate: json["syncingdate"],
        batchVenue: json["BatchVenue"],
        // trainingRegistrationSession:
        //     TrainingRegistrationSessionModel.listFromJson(
        //         json['TrainingRegistrationSession']),
        IsEdited: json.containsKey('IsEdited') ? json['IsEdited'] : 0,
        Block: json.containsKey('Block') ? json['Block'] : '',
        noInternet: json.containsKey('NoInternet')
            ? json['NoInternet'] == true
                ? 1
                : 0
            : 0,
        notes: json.containsKey('Notes') ? json['Notes'] : '',
        trainingDate:
            json.containsKey('TrainingDate') ? json['TrainingDate'] : '',
      );

  Map<String, dynamic> toJson() => {
        "Observer": observer,
        "ObserverName": observerName,
        "RegistrationGuid": registrationGuid,
        "ScheduleGuid": scheduleGuid,
        "ParticipantEstablishment": participantEstablishment,
        "ParticipantEstablishmentName": participantEstablishmentName,
        "MediumofInstruction": mediumofInstruction,
        "TopicsCovered": topicsCovered,
        "TopicsCoveredName": topicsCoveredName,
        "Trainer": trainer,
        "TrainerName": trainerName,
        "TrainingCode": trainingCode,
        "BatchNo": batchNo,
        "CountryId": countryId,
        "StateId": stateId,
        "DistrictId": districtId,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn,
        "UpdatedOn": updatedOn,
        "UpdatedBy": updatedBy,
        "syncingdate": syncingdate,
        // "TrainingRegistrationSession": trainingRegistrationSession,
        'IsEdited': 0,
        'NoInternet': noInternet,
        'Notes': notes ?? '',
        'TrainingDate': trainingDate,
        'BatchVenue': batchVenue,
      };

  static List<TrainingRegistration> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TrainingRegistration>[]
        : json.map((value) => TrainingRegistration.fromJson(value)).toList();
  }
}

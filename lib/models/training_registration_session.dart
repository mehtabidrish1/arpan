class TrainingRegistrationSessionModel_old {
  String? registrationSessionGuid;
  String? registrationGuid;
  String? trainingSessionDate;
  String? trainingSessionHour;
  String? syncingDate;
  int? active;
  int? attendanceCount;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  int? IsEdited;
  String? notes;

  TrainingRegistrationSessionModel_old({
    this.registrationSessionGuid,
    this.registrationGuid,
    this.trainingSessionDate,
    this.trainingSessionHour,
    this.syncingDate,
    this.attendanceCount,
    this.active,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.IsEdited,
    this.notes,
  });

  factory TrainingRegistrationSessionModel_old.fromJson(
          Map<String, dynamic> json) =>
      TrainingRegistrationSessionModel_old(
        registrationSessionGuid: json["RegistrationSessionGuid"],
        registrationGuid: json["RegistrationGuid"],
        trainingSessionDate: json["TrainingSessionDate"],
        trainingSessionHour: json["TrainingSessionHour"],
        syncingDate: json["SyncingDate"],
        active: json["Active"],
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"],
        updatedBy: json["UpdatedBy"],
        updatedOn: json["UpdatedOn"],
        IsEdited: json.containsKey('IsEdited') ? json['IsEdited'] : 0,
        notes: json.containsKey('Notes') ? json['Notes'] : '',
      );

  Map<String, dynamic> toJson() => {
        "RegistrationSessionGuid": registrationSessionGuid,
        "RegistrationGuid": registrationGuid,
        "TrainingSessionDate": trainingSessionDate,
        "TrainingSessionHour": trainingSessionHour,
        "SyncingDate": syncingDate,
        "Active": active,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn,
        "UpdatedBy": updatedBy,
        "UpdatedOn": updatedOn,
        'IsEdited': IsEdited,
        'Notes': notes ?? '',
      };

  static List<TrainingRegistrationSessionModel_old> listFromJson(
      List<dynamic>? json) {
    return json == null
        ? <TrainingRegistrationSessionModel_old>[]
        : json
            .map((value) => TrainingRegistrationSessionModel_old.fromJson(value))
            .toList();
  }
}

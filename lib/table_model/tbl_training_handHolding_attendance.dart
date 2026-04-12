class TrainingHandHoldingAttendance {
  int? id=0;
  String? handHoldingGuid;
  String? mobileNo;
  String? createdBy;
  String? createdOn;
  String? updatedOn;
  String? updatedBy;
  int? isEdited;

  TrainingHandHoldingAttendance({
    this.id,
    this.handHoldingGuid,
    this.mobileNo,
    this.createdBy,
    this.createdOn,
    this.updatedOn,
    this.updatedBy,
    this.isEdited,
  });

  factory TrainingHandHoldingAttendance.fromJson(Map<String, dynamic> json) {
    return TrainingHandHoldingAttendance(
      id: json['ID']??0,
      handHoldingGuid: json['HandHoldingGuid'],
      mobileNo: json['MobileNo'],
      createdBy: json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedOn: json['UpdatedOn'],
      updatedBy: json['UpdatedBy'],
      isEdited: json.containsKey('isEdited') ? json['isEdited'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'HandHoldingGuid': handHoldingGuid,
      'MobileNo': mobileNo,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn,
      'UpdatedOn': updatedOn,
      'UpdatedBy': updatedBy,
      'isEdited': isEdited
    };
  }
}

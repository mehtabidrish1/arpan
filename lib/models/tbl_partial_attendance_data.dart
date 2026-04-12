class TblBatchPartialAttendanceData {
  TblBatchPartialAttendanceData({
    this.RegistrationGuid,
    this.MobileNo,
    this.ScheduleGuid,
    this.SyncDate,
    this.CreatedBy,
    this.CreatedOn,
    this.IsEdited,
  });

  String? RegistrationGuid;
  String? MobileNo;
  String? ScheduleGuid;
  String? SyncDate;
  String? CreatedBy;
  String? CreatedOn;
  int? IsEdited;

  factory TblBatchPartialAttendanceData.fromJson(Map<String, dynamic> json) =>
      TblBatchPartialAttendanceData(
        RegistrationGuid: json["RegistrationGuid"],
        MobileNo: json["MobileNo"],
        ScheduleGuid: json["ScheduleGuid"],
        SyncDate: json["SyncDate"],
        CreatedBy: json["CreatedBy"],
        CreatedOn: json["CreatedOn"],
        IsEdited: json["IsEdited"],
      );

  Map<String, dynamic> toJson() => {
        "RegistrationGuid": RegistrationGuid,
        "MobileNo": MobileNo,
        "ScheduleGuid": ScheduleGuid,
        "SyncDate": SyncDate,
        "CreatedBy": CreatedBy,
        "CreatedOn": CreatedOn,
        "IsEdited": IsEdited,
      };

  static List<TblBatchPartialAttendanceData> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TblBatchPartialAttendanceData>[]
        : json
            .map((value) => TblBatchPartialAttendanceData.fromJson(value))
            .toList();
  }
}

class TblAttendanceCount {
  TblAttendanceCount({
    this.TotalAttendanec,
    this.Type,
    this.SessionGuid,
    this.RegistrationGuid,
  });

  int? TotalAttendanec;
  String? Type;
  String? SessionGuid;
  String? RegistrationGuid;

  factory TblAttendanceCount.fromJson(Map<String, dynamic> json) =>
      TblAttendanceCount(
        TotalAttendanec: json["TotalAttendanec"],
        Type: json["Type"],
        SessionGuid:
            json.containsKey('SessionGuid') ? json["SessionGuid"]! : '',
        RegistrationGuid: json.containsKey('RegistrationGuid')
            ? json["RegistrationGuid"]!
            : '',
      );

  Map<String, dynamic> toJson() => {
        "TotalAttendanec": TotalAttendanec,
        "Type": Type,
        "SessionGuid": SessionGuid,
        "RegistrationGuid": RegistrationGuid,
      };
  static List<TblAttendanceCount> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TblAttendanceCount>[]
        : json.map((value) => TblAttendanceCount.fromJson(value)).toList();
  }
}

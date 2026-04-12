class TblBatchAttendanceData {
  TblBatchAttendanceData({
    this.RegistrationGuid,
    this.MobileNo,
    this.FullName,
  });

  String? RegistrationGuid;
  String? MobileNo;
  String? FullName;

  factory TblBatchAttendanceData.fromJson(Map<String, dynamic> json) =>
      TblBatchAttendanceData(
        RegistrationGuid: json["RegistrationGuid"],
        MobileNo: json["MobileNo"],
        FullName: json["FullName"],
      );

  Map<String, dynamic> toJson() => {
        "RegistrationGuid": RegistrationGuid,
        "MobileNo": MobileNo,
        "FullName": FullName,
      };

  static List<TblBatchAttendanceData> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TblBatchAttendanceData>[]
        : json.map((value) => TblBatchAttendanceData.fromJson(value)).toList();
  }
}

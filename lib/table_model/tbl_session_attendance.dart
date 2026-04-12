class TblSessionAttendance {
  TblSessionAttendance({
    this.ScheduleGuid,
    this.RegistrationGuid,
    this.phoneNo,
    this.IsEdited,
    this.latitude,
    this.longitude
  });

  String? ScheduleGuid;
  String? RegistrationGuid;
  String? phoneNo;
  String? latitude;
    String? longitude;

  int? IsEdited;
  factory TblSessionAttendance.fromJson(Map<String, dynamic> json) =>
      TblSessionAttendance(
        ScheduleGuid: json['ScheduleGuid'],
        RegistrationGuid: json['RegistrationGuid'],
        latitude:json.containsKey('Latitude')?json['Latitude']:'',
        longitude:json.containsKey('Longitude')?json['Longitude']:'',
       
        phoneNo: json.containsKey('phoneNo')
            ? json['phoneNo']
            : json.containsKey('MobileNo')
                ? json['MobileNo']
                : '',
        IsEdited: json.containsKey('IsEdited') ? json["IsEdited"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "ScheduleGuid": ScheduleGuid,
        "RegistrationGuid": RegistrationGuid,
        "Longitude":longitude,
        "Latitude":latitude,
     
        "phoneNo": phoneNo,
        'IsEdited': IsEdited,
      };
  static List<TblSessionAttendance> listFromJson(List<dynamic>? json) {
    return json == null
        ? <TblSessionAttendance>[]
        : json.map((value) => TblSessionAttendance.fromJson(value)).toList();
  }
}

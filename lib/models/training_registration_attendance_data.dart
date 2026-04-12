class TrainingRegistrationAttendanceDataModel {
  String? mobileNo;

  TrainingRegistrationAttendanceDataModel({this.mobileNo});

  TrainingRegistrationAttendanceDataModel.fromJson(Map<String, dynamic> json) {
    mobileNo = json['MobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> TrainingRegistrationAttendanceDataModel =
        <String, dynamic>{};
    TrainingRegistrationAttendanceDataModel['MobileNo'] = mobileNo;
    return TrainingRegistrationAttendanceDataModel;
  }
}

class ParticipantTrainingDetails {
  String? mobileNo;
  String? trainingDetail;
  String? RegistrationGuid;

  ParticipantTrainingDetails({this.mobileNo, this.trainingDetail});

  Map<String, dynamic> toMap() {
    return {
      'MobileNo': mobileNo,
      'trainingDetail': trainingDetail,
      'RegistrationGuid': RegistrationGuid
    };
  }

  ParticipantTrainingDetails.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    mobileNo = json["MobileNo"];
    trainingDetail = json["trainingDetail"];
    RegistrationGuid =
        json.containsKey('RegistrationGuid') ? json['RegistrationGuid'] : '';
  }

  Map<String, dynamic> toJson() {
    return {
      'MobileNo': mobileNo,
      'trainingDetail': trainingDetail,
      'RegistrationGuid': RegistrationGuid
    };
  }

  static List<ParticipantTrainingDetails> listFromJson(List<dynamic> json) {
    return json == null
        ? <ParticipantTrainingDetails>[]
        : json
            .map((value) => new ParticipantTrainingDetails.fromJson(value))
            .toList();
  }
}

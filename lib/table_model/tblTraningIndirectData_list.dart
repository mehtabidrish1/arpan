import 'dart:convert';

class TblTraningIndirectDataList {
  String? scheduleGuid;
  String? registrationGuid;
  String? sessionGuid;
  String? trainingName;
  String? trainingSessionDate;
  String? batchNo;
  String? trainingTheme;
  String? topicsCoveredName;
  String? trainerName;
  String? Mobileno;
  String? mscertEnabledFlag;
  String? firstDate;
  String? lastDate;
  List<dynamic>? trainingParticipant;

  TblTraningIndirectDataList(
      {this.scheduleGuid,
      this.registrationGuid,
      this.sessionGuid,
      this.trainingName,
      this.trainingSessionDate,
      this.batchNo,
      this.trainingTheme,
      this.topicsCoveredName,
      this.trainerName,
      this.Mobileno,
      this.mscertEnabledFlag,
      this.firstDate,
      this.lastDate,
      this.trainingParticipant});

  factory TblTraningIndirectDataList.fromJson(Map<String, dynamic> json) {
    return TblTraningIndirectDataList(
      scheduleGuid: json['ScheduleGuid'],
      registrationGuid: json['RegistrationGuid'],
      sessionGuid: json['SessionGuid'],
      trainingName: json['TrainingName'],
      trainingSessionDate: json['TrainingSessionDate'],
      batchNo: json['BatchNo'],
      trainingTheme: json['TrainingTheme'],
      topicsCoveredName: json['TopicsCoveredName'],
      trainerName: json['TrainerName'],
      Mobileno: json.containsKey('Mobileno') ? json['Mobileno'] : '',
      firstDate: json['FirstDate'],
      mscertEnabledFlag: json['MscertEnabledFlag'],
      lastDate: json['LastDate'],
      trainingParticipant: json['TrainingParticipant'] is String
          ? jsonDecode(
              json['TrainingParticipant']) // ✅ Decode if stored as JSON string
          : json['TrainingParticipant'], // ✅ Use directly if already a list
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ScheduleGuid': scheduleGuid,
      'RegistrationGuid': registrationGuid,
      'SessionGuid': sessionGuid,
      'TrainingName': trainingName,
      'TrainingSessionDate': trainingSessionDate,
      'BatchNo': batchNo,
      'TrainingTheme': trainingTheme,
      'TopicsCoveredName': topicsCoveredName,
      'TrainerName': trainerName,
      'Mobileno': Mobileno,
      'MscertEnabledFlag': mscertEnabledFlag,
      'FirstDate': firstDate,
      'LastDate': lastDate,
      'TrainingParticipant': jsonEncode(trainingParticipant),
    };
  }
}

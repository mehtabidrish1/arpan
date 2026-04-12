class TrainingParticipantAttendanceRequestBody {
  List<ParticipantAttendance>? participantAttendance;
    List<PartialAttendance>? partialAttendance;

  String? sessionGuid;
  String? scheduleGuid;
  String? registrationGuid;
  String? createdBy;

  TrainingParticipantAttendanceRequestBody(
      {
        this.participantAttendance,
      this.partialAttendance,
      this.sessionGuid,
      this.registrationGuid,
      this.scheduleGuid,this.createdBy});

  TrainingParticipantAttendanceRequestBody.fromJson(Map<String, dynamic> json) {
    if (json['ParticipantAttendance'] != null) {
      participantAttendance = <ParticipantAttendance>[];
      json['ParticipantAttendance'].forEach((v) {
        participantAttendance!.add(ParticipantAttendance.fromJson(v));
      });
    }
     if (json['PartialAttendance'] != null) {
      partialAttendance = <PartialAttendance>[];
      json['PartialAttendance'].forEach((v) {
        partialAttendance!.add(PartialAttendance.fromJson(v));
      });
    }
    sessionGuid = json['SessionGuid'];
    scheduleGuid = json['ScheduleGuid'];
    registrationGuid = json['RegistrationGuid'];
    createdBy=json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (participantAttendance != null) {
      data['ParticipantAttendance'] =
          participantAttendance!.map((v) => v.toJson()).toList();
    }
     if (partialAttendance != null) {
      data['PartialAttendance'] =
          partialAttendance!.map((v) => v.toJson()).toList();
    }
    data['SessionGuid'] = sessionGuid;
    data['ScheduleGuid'] = scheduleGuid;
    data['RegistrationGuid'] = registrationGuid;
    data['CreatedBy']=createdBy;
    return data;
  }
}

class ParticipantAttendance {
  String? mobileNo;
   String? latitude;
    String? longitude;

  ParticipantAttendance({this.mobileNo, this.latitude,
    this.longitude});

  ParticipantAttendance.fromJson(Map<String, dynamic> json) {
    mobileNo = json['MobileNo'];
     latitude=json.containsKey('Latitude')?json['Latitude']:'';
        longitude=json.containsKey('Longitude')?json['Longitude']:'';
       
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNo'] = mobileNo;
        data['Longitude'] = longitude;
    data['Latitude'] = latitude;

    return data;
  }
}
class PartialAttendance {
  String? mobileNo;
  

  PartialAttendance({this.mobileNo});

  PartialAttendance.fromJson(Map<String, dynamic> json) {
    mobileNo = json['MobileNo'];
         
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNo'] = mobileNo;
    
    return data;
  }
}

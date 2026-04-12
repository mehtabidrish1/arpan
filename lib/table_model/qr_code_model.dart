class QrCodeModel {
  String? scheduleGuid;
  String? registrationGuid;
  String? surveyId;
  String? trainerName;
  String? firstDate;
  String? lastDate;
  String? topicsCoveredName;
  String? trainingName;
  String? blockName;
  String? typeOfGroup;
  String? stateId;
  String? districtId;
  String? blockId;
  String? ministryId;
  List<IndividualPartnerList>? individualPartnerLists;

  QrCodeModel({
    this.scheduleGuid,
    this.registrationGuid,
    this.surveyId,
    this.trainerName,
    this.firstDate,
    this.lastDate,
    this.topicsCoveredName,
    this.trainingName,
    this.blockName,
    this.typeOfGroup,
    this.stateId,
    this.districtId,
    this.blockId,
    this.ministryId,
    this.individualPartnerLists,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
        scheduleGuid: json["ScheduleGuid"],
        registrationGuid: json["RegistrationGuid"],
        surveyId: json["SurveyId"],
        trainerName: json["TrainerName"],
        firstDate: json["FirstDate"],
        lastDate: json["LastDate"],
        topicsCoveredName: json["TopicsCoveredName"],
        trainingName: json["TrainingName"],
        blockName: json["BlockName"],
        typeOfGroup: json["TypeOfGroup"],
        stateId: json["StateId"],
        districtId: json["DistrictId"],
        blockId: json["BlockId"],
        ministryId: json["MinistryId"],
        individualPartnerLists: json["IndividualPartnerLists"] == null
            ? []
            : List<IndividualPartnerList>.from(json["IndividualPartnerLists"]!
                .map((x) => IndividualPartnerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ScheduleGuid": scheduleGuid,
        "RegistrationGuid": registrationGuid,
        "SurveyId": surveyId,
        "TrainerName": trainerName,
        "FirstDate": firstDate,
        "LastDate": lastDate,
        "TopicsCoveredName": topicsCoveredName,
        "TrainingName": trainingName,
        "BlockName": blockName,
        "TypeOfGroup": typeOfGroup,
        "StateId": stateId,
        "DistrictId": districtId,
        "BlockId": blockId,
        "MinistryId": ministryId,
        "IndividualPartnerLists": individualPartnerLists == null
            ? []
            : List<dynamic>.from(
                individualPartnerLists!.map((x) => x.toJson())),
      };
}
// import 'dart:convert';

// QrCodeModel qrCodeModelFromJson(String str) => QrCodeModel.fromJson(json.decode(str));

// String qrCodeModelToJson(QrCodeModel data) => json.encode(data.toJson());

// class QrCodeModel {
//     String? scheduleGuid;
//     String? registrationGuid;
//     String? surveyId;
//     String? trainerName;
//     String? firstDate;
//     String? lastDate;
//     String? topicsCoveredName;
//     String? trainingName;
//     String? blockName;
//     String? typeOfGroup;
//     List<EstablishmentList>? establishmentLists;
//     List<IndividualPartnerList>? individualPartnerLists;

//     QrCodeModel({
//         this.scheduleGuid,
//         this.registrationGuid,
//         this.surveyId,
//         this.trainerName,
//         this.firstDate,
//         this.lastDate,
//         this.topicsCoveredName,
//         this.trainingName,
//         this.blockName,
//         this.typeOfGroup,
//         this.establishmentLists,
//         this.individualPartnerLists,
//     });

//     factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
//         scheduleGuid: json["ScheduleGuid"],
//         registrationGuid: json["RegistrationGuid"],
//         surveyId: json["SurveyId"],
//         trainerName: json["TrainerName"],
//         firstDate: json["FirstDate"],
//         lastDate: json["LastDate"],
//         topicsCoveredName: json["TopicsCoveredName"],
//         trainingName: json["TrainingName"],
//         blockName: json["BlockName"],
//         typeOfGroup: json["TypeOfGroup"],
//         establishmentLists: json["EstablishmentLists"] == null ? [] : List<EstablishmentList>.from(json["EstablishmentLists"]!.map((x) => EstablishmentList.fromJson(x))),
//         individualPartnerLists: json["IndividualPartnerLists"] == null ? [] : List<IndividualPartnerList>.from(json["IndividualPartnerLists"]!.map((x) => IndividualPartnerList.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "ScheduleGuid": scheduleGuid,
//         "RegistrationGuid": registrationGuid,
//         "SurveyId": surveyId,
//         "TrainerName": trainerName,
//         "FirstDate": firstDate,
//         "LastDate": lastDate,
//         "TopicsCoveredName": topicsCoveredName,
//         "TrainingName": trainingName,
//         "BlockName": blockName,
//         "TypeOfGroup": typeOfGroup,
//         "EstablishmentLists": establishmentLists == null ? [] : List<dynamic>.from(establishmentLists!.map((x) => x.toJson())),
//         "IndividualPartnerLists": individualPartnerLists == null ? [] : List<dynamic>.from(individualPartnerLists!.map((x) => x.toJson())),
//     };
// }

// class EstablishmentList {
//     String? establishmentCode;
//     String? establishmentName;
//     String? stateId;
//     String? districtId;
//     String? blockId;
//     String? pincode;

//     EstablishmentList({
//         this.establishmentCode,
//         this.establishmentName,
//         this.stateId,
//         this.districtId,
//         this.blockId,
//         this.pincode,
//     });

//     factory EstablishmentList.fromJson(Map<String, dynamic> json) => EstablishmentList(
//         establishmentCode: json["EstablishmentCode"],
//         establishmentName: json["EstablishmentName"],
//         stateId: json["StateId"],
//         districtId: json["DistrictId"],
//         blockId: json["BlockId"],
//         pincode: json["Pincode"],
//     );

//     Map<String, dynamic> toJson() => {
//         "EstablishmentCode": establishmentCode,
//         "EstablishmentName": establishmentName,
//         "StateId": stateId,
//         "DistrictId": districtId,
//         "BlockId": blockId,
//         "Pincode": pincode,
//     };
// }

class IndividualPartnerList {
  String? individualPartnerCode;
  String? partnerName;
  String? stateId;
  String? districtId;
  String? blockId;
  String? pincode;

  IndividualPartnerList({
    this.individualPartnerCode,
    this.partnerName,
    this.stateId,
    this.districtId,
    this.blockId,
    this.pincode,
  });

  factory IndividualPartnerList.fromJson(Map<String, dynamic> json) =>
      IndividualPartnerList(
        individualPartnerCode: json["IndividualPartnerCode"],
        partnerName: json["PartnerName"],
        stateId: json["StateId"],
        districtId: json["DistrictId"],
        blockId: json["BlockId"],
        pincode: json["Pincode"],
      );

  Map<String, dynamic> toJson() => {
        "IndividualPartnerCode": individualPartnerCode,
        "PartnerName": partnerName,
        "StateId": stateId,
        "DistrictId": districtId,
        "BlockId": blockId,
        "Pincode": pincode,
      };
}

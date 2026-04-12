import 'training_schedule_participant_model.dart';

class TrainigParticipantList {
  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  String? nextPage;
  bool? nextPageAvailabe;
  List<TrainingScheduleParticipantModel>? trainingScheduledParticipant;
  bool? succeeded;
  String? errors;
  String? message;

  TrainigParticipantList(
      {this.pageNumber,
      this.pageSize,
      this.fetchedRecords,
      this.totalRecords,
      this.nextPage,
      this.nextPageAvailabe,
      this.trainingScheduledParticipant,
      this.succeeded,
      this.errors,
      this.message});
  TrainigParticipantList.fromJson(Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    fetchedRecords = json['FetchedRecords'];
    totalRecords = json['TotalRecords'];
    nextPage = json['NextPage'];
    nextPageAvailabe = json['NextPageAvailabe'];
    trainingScheduledParticipant =
        TrainingScheduleParticipantModel.listFromJson(json['Data']);
    succeeded = json['Succeeded'];
    errors = json['Errors'];
    message = json['Message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['FetchedRecords'] = fetchedRecords;
    data['TotalRecords'] = totalRecords;
    data['NextPage'] = nextPage;
    data['NextPageAvailabe'] = nextPageAvailabe;
    data['Data'] = trainingScheduledParticipant;
    data['Succeeded'] = succeeded;
    data['Errors'] = errors;
    data['Message'] = message;
    return data;
  }
}

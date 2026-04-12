import 'package:arpan/models/training_schedule.dart';

import 'training_registration.dart';

class TrainingRegistrationList {
  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  String? nextPage;
  bool? nextPageAvailabe;
  List<TrainingSchedule>? trainingSchedule;
  bool? succeeded;
  String? errors;
  String? message;

  TrainingRegistrationList(
      {this.pageNumber,
      this.pageSize,
      this.fetchedRecords,
      this.totalRecords,
      this.nextPage,
      this.nextPageAvailabe,
      this.trainingSchedule,
      this.succeeded,
      this.errors,
      this.message});

  factory TrainingRegistrationList.fromJson(Map<String, dynamic> json) =>
      TrainingRegistrationList(
        pageNumber: json['PageNumber'],
        pageSize: json['PageSize'],
        fetchedRecords: json['FetchedRecords'],
        totalRecords: json['TotalRecords'],
        nextPage: json['NextPage'],
        nextPageAvailabe: json['NextPageAvailabe'],
        trainingSchedule: TrainingSchedule.listFromJson(json['Data']),
        succeeded: json['Succeeded'],
        errors: json['Errors'],
        message: json['Message'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['FetchedRecords'] = fetchedRecords;
    data['TotalRecords'] = totalRecords;
    data['NextPage'] = nextPage;
    data['NextPageAvailabe'] = nextPageAvailabe;
    data['Data'] = trainingSchedule;
    data['Succeeded'] = succeeded;
    data['Errors'] = errors;
    data['Message'] = message;
    return data;
  }
}

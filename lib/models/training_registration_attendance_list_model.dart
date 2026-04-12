import 'package:arpan/models/training_registration_attendance_data.dart';

class TrainingRegistrationAttendance {
  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  String? nextPage;
  bool? nextPageAvailabe;
  List<TrainingRegistrationAttendanceDataModel>?
      trainingRegistrationAttendanceDataModel;
  bool? succeeded;
  String? errors;
  String? message;

  TrainingRegistrationAttendance(
      {this.pageNumber,
      this.pageSize,
      this.fetchedRecords,
      this.totalRecords,
      this.nextPage,
      this.nextPageAvailabe,
      this.trainingRegistrationAttendanceDataModel,
      this.succeeded,
      this.errors,
      this.message});

  static List<TrainingRegistrationAttendance> listFromJson(
      List<dynamic>? json) {
    return json == null
        ? <TrainingRegistrationAttendance>[]
        : json
            .map((value) => TrainingRegistrationAttendance.fromJson(value))
            .toList();
  }

  TrainingRegistrationAttendance.fromJson(Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    fetchedRecords = json['FetchedRecords'];
    totalRecords = json['TotalRecords'];
    nextPage = json['NextPage'];
    nextPageAvailabe = json['NextPageAvailabe'];
    if (json['Data'] != null) {
      trainingRegistrationAttendanceDataModel =
          <TrainingRegistrationAttendanceDataModel>[];
      json['Data'].forEach((v) {
        trainingRegistrationAttendanceDataModel!
            .add( TrainingRegistrationAttendanceDataModel.fromJson(v));
      });
    }
    succeeded = json['Succeeded'];
    errors = json['Errors'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['FetchedRecords'] = fetchedRecords;
    data['TotalRecords'] = totalRecords;
    data['NextPage'] = nextPage;
    data['NextPageAvailabe'] = nextPageAvailabe;
    if (this.trainingRegistrationAttendanceDataModel != null) {
      data['Data'] = this
          .trainingRegistrationAttendanceDataModel!
          .map((v) => v.toJson())
          .toList();
    }
    data['Succeeded'] = succeeded;
    data['Errors'] = errors;
    data['Message'] = message;
    return data;
  }
}

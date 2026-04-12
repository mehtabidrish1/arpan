class TrainingParticipantRegistrationResponseModel {
  int? pageNumber;
  int? pageSize;
  int? fetchedRecords;
  int? totalRecords;
  String? nextPage;
  bool? nextPageAvailabe;
  List<Data>? data;
  bool? succeeded;
  String? errors;
  String? message;

  TrainingParticipantRegistrationResponseModel(
      {this.pageNumber,
      this.pageSize,
      this.fetchedRecords,
      this.totalRecords,
      this.nextPage,
      this.nextPageAvailabe,
      this.data,
      this.succeeded,
      this.errors,
      this.message});

  TrainingParticipantRegistrationResponseModel.fromJson(
      Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    pageSize = json['PageSize'];
    fetchedRecords = json['FetchedRecords'];
    totalRecords = json['TotalRecords'];
    nextPage = json['NextPage'];
    nextPageAvailabe = json['NextPageAvailabe'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(Data.fromJson(v));
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
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['Succeeded'] = succeeded;
    data['Errors'] = errors;
    data['Message'] = message;
    return data;
  }
}

class Data {
  String? registrationGuid;
  String? statusCode;
  String? statusMessage;
  String? syncdate;

  Data(
      {this.registrationGuid,
      this.statusCode,
      this.statusMessage,
      this.syncdate});

  Data.fromJson(Map<String, dynamic> json) {
    registrationGuid = json['RegistrationGuid'];
    statusCode = json['StatusCode'];
    statusMessage = json['StatusMessage'];
    syncdate = json['Syncdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RegistrationGuid'] = registrationGuid;
    data['StatusCode'] = statusCode;
    data['StatusMessage'] = statusMessage;
    data['Syncdate'] = syncdate;
    return data;
  }
}

class Success {
  String? response;
  int? code;

  Success({this.response, this.code});
}

class Failure {
  String? response;
  int? code;

  Failure({this.response, this.code});
}

class ResponseModel {
  Object? response;
  int? code;
  bool isSuccess;
  ResponseModel({this.code, this.response, required this.isSuccess});
}

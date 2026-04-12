import 'dart:convert';

import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';

import '../constants/response_codes.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainingParticipantRegistrationAPI {
  Future<ResponseModel> postTrainingParticipantRegistration(
      {Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.trainingParticipantRegistrationPath
        .replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
    var temp = jsonEncode(postBody);

    var response = await dynamicRequest.dynamicRequestMethod(
        url: path,
        queryParams: queryParams,
        requestType: RequestType.post,
        postBody: postBody);
    var data = response;
    try {
      if (data is Success) {
        var response = data.response!;

        /* TrainingParticipantRegistrationResponseModel
            trainingParticipantRegistrationList = dynamicRequest.deserialize(
                response, 'TrainingParticipantRegistrationResponseModel');
                */
        var success = true;
        var success_code = 200;
        // var response = data.response!;
        try {
          String resBatchsession = response.toString();
          var data = jsonDecode(resBatchsession);
          if (data != null && data.isNotEmpty) {
            String statusCode = data["StatusCode"];
            String statusMessage = data["StatusMessage"];
            // List<dynamic> data = jsonDecode(resBatchsession);
            // if (data != null && data.isNotEmpty) {
            //   String statusCode = data[0]["StatusCode"];
            //   String statusMessage = data[0]["StatusMessage"];
            if (statusCode == '200' ||
                statusMessage.toLowerCase() == 'Successfull'.toLowerCase()) {
              success = true;
              success_code = 200;
            } else {
              success = false;
              success_code = 400;
            }
          }
        } catch (error, stackTrace) {
          logError(error, stackTrace);
        }

        return ResponseModel(
            isSuccess: success, response: response, code: success_code);
      }
      if (data is Failure) {
        return ResponseModel(
            code: data.code, response: response, isSuccess: false);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return ResponseModel(
          code: data.code, response: response, isSuccess: false);
    }
    return ResponseModel(
        isSuccess: false,
        code: ResponseCodes.unknownError,
        response: LabelText.unknownError);
  }
}

Iterable<QueryParam> _convertParametersForCollectionFormat(
    String collectionFormat, String name, dynamic value) {
  var params = <QueryParam>[];

  // preconditions
  if (name == null || name.isEmpty || value == null) return params;

  if (value is! List) {
    params.add(new QueryParam(name, parameterToString(value)));
    return params;
  }

  List values = value as List;

  // get the collection format
  collectionFormat = (collectionFormat == null || collectionFormat.isEmpty)
      ? "csv"
      : collectionFormat; // default: csv

  if (collectionFormat == "multi") {
    return values.map((v) => new QueryParam(name, parameterToString(v)));
  }

  String delimiter = _delimiters[collectionFormat] ?? ",";

  params.add(new QueryParam(
      name, values.map((v) => parameterToString(v)).join(delimiter)));
  return params;
}

const _delimiters = const {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};

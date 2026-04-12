import 'dart:convert';

import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';
import 'package:arpan/utils/lableText.dart';

import '../constants/response_codes.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainerLoginAPI {
  Future<ResponseModel?> arpanTrainerLogin(
      {String? empId, String? password}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.trainerLoginPath.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

    if (empId != null) {
      queryParams
          .addAll(convertParametersForCollectionFormat("", "EmpID", empId));
    }
    if (password != null) {
      queryParams.addAll(
          convertParametersForCollectionFormat("", "password", password));
    }

    var response = await dynamicRequest.dynamicRequestMethod(
        url: path, queryParams: queryParams, requestType: RequestType.get);
    var data = response;

    if (data is Success) {
      Object? response;

      try {
        response = data.response.runtimeType == String
            ? data.response
            : json.decode(data.response!);
      } catch (error, stackTrace) {
        logError(error, stackTrace);
        response = json.decode(data.response!);
      }

      return ResponseModel(
          code: data.code, response: response, isSuccess: true);
    }
    if (data is Failure) {
      return ResponseModel(
          code: data.code, response: response, isSuccess: false);
    }
    return ResponseModel(
        isSuccess: false,
        code: ResponseCodes.unknownError,
        response: LabelText.unknownError);
  }
}

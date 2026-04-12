import 'dart:convert';
import 'dart:developer';

import '../constants/api_constants.dart';
import '../constants/enum_constants.dart';
import '../constants/response_codes.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';
import 'dynamic_response/dynamic_responses.dart';

class TrainingRegistrationSessionAPI {
  Future<ResponseModel> postTrainingRegistrationSession(
      {Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.AddTrainingRegistrationSession.replaceAll(
        "{format}", "json");

    List<QueryParam> queryParams = [];
    log(postBody.toString());

    var response = await dynamicRequest.dynamicRequestMethod(
        url: path,
        queryParams: queryParams,
        requestType: RequestType.post,
        postBody: postBody);
    var data = response;
    try {
      if (data is Success) {
        var success = true;
        var success_code = 200;
        var response = data.response!;
        try {
          String resBatchsession = response.toString();
          List<dynamic> data = jsonDecode(resBatchsession);
          if (data != null && data.isNotEmpty) {
            String statusCode = data[0]["StatusCode"];
            String statusMessage = data[0]["StatusMessage"];
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

  Future<ResponseModel> putTrainingRegistrationSession(
      {Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.UpdateTrainingRegistrationSession.replaceAll(
        "{format}", "json");

    List<QueryParam> queryParams = [];

    var response = await dynamicRequest.dynamicRequestMethod(
        url: path,
        queryParams: queryParams,
        requestType: RequestType.post,
        postBody: postBody);
    var data = response;
    try {
      if (data is Success) {
        var response = data.response!;

        return ResponseModel(
            isSuccess: true, response: response, code: data.code);
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

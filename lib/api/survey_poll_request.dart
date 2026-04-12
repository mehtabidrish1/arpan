import 'dart:convert';

import '../constants/api_constants.dart';
import '../constants/enum_constants.dart';
import '../constants/response_codes.dart';
import '../models/question_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';
import 'dynamic_response/dynamic_responses.dart';

class SurveyPollRequest {
  Future<ResponseModel> getSurveyPollData({String? regGuid,String? surveyId,int? pageNumber,int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.getSurveyPollResponse.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
   
   if (regGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "RegistrationGuid", regGuid));
    }
    if (surveyId != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "SurveyId", surveyId));
    }


    if (pageNumber != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "filter.pageNumber", pageNumber));
    }
    if (pageSize != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "filter.pageSize", pageSize));
    }

    var response = await dynamicRequest.dynamicRequestMethod(
        url: path, queryParams: queryParams, requestType: RequestType.get);
    var data = response;
    try {
      if (data is Success) {
        var response = data.response!;

        QuestionModel masterData =
            dynamicRequest.deserialize(response, 'QuestionModel');

        return ResponseModel(
            code: data.code, response: masterData, isSuccess: true);
      }
      if (data is Failure) {
        return ResponseModel(
            code: data.code, response: data.response, isSuccess: false);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return ResponseModel(
          code: data.code, response: error.toString(), isSuccess: false);
    }

    return ResponseModel(
        isSuccess: false,
        code: ResponseCodes.unknownError,
        response: LabelText.unknownError);
  }
}

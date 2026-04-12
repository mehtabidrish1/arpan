import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';

import '../constants/response_codes.dart';
import '../models/master_dropdown_model.dart';
import '../models/tblAttendance_count_model.dart';
import '../models/training_registration_list_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class AttendanceCountApi {
  Future<ResponseModel> getAttendanceCountList(
      {String? regGuid,
      int? pageNumber,
      int? pageSize,
      String? preSurveyId,
      String? postSurveyId,
      String? feedbackSurveyId}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.trainingAttendances.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
    if (regGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "RegistrationGuid", regGuid));
    }
    if (pageNumber != null) {
      queryParams.addAll(
          convertParametersForCollectionFormat("", "PreSurveyId", preSurveyId));
    }
    if (pageNumber != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "PostSurveyId", postSurveyId));
    }
    if (pageNumber != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "FeedBackSurveyId", feedbackSurveyId));
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

        AttendanceCountModel masterData =
            dynamicRequest.deserialize(response, 'AttendanceCountModel');

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

import 'dart:convert';

import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';
import 'package:arpan/models/participant_trainingRegistrationModel.dart';

import '../constants/response_codes.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class ParticipantTrainingRegistrationApi {
  Future<ResponseModel> getParticipantTrainingRegistration(
      {String? registrationGuid,
      String? scheduleGuid,
      String? mobileNo,
      int? pageNumber,
      int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.getParticipantTrainingRegistrationPath
        .replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
    if (scheduleGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "ScheduleGuid", scheduleGuid));
    }
    if (registrationGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "RegistrationGuid", registrationGuid));
    }
    if (mobileNo != null) {
      queryParams.addAll(
          convertParametersForCollectionFormat("", "MobileNo", mobileNo));
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

    if (data is Success) {
      ParticipantTrainingRegistrationModel
          participantTrainingRegistrationModel = dynamicRequest.deserialize(
              data.response!, 'ParticipantTrainingRegistrationModel');

      var success = true;
      var success_code = 200;
      var response = data.response!;
      try {
        String resBatchsession = response.toString();
        dynamic data = jsonDecode(resBatchsession);
        if (data != null && data.isNotEmpty) {
          bool statusCode = data["Succeeded"];
        //  String statusMessage = data["StatusMessage"];
          if (statusCode) {
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
          isSuccess: success,
          response: participantTrainingRegistrationModel,
          code: success_code);
      return ResponseModel(
          code: data.code,
          response: participantTrainingRegistrationModel,
          isSuccess: true);
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

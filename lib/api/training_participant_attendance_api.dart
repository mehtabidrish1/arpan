import 'dart:convert';

import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';

import '../constants/response_codes.dart';
import '../models/training_participant_attendance_response_model.dart';
import '../models/training_registration_list_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainingParticipantAttendanceAPI {
  Future<ResponseModel> postTrainingParticipantAttendance(
      {Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.trainingParticipantAttendancePath
        .replaceAll("{format}", "json");

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

        TrainingParticipantAttendanceResponseModel trainingRegistrationList =
            dynamicRequest.deserialize(
                response, 'TrainingParticipantAttendanceResponseModel');
        var success = true;
        var success_code = 200;
        //  var response = data.response!;
        try {
          String resBatchsession = response.toString();
          List<Data> data = trainingRegistrationList.data!;
          if (data != null && data.isNotEmpty) {
            String statusCode = data[0].statusCode!;
            String statusMessage = data[0].statusMessage!;
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
            isSuccess: success,
            response: trainingRegistrationList,
            code: success_code);
        return ResponseModel(
            isSuccess: true,
            response: trainingRegistrationList,
            code: data.code);
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

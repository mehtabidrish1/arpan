import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';

import '../constants/response_codes.dart';
import '../models/training_participant_list_model.dart';
import '../utils/lableText.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainingParticipantListApi {
  Future<ResponseModel> getTrainingParticipantList(
      {String? scheduleGuid,
      int? pageNumber,
      int? pageSize,
      String? mobileno}) async {
    DynamicRequest dynamicRequest = DynamicRequest();
    String path =
        ApiConstants.trainingParticipantListPath.replaceAll("{format}", "json");
    if (mobileno != null && mobileno.isNotEmpty) {
      path = ApiConstants.getParticipantInfo.replaceAll("{format}", "json");
    }

    List<QueryParam> queryParams = [];
    if (mobileno != null && mobileno.isNotEmpty) {
      queryParams.addAll(
          convertParametersForCollectionFormat("", "MobileNo", mobileno));
    }
    if (scheduleGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "ScheduleGuid", scheduleGuid));
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
      TrainigParticipantList trainingParticipantList =
          dynamicRequest.deserialize(data.response!, 'TrainingParticipantList');
      return ResponseModel(
          code: data.code, response: trainingParticipantList, isSuccess: true);
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

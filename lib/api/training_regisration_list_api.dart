import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';

import '../constants/response_codes.dart';
import '../models/training_registration_list_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainingRegistrationListApi {
  Future<ResponseModel> getTrainingRegistrationList(
      {String? trainerEmpId, int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.trainingRegistrationListPath
        .replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

    if (trainerEmpId != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "TrainerEmpId", trainerEmpId));
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

        TrainingRegistrationList trainingRegistrationList =
            dynamicRequest.deserialize(response, 'TrainingRegistrationList');

        return ResponseModel(
            code: data.code,
            response: trainingRegistrationList,
            isSuccess: true);
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

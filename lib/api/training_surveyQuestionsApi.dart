import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';
import 'package:arpan/models/training_surveyQuestionModel.dart';

import '../constants/response_codes.dart';
import '../utils/lableText.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class TrainingSurveyQuestionsApi {
  Future<ResponseModel> getTrainingSurveyQuestions(
      {String? surveyId, int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.trainingSurveyQuestionsPath.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

    if (surveyId != null) {
      queryParams.addAll(
          convertParametersForCollectionFormat("", "SurveyId", surveyId));
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
      TrainingSurveyQuestionModel trainingSurveyQuestionModel = dynamicRequest
          .deserialize(data.response!, 'TrainingSurveyQuestionModel');
      return ResponseModel(
          code: data.code,
          response: trainingSurveyQuestionModel,
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

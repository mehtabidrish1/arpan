import 'dart:convert';

import '../constants/api_constants.dart';
import '../constants/enum_constants.dart';
import '../constants/response_codes.dart';
import '../models/hand_holding_patricepent_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';
import 'dynamic_response/dynamic_responses.dart';

class HandHoldinApi {
  Future<ResponseModel> getHandHoldingParticepentList(
      {String? empid, int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.getHandHoldingNewRegistrationUser.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

    if (empid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "TrainerEmpId", empid));
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

        HandHoldingParicepentModel masterData =
            dynamicRequest.deserialize(response, 'HandHoldingParicepentModel');

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

  Future<ResponseModel> postHandHoldinData({Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.AddHandHoldingData.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

  Future<ResponseModel> putHandHoldinData({Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.UpdateHandHoldingData.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

  Future<ResponseModel> postHandHoldinAttendance({Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.AddHandHoldingAttendance.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

  Future<ResponseModel> postHandHoldingAddParticipantList(
      {Object? postBody}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.AddParticipantList.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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
}

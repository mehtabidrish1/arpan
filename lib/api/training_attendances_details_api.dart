import '../constants/api_constants.dart';
import '../constants/enum_constants.dart';
import '../constants/response_codes.dart';
import '../models/attendnace_details_model.dart';
import '../models/partial_attendnace_details_model.dart';
import '../models/tbl_partial_attendance_data.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';
import 'dynamic_response/dynamic_responses.dart';

class TrainingAttendancesDetailsApi{
 Future<ResponseModel> getAttendancesDetailList({String? trainerEmpId,String? regGuid,int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.trainingAttendancesDetails.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
     if (trainerEmpId != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "TrainerEmpId", trainerEmpId));
    }if (regGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "RegistrationGuid", regGuid));
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

        AttendanceDetailModel masterData =
            dynamicRequest.deserialize(response, 'AttendanceDetailModel');

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

  Future<ResponseModel> getPartialAttendancesDetailList({String? trainerEmpId,String? regGuid,int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.training_Partial_Attendance_Details.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];
     if (trainerEmpId != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "TrainerEmpId", trainerEmpId));
    }if (regGuid != null) {
      queryParams.addAll(convertParametersForCollectionFormat(
          "", "RegistrationGuid", regGuid));
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

        PartialAttendanceDetailModel masterData =
            dynamicRequest.deserialize(response, 'Training_Partial_Attendance_Details');

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
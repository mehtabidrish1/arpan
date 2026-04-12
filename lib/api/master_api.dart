import 'dart:convert';
import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/enum_constants.dart';
import 'package:arpan/models/teacherGradeMasterModel.dart';
import 'package:http/http.dart' as http;
import '../constants/response_codes.dart';
import '../models/TrainerEstablishmentList_model.dart';
import '../models/block_master_drop_down_model.dart';
import '../models/designation_master_drop_down_model.dart';
import '../models/district_master_drop_down_model.dart';
import '../models/individual_partner_model.dart';
import '../models/master_dropdown_model.dart';
import '../models/state_master_drop_down_model.dart';
import '../models/tbl_trainner_list.dart';
import '../models/training_hand_holding_module_model.dart';
import '../models/training_registration_list_model.dart';
import '../utils/lableText.dart';
import '../utils/log_files.dart';
import 'api_client.dart';
import 'dynamic_request/dynamic_request.dart';

class MasterApi {
  Future<ResponseModel> getMasterList({int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.masterDropdownData.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        MasterDropDownModel masterData =
            dynamicRequest.deserialize(response, 'MasterDropDownModel');

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

  Future<ResponseModel> getStateMasterList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.getTrainingState.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        StateMasterDropDownModel masterData =
            dynamicRequest.deserialize(response, 'StateMasterDropDownModel');

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

  Future<ResponseModel> getDistrictMasterList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.getTrainingDistrict.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        DistrictMasterDropDownModel masterData =
            dynamicRequest.deserialize(response, 'DistrictMasterDropDownModel');

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

  // Future<ResponseModel> getBlockMasterList(
  //     {int? pageNumber, int? pageSize}) async {
  //   DynamicRequest dynamicRequest = DynamicRequest();

  //   String path = ApiConstants.getTrainingBlock.replaceAll("{format}", "json");

  //   List<QueryParam> queryParams = [];

  //   if (pageNumber != null) {
  //     queryParams.addAll(convertParametersForCollectionFormat(
  //         "", "filter.pageNumber", pageNumber));
  //   }
  //   if (pageSize != null) {
  //     queryParams.addAll(convertParametersForCollectionFormat(
  //         "", "filter.pageSize", pageSize));
  //   }

  //   var response = await dynamicRequest.dynamicRequestMethod(
  //       url: path, queryParams: queryParams, requestType: RequestType.get);
  //   var data = response;
  //   try {
  //     if (data is Success) {
  //       var response = data.response!;

  //       BlockMasterModel masterData =
  //           dynamicRequest.deserialize(response, 'BlockMasterModel');

  //       return ResponseModel(
  //           code: data.code, response: masterData, isSuccess: true);
  //     }
  //     if (data is Failure) {
  //       return ResponseModel(
  //           code: data.code, response: data.response, isSuccess: false);
  //     }
  //   } catch (error, stackTrace) {
  //     logError(error, stackTrace);
  //     return ResponseModel(
  //         code: data.code, response: error.toString(), isSuccess: false);
  //   }

  //   return ResponseModel(
  //       isSuccess: false,
  //       code: ResponseCodes.unknownError,
  //       response: LabelText.unknownError);
  // }

  Future<ResponseModel> getBlockMasterListCompressed(
      {int? pageNumber, int? pageSize}) async {
    var queryParams = {
      if (pageNumber != null) 'pageNumber': '$pageNumber',
      if (pageSize != null) 'pageSize': '$pageSize',
    };
    var headers = {'Accept-Encoding': 'gzip'};
    final url = ApiConstants.basePath + ApiConstants.getTrainingBlockCompressed;
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(jsonString);
      final masterData = BlockMasterModel.fromJson(jsonResponse);
      return ResponseModel(
          code: response.statusCode, response: masterData, isSuccess: true);
    } else {
      return ResponseModel(
          code: response.statusCode, response: response.body, isSuccess: false);
    }
  }

  Future<ResponseModel> getTeacherGradeList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.getTeacherGrade.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        TeacherGradeMasterDropDownModel masterData = dynamicRequest.deserialize(
            response, 'TeacherGradeMasterDropDownModel');

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

  Future<ResponseModel> getDesignationMasterList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.getParticipantDesignation.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        DesignationMasterDropDownModel masterData = dynamicRequest.deserialize(
            response, 'DesignationMasterDropDownModel');

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

  Future<ResponseModel> getIndividualPartnerList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.getIndividualPartner.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        IndividualPartnerModel masterData =
            dynamicRequest.deserialize(response, 'IndividualPartnerModel');

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

  Future<ResponseModel> getTrainingHandHoldingModuleList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.TrainingHandHoldingModuleList.replaceAll(
        "{format}", "json");

    List<QueryParam> queryParams = [];

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

        TrainingHandHoldingModuleModel masterData = dynamicRequest.deserialize(
            response, 'TrainingHandHoldingModuleModel');

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

  Future<ResponseModel> getTrainerEstablishmentList(
      {int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path =
        ApiConstants.GetTrainerEstablishmentList.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        TrainerEstablishmentModel masterData =
            dynamicRequest.deserialize(response, 'TrainerEstablishmentModel');

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

  Future<ResponseModel> getTrainerList({int? pageNumber, int? pageSize}) async {
    DynamicRequest dynamicRequest = DynamicRequest();

    String path = ApiConstants.getTrainerList.replaceAll("{format}", "json");

    List<QueryParam> queryParams = [];

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

        TrainerList masterData =
            dynamicRequest.deserialize(response, 'TrainerList');

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

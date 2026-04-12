import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:arpan/api/api_client.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/constants/response_codes.dart';
import 'package:arpan/models/participant_trainingRegistrationModel.dart';
import 'package:arpan/models/teacherGradeMasterModel.dart';
import 'package:arpan/models/training_participant_attendance_response_model.dart';
import 'package:arpan/models/training_participant_list_model.dart';
import 'package:arpan/models/training_registration_list_model.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../constants/enum_constants.dart';
import '../../models/TrainerEstablishmentList_model.dart';
import '../../models/attendnace_details_model.dart';
import '../../models/batch_attendance_model.dart';
import '../../models/block_master_drop_down_model.dart';
import '../../models/designation_master_drop_down_model.dart';
import '../../models/district_master_drop_down_model.dart';
import '../../models/download_tbl_hand_holding_data.dart';
import '../../models/hand_holding_patricepent_model.dart';
import '../../models/individual_partner_model.dart';
import '../../models/master_dropdown_model.dart';
import '../../models/partial_attendnace_details_model.dart';
import '../../models/qrcode_masterModel.dart';
import '../../models/question_model.dart';
import '../../models/state_master_drop_down_model.dart';
import '../../models/tblAttendance_count_model.dart';
import '../../models/tblTblTraningIndirectDataAll.dart';
import '../../models/tbl_TblTraningIndirectDataList_model.dart';
import '../../models/tbl_partial_attendance_data.dart';
import '../../models/tbl_trainner_list.dart';
import '../../models/training_hand_holding_module_model.dart';
import '../../models/training_participant_registration_response_model.dart';
import '../../models/training_registration_attendance_list_model.dart';
import '../../models/training_surveyQuestionModel.dart';
import '../../models/training_surveyQuestionOptionsModel.dart';
import '../../utils/log_files.dart';
import '../dynamic_response/dynamic_responses.dart';

class DynamicRequest {
  Future<dynamic> dynamicRequestMethod(
      {required String url,
      RequestType requestType = RequestType.get,
      Iterable<QueryParam>? queryParams,
      Map<String, String>? headers,
      String token = "",
      Object? postBody}) async {
    final ApiClient _arpanClient = ApiClient(Client(), token);

    Iterable<String> ps = queryParams != null
        ? queryParams
            .where(
              (p) => p.value != null,
            )
            .map((p) => '${p.name}=${p.value}')
        : [];
    String queryString = ps.isNotEmpty ? '?' + ps.join('&') : '';
    url = ApiConstants.basePath + url + queryString;

    try {
      Response _response = await _arpanClient
          .request(
              requestType: requestType,
              url: url,
              body: postBody,
              headers: headers)
          .timeout(const Duration(seconds: 60));

      if (kDebugMode) {
        log(_response.statusCode.toString(), name: "request status Code");
        log(url, name: "request url");
        log(
          _response.body,
          name: "request body",
        );
      }
      if (_response.statusCode == ResponseCodes.successCode) {
        return Success(response: (_response.body), code: _response.statusCode);
      } else if (_response.statusCode == ResponseCodes.fileNotFoundCode ||
          _response.statusCode == ResponseCodes.internalServerErrorCode) {
        return Failure(code: _response.statusCode, response: _response.body);
      } else if (_response.statusCode == ResponseCodes.unauthorizedCode) {
        return Failure(code: _response.statusCode, response: _response.body);
      } else {
        return Failure(code: _response.statusCode, response: _response.body);
      }
    } on HttpException {
      return Failure(
          code: ResponseCodes.noInternet, response: LabelText.noInternetError);
    } on FormatException {
      return Failure(
          code: ResponseCodes.invalidValue,
          response: LabelText.internalServerError);
    } on SocketException {
      return Failure(
          code: ResponseCodes.socketException,
          response: LabelText.socketExceptionError);
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return Failure(
          code: ResponseCodes.unknownError, response: LabelText.unknownError);
    }
  }

  dynamic deserialize(
    String jsonVal,
    String targetType, {
    bool kIsWeb = false,
  }) {
    try {
      targetType = targetType.replaceAll(' ', '');

      if (targetType == 'String') return jsonVal;

      var decodedJson = json.decode(jsonVal);

      var responce = _deserialize(decodedJson, targetType, kIsWeb: kIsWeb);

      return responce;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return null;
    }
  }

  final RegExp? _RegList = new RegExp(r'^List<(.*)>$');
  final RegExp? _RegMap = new RegExp(r'^Map<String,(.*)>$');
  dynamic _deserialize(dynamic value, String targetType,
      {bool kIsWeb = false}) {
    try {
      switch (targetType) {
        case 'String':
          return '$value';
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'bool':
          return value is bool ? value : '$value'.toLowerCase() == 'true';
        case 'double':
          return value is double ? value : double.parse('$value');
        case 'TrainingRegistrationList':
          return TrainingRegistrationList.fromJson(value);
        case 'TrainingParticipantList':
          return TrainigParticipantList.fromJson(value);
        case 'TrainingParticipantAttendanceResponseModel':
          return TrainingParticipantAttendanceResponseModel.fromJson(value);
        case 'TrainingRegistrationAttendance':
          return TrainingRegistrationAttendance.fromJson(value);
        case 'TrainingParticipantRegistrationResponseModel':
          return TrainingParticipantRegistrationResponseModel.fromJson(value);
        case 'TrainingSurveyQuestionModel':
          return TrainingSurveyQuestionModel.fromJson(value);
        case 'TrainingSurveyQuestionOptionsModel':
          return TrainingSurveyQuestionOptionsModel.fromJson(value);
        case 'ParticipantTrainingRegistrationModel':
          return ParticipantTrainingRegistrationModel.fromJson(value);
        case 'MasterDropDownModel':
          return MasterDropDownModel.fromJson(value);
        case 'AttendanceCountModel':
          return AttendanceCountModel.fromJson(value);
        case 'DistrictMasterDropDownModel':
          return DistrictMasterDropDownModel.fromJson(value);
        case 'StateMasterDropDownModel':
          return StateMasterDropDownModel.fromJson(value);
        case 'TblTraningIndirectDataListModel':
          return TblTraningIndirectDataListModel.fromJson(value);
        case 'TblTraningIndirectDataAllModel':
          return TblTraningIndirectDataAllModel.fromJson(value);
        case 'HandHoldingParicepentModel':
          return HandHoldingParicepentModel.fromJson(value);
        case 'TrainingHandHoldingModuleModel':
          return TrainingHandHoldingModuleModel.fromJson(value);
        case 'TrainerEstablishmentModel':
          return TrainerEstablishmentModel.fromJson(value);
        case 'BatchAttendanceModel':
          return BatchAttendanceModel.fromJson(value);
        case 'BlockMasterModel':
          return BlockMasterModel.fromJson(value);
        case 'DesignationMasterDropDownModel':
          return DesignationMasterDropDownModel.fromJson(value);
        case 'IndividualPartnerModel':
          return IndividualPartnerModel.fromJson(value);
        case 'TrainerList':
          return TrainerList.fromJson(value);
        case 'AttendanceDetailModel':
          return AttendanceDetailModel.fromJson(value);
        case 'QuestionModel':
          return QuestionModel.fromJson(value);
        case 'HandHoldingData':
          return HandHoldingData.fromJson(value);
        case 'Training_Partial_Attendance_Details':
          return PartialAttendanceDetailModel.fromJson(value);
        case 'TeacherGradeMasterDropDownModel':
          return TeacherGradeMasterDropDownModel.fromJson(value);
        case 'QRcodeMasterModel':
          return QRcodeMasterModel.fromJson(value);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      throw new Failure(
        code: 500,
        response: 'Exception during deserialization.',
      );
    }
    throw new Failure(
        code: 500,
        response: 'Could not find a suitable class for deserialization');
  }
}

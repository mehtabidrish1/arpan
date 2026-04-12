import 'dart:convert';
import 'dart:io';

import 'package:arpan/models/indirectData_uploadImageModel.dart';
import 'package:intl/intl.dart';

import '../api/TblTraningIndirectDataList_api.dart';
import '../api/batch_partial_attendance_api.dart';
import '../api/dynamic_response/dynamic_responses.dart';
import '../api/hand_holding_apis.dart';
import '../api/indirectData_uploadImageApi.dart';
import '../api/survey_response_api.dart';
import '../api/training_participant_attendance_api.dart';
import '../api/training_participant_registration_api.dart';
import '../api/training_reg_api.dart';
import '../api/training_reg_session_api.dart';
import '../api/upload_image_api.dart';
import '../constants/secure_storage_keys.dart';
import '../database/dataProvider.dart';
import '../models/tbl_partial_attendance_data.dart';
import '../models/training_participant_attendance_request_body.dart';
import '../models/training_registration_session.dart';
import '../models/training_schedule_participant_model.dart';
import '../models/uploadImageModel.dart';
import '../screens/dashboard/participant_registration/model/participant_registration_post_model.dart';
import '../table_model/tbl_participant_scan_details.dart';
import '../table_model/tbl_session_attendance.dart';
import '../table_model/tbl_training_handHolding_attendance.dart';
import '../table_model/tbl_training_hand_holding.dart';
import '../table_model/tbl_training_registration_model.dart';
import '../table_model/tblsurvey_response.dart';
import '../table_model/training_indirect_data_model.dart';
import 'common.dart';

class UploadAllData {
  syncAllData() async {
    // await uploadSurveyData();
    await uploadOfflineSurveyData();
    await uploadBatch();

    await uploadParticepent();

    await uploadParticepentAttendance();
    await uploadIndirectData();
    await uploadIndirectDataImages();
    //await uploadPartialAttendance();
    await uploadHandHoldingRegistration();
    await uploadHanholdingAttendanceData();
    await uploadParticipentAttendance();
  }

  uploadBatch() async {
    var regListAll = <TblTrainingRegistration>[];
    regListAll = await DataProvider().getUploadTrainingRegistration();
    if (regListAll.isEmpty) {
      return;
    }

    for (var traingbatch in regListAll) {
      List<TblTrainingRegistration> regList = [];
      regList.add(traingbatch);

      String jsonBatch = jsonEncode(regList);
      var responseBatch;
      if (traingbatch.syncingDate != null &&
          traingbatch.syncingDate!.isNotEmpty) {
        responseBatch = await TrainingRegistrationAPI()
            .putTrainingRegistration(postBody: jsonDecode(jsonBatch));
      } else {
        responseBatch = await TrainingRegistrationAPI()
            .postTrainingRegistration(postBody: jsonDecode(jsonBatch));
      }
      if (responseBatch.isSuccess) {
        String resBatch = responseBatch.response.toString();
        List<dynamic> data = jsonDecode(resBatch);
        if (data != null && data.isNotEmpty) {
          for (var res in data) {
            var responseData = regList
                .where((element) =>
                    element.registrationGuid!.toLowerCase() ==
                    res['RegitrationGuid'].toString().toLowerCase())
                .first;
            if (responseData.syncingDate == null ||
                responseData.syncingDate!.isEmpty) {
              // responseData.batchNo = res['BatchNo'] ?? responseData.batchNo;
            }
            String dateTimeString = res['SyncingDate'];

            DateTime dateTime = DateTime.now();
            if (dateTimeString != null && dateTimeString.isNotEmpty) {
              dateTime = DateTime.parse(dateTimeString);
            }
            String syncingDate = DateFormat('yyyy-MM-dd').format(dateTime);
            responseData.syncingDate = syncingDate;
            responseData.isEdited = 0;
            await DataProvider().insertTrainingBatch(responseData);
          }
        }
      }
    }
  }

  uploadParticipentAttendance() async {
    List<ParticipantScanDetails> details =
        await DataProvider().getParticipantScanDetailsForUpload();
    if (details == null || details.isEmpty) {
      return;
    } else {
      for (var element in details) {
        var trainingListData = await DataProvider()
            .getTrainingParticipantWithMobile(mobileNo: element.mobileNo);
        if (trainingListData != null && trainingListData.isNotEmpty) {
          var particepentdetail = trainingListData[0];
          particepentdetail.scheduleGuid = element.scheduleGuid;
          // particepentdetail.particitantGuid = element.registrationGuid;
          await uploadpartiAttendance(particepentdetail, element);
        }
      }
    }
  }

  uploadpartiAttendance(
      particepentdetail, ParticipantScanDetails scanDetail) async {
    List<TrainingScheduleParticipantModel> regList = [];
    regList.add(particepentdetail);
    String jsonBatch = jsonEncode(regList);
    var obj = jsonDecode(jsonBatch);
    var response = await TrainingParticipantRegistrationAPI()
        .postTrainingParticipantRegistration(postBody: obj);
    if (response.isSuccess) {
      particepentdetail.isEdited = 0;
      scanDetail.isEdited = 0;
    }
//json.encode(data.toJson()

    //  await DataProvider().insertParticipent(particepentdetail);
    await DataProvider().insertOrUpdateParticepent(scanDetail);
  }

  uploadParticepent({String? mobileno}) async {
    var regParticipantList = <TrainingScheduleParticipantModel>[];
    if (mobileno != null && mobileno.isNotEmpty) {
      regParticipantList =
          await DataProvider().uploadParticipantList(mobileno: mobileno);
    }
    regParticipantList = await DataProvider().uploadParticipantList();
    if (regParticipantList.isEmpty) {
      return;
    }
    regParticipantList.forEach((element) async {
      var data = element;
      if(element.registrationGuid!='00000000-0000-0000-0000-000000000000'){
      //var aaa= List<ParticipantRegistrationPost>[];

      List<TrainingScheduleParticipantModel> regList = [];
      regList.add(data);
      String jsonBatch = jsonEncode(regList);
      var obj = jsonDecode(jsonBatch);
      var response = await TrainingParticipantRegistrationAPI()
          .postTrainingParticipantRegistration(postBody: obj);
      if (response.isSuccess) {
        element.isEdited = 0;
        await DataProvider().insertParticipent(element);
      }} else {
        await DataProvider().deleteState(element);
      }
    });
  }

  uploadParticepentAttendance() async {
    var userInfo = await UserInfo().getUserCredentials();
    var regParticipantAttenList = <TblSessionAttendance>[];
    List<TblBatchPartialAttendanceData> partialAttendanceList = [];
    CustomSecureStorage customSecureStorage = CustomSecureStorage();

    var mobileNo =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.phone);
    if (mobileNo == null || mobileNo.isEmpty) {
      mobileNo = '';
    }
    regParticipantAttenList =
        await DataProvider().uploadTrainingSessionAttendance();
    if (regParticipantAttenList.isEmpty) {
      return;
    }
    for (var trainingBatchsession in regParticipantAttenList) {
      var attendance = {};
      var ptattendance = {};

      var lat = {};
      var long = {};
      partialAttendanceList = await DataProvider()
          .getBatchPartialAttendanceList(
              trainingBatchsession.RegistrationGuid!);
      List<TblSessionAttendance> attenData = await DataProvider()
          .getTrainingSessionAttendance(trainingBatchsession.RegistrationGuid!);
      for (var element in attenData) {
        attendance[element.phoneNo] = true;
        lat[element.phoneNo] = element.latitude;
        long[element.phoneNo] = element.longitude;
      }
      for (var element in partialAttendanceList) {
        ptattendance[element.MobileNo] = true;
      }

      List<TrainingParticipantAttendanceRequestBody> postBody = [];
      List<ParticipantAttendance> attMobile = [];
      attendance.forEach((key, value) {
        attMobile.add(ParticipantAttendance(
            mobileNo: key,
            latitude: lat.containsKey(key) ? lat[key] : '',
            longitude: long.containsKey(key) ? long[key] : ''));
      });

      List<PartialAttendance> pt_attMobile = [];
      ptattendance.forEach((key, value) {
        pt_attMobile.add(PartialAttendance(
          mobileNo: key,
        ));
      });
      postBody.add(TrainingParticipantAttendanceRequestBody(
          participantAttendance: attMobile,
          partialAttendance: pt_attMobile,
          sessionGuid: trainingBatchsession.RegistrationGuid,
          registrationGuid: trainingBatchsession.RegistrationGuid,
          scheduleGuid: trainingBatchsession.ScheduleGuid,
          createdBy: userInfo['email'] ?? mobileNo));
      String jsonBatch = jsonEncode(postBody);
      ResponseModel responseModel = await TrainingParticipantAttendanceAPI()
          .postTrainingParticipantAttendance(postBody: jsonDecode(jsonBatch));
      if (responseModel.isSuccess) {
        await DataProvider()
            .updateUploadAttendance(trainingBatchsession.RegistrationGuid);
      }
    }
  }

  uploadPartialAttendance() async {
    var regParticipantAttenList = <TblBatchPartialAttendanceData>[];
    regParticipantAttenList =
        await DataProvider().uploadTrainingPartialAttendance();
    if (regParticipantAttenList.isEmpty) {
      return;
    }
    for (var trainingBatchsession in regParticipantAttenList) {
      var attendance = {};

      List<TblBatchPartialAttendanceData> dataList = await DataProvider()
          .getBatchPartialAttendanceList(trainingBatchsession.RegistrationGuid);
      if (dataList != null && dataList.isNotEmpty) {
        String jsonBatch = jsonEncode(dataList);
        var responseBatch = await BatchPartialAttendanceApi()
            .postPartialAttendance(postBody: jsonDecode(jsonBatch));
        if (responseBatch.isSuccess) {
          await DataProvider()
              .UpdatePartial_Attendance(trainingBatchsession.RegistrationGuid);
        }
      }
    }
  }

  uploadIndirectDataImages() async {
    var regIndirectImageList = <IndirectDataUploadImageModel>[];
    regIndirectImageList =
        await DataProvider().getIndirectUploadImageSessionList();
    if (regIndirectImageList.isEmpty) {
      return;
    }
    List<File> fileList = [];

    for (var indirectDataRegImages in regIndirectImageList) {
      fileList.clear();

      List<IndirectDataUploadImageModel> attenData = await DataProvider()
          .getIndirectDataImageForupload(
              indirectDataRegImages.indirectDataGuid!);
      for (var element in attenData) {
        var file = File(element.image!);
        fileList.add(file);
      }

      var isUpload = await IndirectDataUploadImageAPI().postImagesToserver(
          imageFiles: fileList,
          indirectDataGuid: indirectDataRegImages.indirectDataGuid!);
      if (isUpload) {
        await DataProvider().updateFlagOfIndirectUploadImage(
            indirectDataRegImages.indirectDataGuid!);
      }
    }
  }

  uploadSessionImages() async {
    var regSessionImageList = <UploadImageModel>[];
    regSessionImageList = await DataProvider().getUploadImageSessionList();
    if (regSessionImageList.isEmpty) {
      return;
    }
    List<File> fileList = [];

    for (var trainingBatchsessionimages in regSessionImageList) {
      fileList.clear();

      List<UploadImageModel> attenData = await DataProvider()
          .getImageForupload(trainingBatchsessionimages.registrationGuid!);
      for (var element in attenData) {
        var file = File(element.image!);
        fileList.add(file);
      }

      var isUpload = await UploadImageAPI().postImagesToserver(
          imageFiles: fileList,
          registrationGuid: trainingBatchsessionimages.registrationGuid!);
      if (isUpload) {
        await DataProvider().updateFlagOfUploadImage(
            trainingBatchsessionimages.registrationGuid!);
      }
    }
  }

  uploadHandHoldingRegistration() async {
    List<TblTrainingHandHolding> handHoldingData =
        await DataProvider().uploadHandholingRegistration();
    if (handHoldingData.isEmpty) {
      return;
    }

    for (var handholding in handHoldingData) {
      TblTrainingHandHolding regDetail = handholding;
      List<TblTrainingHandHolding> regList = [];
      regList.add(handholding);
      String jsonBatch = jsonEncode(regList);
      var responseBatch;

      if (handholding.SyncingDate != null &&
          handholding.SyncingDate!.isNotEmpty) {
        responseBatch = await HandHoldinApi()
            .putHandHoldinData(postBody: jsonDecode(jsonBatch));
      } else {
        responseBatch = await HandHoldinApi()
            .postHandHoldinData(postBody: jsonDecode(jsonBatch));
      }

      if (responseBatch.isSuccess) {
        String resBatchsession = responseBatch.response.toString();
        List<dynamic> data = jsonDecode(resBatchsession);
        if (data != null && data.isNotEmpty) {
          String dateTimeString = data[0]["SyncingDate"];
          DateTime dateTime = DateTime.now();
          if (dateTimeString != null && dateTimeString.isNotEmpty) {
            dateTime = DateTime.parse(dateTimeString);
          }
          String syncingDate = DateFormat('yyyy-MM-dd').format(dateTime);
          if (syncingDate.isNotEmpty) {
            regDetail.SyncingDate = syncingDate;
            regDetail.isEdited = 0;
            await DataProvider().saveHandHoldingData(regDetail);
          }
        }

        // return LabelText.success;
      }
    }
  }

  uploadHanholdingAttendanceData() async {
    var regParticipantAttenList = <TrainingHandHoldingAttendance>[];
    regParticipantAttenList = await DataProvider().uploadHandHoldAttendance();
    if (regParticipantAttenList.isEmpty) {
      return;
    }
    for (var handholding in regParticipantAttenList) {
      List<TrainingHandHoldingAttendance> allData = await DataProvider()
          .getHandHoldAttendance(handholding.handHoldingGuid!);

      String jsonBatch = jsonEncode(allData);
      var responseModel = await HandHoldinApi()
          .postHandHoldinAttendance(postBody: jsonDecode(jsonBatch));
      if (responseModel.isSuccess) {
        await DataProvider().updateHandHolingFlag(handholding.handHoldingGuid!);

        //  return LabelText.success;
      }
    }
  }

  uploadIndirectData() async {
    List<TrainingIndirectData> allIndirectData =
        await DataProvider().uploadindirctTraingingData();
    for (var trainingData in allIndirectData) {
      TrainingIndirectData regDetail = trainingData;
      List<TrainingIndirectData> regList = [];
      regList.add(trainingData);
      String jsonBatch = jsonEncode(regList);
      var responseBatch;

      if (trainingData.syncingDate != null &&
          trainingData.syncingDate!.isNotEmpty) {
        responseBatch = await TblTraningIndirectDataListModelApi()
            .putIndirecttrainingdata(postBody: jsonDecode(jsonBatch));
      } else {
        responseBatch = await TblTraningIndirectDataListModelApi()
            .postIndirecttrainingdata(postBody: jsonDecode(jsonBatch));
      }

      if (responseBatch.isSuccess) {
        String resBatchsession = responseBatch.response.toString();
        List<dynamic> data = jsonDecode(resBatchsession);
        if (data != null && data.isNotEmpty) {
          String dateTimeString = data[0]["SyncingDate"];
          DateTime dateTime = DateTime.now();
          if (dateTimeString != null && dateTimeString.isNotEmpty) {
            dateTime = DateTime.parse(dateTimeString);
          }
          String syncingDate = DateFormat('yyyy-MM-dd').format(dateTime);
          if (syncingDate.isNotEmpty) {
            regDetail.syncingDate = syncingDate;
            regDetail.IsEdited = 0;
            await DataProvider().saveIndirectTrainingData(regDetail);
          }
        }

        // return LabelText.success;
      }
    }
  }

  uploadOfflineSurveyData() async {
    var mobileNo = await CustomSecureStorage()
        .getSecureValues(key: SecureStorageKeys.phone);
    List<SurveyResponse> surveyResponses =
        await DataProvider().getSurveyDataOfflineForUpload(mobileNo);
    if (surveyResponses.isNotEmpty) {
      String jsonBatch = jsonEncode(surveyResponses);
      var response = await SurveyResponseAPI()
          .postSurveyResponse(postBody: jsonDecode(jsonBatch));
      if (response.isSuccess) {
        for (var element in surveyResponses) {
          element.isEdited = 0;
        }
        await DataProvider().insertSurveyData(surveyResponses, mobileNo!);
      }
    }
  }

  uploadSurveyData() async {
    List<ParticipantScanDetails> allData =
        await DataProvider().getParticipantOfflineRecord();
    if (allData != null && allData.isNotEmpty) {
      for (var element in allData) {
        await uploadSurvery(element);
      }
    }
  }

  uploadSurvery(ParticipantScanDetails element) async {
    var surveyIdList = element.surveyId?.split(",");
    var pre = false;
    var post = false;
    var feedback = false;
    List<SurveyResponse> surveyResponseData_Pre = await DataProvider()
        .getSurveyDataForUpload(
            surveyIdList?[0], element.mobileNo, element.registrationGuid);
    if (surveyResponseData_Pre != null && surveyResponseData_Pre.isNotEmpty) {
      String jsonBatch = jsonEncode(surveyResponseData_Pre);
      var response = await SurveyResponseAPI()
          .postSurveyResponse(postBody: jsonDecode(jsonBatch));
      if (response.isSuccess) {
        pre = true;
      }
    } else {
      pre = true;
    }

    List<SurveyResponse> surveyResponseData_Post = await DataProvider()
        .getSurveyDataForUpload(
            surveyIdList?[1], element.mobileNo, element.registrationGuid);

    if (surveyResponseData_Post != null && surveyResponseData_Post.isNotEmpty) {
      String jsonBatch = jsonEncode(surveyResponseData_Post);
      var response = await SurveyResponseAPI()
          .postSurveyResponse(postBody: jsonDecode(jsonBatch));
      if (response.isSuccess) {
        post = true;
      }
    } else {
      post = true;
    }
    List<SurveyResponse> surveyResponseData_Feedback = await DataProvider()
        .getSurveyDataForUpload(
            surveyIdList?[2], element.mobileNo, element.registrationGuid);
    if (surveyResponseData_Feedback != null &&
        surveyResponseData_Feedback.isNotEmpty) {
      String jsonBatch = jsonEncode(surveyResponseData_Feedback);
      var response = await SurveyResponseAPI()
          .postSurveyResponse(postBody: jsonDecode(jsonBatch));
      if (response.isSuccess) {
        feedback = true;
      }
    } else {
      feedback = true;
    }

    if (pre && post && feedback) {
      element.isEdited = 0;
      await DataProvider().insertOrUpdateParticepent(element);
    }
  }
}

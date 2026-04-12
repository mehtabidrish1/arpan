import 'dart:io';

import 'package:arpan/api/training_registration_attendance_api.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/models/teacherGradeMasterModel.dart';
import 'package:arpan/models/training_registration_attendance_list_model.dart';
import 'package:arpan/table_model/tbl_teacher_grade_model.dart';
import 'package:arpan/table_model/tbl_training_registration_model.dart';
import 'package:arpan/table_model/tbl_training_schedule_model.dart';
import 'package:arpan/utils/DownloadData.dart';
import 'package:arpan/utils/common.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/TblTraningIndirectDataList_api.dart';
import '../api/attendance_count_api.dart';
import '../api/batch_attendance_api.dart';
import '../api/dynamic_response/dynamic_responses.dart';
import '../api/hand_holding_apis.dart';
import '../api/handholding_data_api.dart';
import '../api/master_api.dart';
import '../api/survey_poll_request.dart';
import '../api/training_attendances_details_api.dart';
import '../api/training_participant_list_api.dart';
import '../api/training_regisration_list_api.dart';
import '../api/training_surveyQuestionOptionsApi.dart';
import '../api/training_surveyQuestionsApi.dart';
import '../database/dataProvider.dart';
import '../models/TrainerEstablishmentList_model.dart';
import '../models/attendnace_details_model.dart';
import '../models/batch_attendance_model.dart';
import '../models/block_master_drop_down_model.dart';
import '../models/designation_master_drop_down_model.dart';
import '../models/district_master_drop_down_model.dart';
import '../models/download_tbl_hand_holding_data.dart';
import '../models/hand_holding_patricepent_model.dart';
import '../models/individual_partner_model.dart';
import '../models/master_dropdown_model.dart';
import '../models/partial_attendnace_details_model.dart';
import '../models/question_model.dart';
import '../models/state_master_drop_down_model.dart';
import '../models/tblAttendance_count_model.dart';
import '../models/tblTblTraningIndirectDataAll.dart';
import '../models/tbl_TblTraningIndirectDataList_model.dart';
import '../models/tbl_batch_attendence_data.dart';
import '../models/tbl_partial_attendance_data.dart';
import '../models/tbl_trainner_list.dart';
import '../models/training_hand_holding_module_model.dart';
import '../models/training_participant_list_model.dart';
import '../models/training_registration.dart';
import '../models/training_registration_attendance_data.dart';
import '../models/training_registration_list_model.dart';
import '../models/training_registration_session.dart';
import '../models/training_schedule.dart';
import '../models/training_schedule_participant_model.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';
import '../table_model/tblAttendance_count.dart';
import '../table_model/tblTraningIndirectData_list.dart';
import '../table_model/tbl_IndividualPartner.dart';
import '../table_model/tbl_Training_HandHolding_Particepent.dart';
import '../table_model/tbl_block_model.dart';
import '../table_model/tbl_designation_model.dart';
import '../table_model/tbl_district_model.dart';
import '../table_model/tbl_master_model.dart';
import '../table_model/tbl_session_attendance.dart';
import '../table_model/tbl_state_model.dart';
import '../table_model/tbl_training_handHolding_attendance.dart';
import '../table_model/tbl_training_hand_holding.dart';
import '../table_model/training_indirect_data_model.dart';

import 'package:http/http.dart' as http;

import 'log_files.dart';

class DataDownload {
  final CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final DataProvider dataProvide = DataProvider();
  Future<bool> getTrainingRegistrationList() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 50;
    List<TrainingSchedule>? trainingSchedule = [];
    List<TrainingRegistration>? trainingRegistration = [];
    //  List<TrainingRegistrationSessionModel>? trainingRegistrationSession = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TrainingRegistrationList? isTrainingRegistrationList;
        ResponseModel responseModel =
            await TrainingRegistrationListApi().getTrainingRegistrationList(
          trainerEmpId: userInfo['email'],
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          isTrainingRegistrationList =
              responseModel.response as TrainingRegistrationList;

          if (isTrainingRegistrationList.errors == null) {
            List<TrainingSchedule> downloadSchedule =
                isTrainingRegistrationList.trainingSchedule!;
            trainingSchedule.addAll(downloadSchedule);
            for (TrainingSchedule el in downloadSchedule) {
              trainingRegistration.addAll(el.trainingResgistration!);
            }

            // Map<String, dynamic> schedule = data[i];
          }
          if (isTrainingRegistrationList.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 50;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (trainingSchedule != null && trainingSchedule.isNotEmpty) {
        //   await dataProvide.insertTrainingRegistration(trainingRegistration);
        List<TblTrainingSchedule> trainingSchedulemodel =
            convertrainingSchedule(trainingSchedule, userInfo['email']);
        await DataProvider().insertTrainingSchedule(trainingSchedulemodel);
        if (trainingRegistration != null && trainingRegistration.isNotEmpty) {
          List<TblTrainingRegistration> regData =
              convertRegData(trainingRegistration);
          await DataProvider().insertTrainingRegistration(regData);
        }

        for (var element1 in trainingSchedule) {
          await getTrainingParticipantList(
              trainingScheduleGuid: element1.scheduleGuid!);
          var regList = trainingRegistration
              .where((element) =>
                  element.scheduleGuid!.toLowerCase() ==
                  element1.scheduleGuid!.toLowerCase())
              .toList();
          if (regList != null && regList.isNotEmpty) {
            for (var element in regList) {
              await getAttendanceCount(
                  element.registrationGuid!,
                  element1.preSurveyId!,
                  element1.postSurveyId!,
                  element1.feedbackSurveyId!);
            }
          }

          //;
        }
        await downloadHandHoldingParticepent();
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadTblTraningIndirectDataList(
      String? mobile, String reportType) async {
    await DataProvider().deleteTblTraningIndirectDataList(mobile!);
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 100;
    List<TblTraningIndirectDataList>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TblTraningIndirectDataListModel? allMasterData;
        ResponseModel responseModel = await TblTraningIndirectDataListModelApi()
            .getTraningIndirectDataList(
          reportType: reportType,
          mobile: mobile,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as TblTraningIndirectDataListModel;

          if (allMasterData.errors == null) {
            List<TblTraningIndirectDataList> dataAll = allMasterData.data!;
            for (var element in dataAll) {
              element.Mobileno = mobile;

              masterData.add(element);
            }

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTraningIndirectDataList(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<String> downloadCertificate(
      String mobile, String schedGuid, bool isParticipantCertificate) async {
    String url = isParticipantCertificate
        ? "${ApiConstants.basePath}GetTrainingCertificate?mobileno=$mobile&ScheduleGuid=$schedGuid"
        : "${ApiConstants.basePath}GetIndirectDataCertificate?mobileno=$mobile&ScheduleGuid=$schedGuid";
    Directory? _directory = Directory("");

    _directory = await getApplicationDocumentsDirectory();
    await Directory(_directory.path).create(recursive: true);
    String savePath = '';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        savePath = _directory.path + '/$mobile$schedGuid.pdf';
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded and saved at: $savePath');
      } catch (error, stackTrace) {
        logError(error, stackTrace);
        print('File downloaded failed: $savePath');
      }
    } else {
      print('Failed to download file. Status code: ${response.statusCode}');
    }
    return savePath;
  }

  Future<bool> downloadTblTraningIndirectDataAll(String? mobile) async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 100;
    List<TrainingIndirectData>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TblTraningIndirectDataAllModel? allMasterData;
        ResponseModel responseModel =
            await TblTraningIndirectDataListModelApi().getTraningIndirectData(
          mobile: mobile,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as TblTraningIndirectDataAllModel;

          if (allMasterData.errors == null) {
            List<TrainingIndirectData> dataAll = allMasterData.data!;
            for (var element in dataAll) {
              element.phoneNo = mobile;

              masterData.add(element);
            }

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        for (var element in masterData) {
          await DataProvider().saveIndirectTrainingData(element);
        }
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getAttendanceCount(String regGuid, String preSurey,
      String postSurvey, String feedback) async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 100;
    List<TblAttendanceCount>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        AttendanceCountModel? allMasterData;
        ResponseModel responseModel = await AttendanceCountApi()
            .getAttendanceCountList(
                regGuid: regGuid,
                pageNumber: pageNumber,
                pageSize: pageSize,
                preSurveyId: preSurey,
                postSurveyId: postSurvey,
                feedbackSurveyId: feedback);
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as AttendanceCountModel;

          if (allMasterData.errors == null) {
            List<TblAttendanceCount> dataAll = allMasterData.data!;
            for (var element in dataAll) {
              element.RegistrationGuid = regGuid;
              masterData.add(element);
            }

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertAttendanceCount(masterData, regGuid);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getMasterData() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TblMasterModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        MasterDropDownModel? allMasterData;
        ResponseModel responseModel = await MasterApi().getMasterList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as MasterDropDownModel;

          if (allMasterData.errors == null) {
            List<TblMasterModel> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertMasterData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadBatchAttendance(String regGuid) async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TblBatchAttendanceData>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        BatchAttendanceModel? allMasterData;
        ResponseModel responseModel =
            await BatchAttendanceAPI().getBatchAttendanceData(
          regGuid: regGuid,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as BatchAttendanceModel;

          if (allMasterData.errors == null) {
            List<TblBatchAttendanceData> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertBatchAttendance(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadStateData() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 1500;
    List<TblStateModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        StateMasterDropDownModel? allMasterData;
        ResponseModel responseModel = await MasterApi().getStateMasterList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as StateMasterDropDownModel;

          if (allMasterData.errors == null) {
            List<TblStateModel> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 1500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertStateData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getDistrictData() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 1500;
    List<TblDistrictModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        DistrictMasterDropDownModel? allMasterData;
        ResponseModel responseModel = await MasterApi().getDistrictMasterList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as DistrictMasterDropDownModel;

          if (allMasterData.errors == null) {
            List<TblDistrictModel> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 1500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertDistrictData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getBlockData() async {
    int pageNumber = 1;
    int pageSize = 10000;
    List<BlockDatum>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        BlockMasterModel? allMasterData;
        // ResponseModel responseModel = await MasterApi().getBlockMasterList(
        //   pageNumber: pageNumber,
        //   pageSize: pageSize,
        // );
        ResponseModel responseModel =
            await MasterApi().getBlockMasterListCompressed(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as BlockMasterModel;

          if (allMasterData.errors == null) {
            List<BlockDatum> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 10000;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertBlockData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadTeacherGradeList() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 100;
    List<TblTeacherGradeModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TeacherGradeMasterDropDownModel? allMasterData;
        ResponseModel responseModel = await MasterApi().getTeacherGradeList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as TeacherGradeMasterDropDownModel;

          if (allMasterData.errors == null) {
            List<TblTeacherGradeModel> dataAll = allMasterData.data;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTeacherGrade(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getDesignationData() async {
    int pageNumber = 1;
    int pageSize = 500;
    List<TblDesignationModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        DesignationMasterDropDownModel? allMasterData;
        ResponseModel responseModel =
            await MasterApi().getDesignationMasterList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as DesignationMasterDropDownModel;

          if (allMasterData.errors == null) {
            List<TblDesignationModel> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertDesignationData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getIndividualPartnerData() async {
    int pageNumber = 1;
    int pageSize = 500;
    List<TblIndividualPartner>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        IndividualPartnerModel? allMasterData;
        ResponseModel responseModel =
            await MasterApi().getIndividualPartnerList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as IndividualPartnerModel;

          if (allMasterData.errors == null) {
            List<TblIndividualPartner> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertIndividualPartnerData(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getTrainingHandHoldingList() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TblTrainingHandHolding>? masterData = [];
    List<TrainingHandHoldingAttendance>? attendanceData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        HandHoldingData? allMasterData;
        ResponseModel responseModel =
            await HandHoldingDataApi().getHandHoldingList(
          tempId: userInfo['email'],
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as HandHoldingData;

          if (allMasterData.errors == null) {
            List<HandHoldingItem> dataAll = allMasterData.data!;
            for (var element in dataAll) {
              List<Attendance>? attendances = element.attendances;
              for (var element1 in attendances!) {
                TrainingHandHoldingAttendance attendance =
                    convertAttendanceModel(element1);
                if (attendance != null) {
                  attendanceData.add(attendance);
                }
              }
              TblTrainingHandHolding handholing = convertHandHolding(element);
              if (handholing != null) {
                masterData.add(handholing);
              }
            }
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        for (var element in masterData) {
          await DataProvider().saveHandHoldingData(element);
        }
        for (var element in attendanceData) {
          await DataProvider().saveHandHoldingDataAttendance(element);
        }
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getTrainingHandHoldingModuleList() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TrainingHandHoldingModuleData>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TrainingHandHoldingModuleModel? allMasterData;
        ResponseModel responseModel =
            await MasterApi().getTrainingHandHoldingModuleList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as TrainingHandHoldingModuleModel;

          if (allMasterData.errors == null) {
            List<TrainingHandHoldingModuleData> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTrainingHandHoldingModuleList(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadTrainerEstablishmentList() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TrainerEstablishmentDatum>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TrainerEstablishmentModel? allMasterData;
        ResponseModel responseModel =
            await MasterApi().getTrainerEstablishmentList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as TrainerEstablishmentModel;

          if (allMasterData.errors == null) {
            List<TrainerEstablishmentDatum> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTrainerEstablishmentList(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadAttendceDetailList({String? regGuid}) async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TblSessionAttendance>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        AttendanceDetailModel? allMasterData;
        ResponseModel responseModel =
            await TrainingAttendancesDetailsApi().getAttendancesDetailList(
          trainerEmpId: userInfo['email'],
          regGuid: regGuid,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as AttendanceDetailModel;

          if (allMasterData.errors == null) {
            List<TblSessionAttendance> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTrainingSessionAttendanceList(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getPartialAttendancesDetailList({String? regGuid}) async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TblBatchPartialAttendanceData>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        PartialAttendanceDetailModel? allMasterData;
        ResponseModel responseModel = await TrainingAttendancesDetailsApi()
            .getPartialAttendancesDetailList(
          trainerEmpId: userInfo['email'],
          regGuid: regGuid,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData =
              responseModel.response as PartialAttendanceDetailModel;

          if (allMasterData.errors == null) {
            List<TblBatchPartialAttendanceData> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        if (regGuid != null) {
          await DataProvider().insertPartial_Attendance(masterData, regGuid);
        } else {
          await DataProvider().insertPartial_AttendanceDownload(masterData);
        }
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> downloadTrainerList() async {
    // var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 500;
    List<TrainerModel>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        TrainerList? allMasterData;
        ResponseModel responseModel = await MasterApi().getTrainerList(
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as TrainerList;

          if (allMasterData.errors == null) {
            List<TrainerModel> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        await DataProvider().insertTrainerList(masterData);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<bool> getTrainingParticipantList(
      {String? trainingScheduleGuid, String? mobileno}) async {
    int pageNumber = 1;
    int pageSize = 100;
    List<TrainingScheduleParticipantModel>? trainingParticipant = [];
    bool shouldLoop = false;
    // List<TblTrainingRegistration> trainingRegistrationList = [];
    try {
      //  trainingRegistrationList = await dataProvide.getTrainingRegistration();

      while (!shouldLoop) {
        TrainigParticipantList? isTrainingParticipantList;
        var responseModel =
            await TrainingParticipantListApi().getTrainingParticipantList(
          scheduleGuid: trainingScheduleGuid,
          pageNumber: pageNumber,
          pageSize: pageSize,
          mobileno: mobileno,
        );
        if (responseModel.isSuccess) {
          isTrainingParticipantList =
              responseModel.response as TrainigParticipantList;
          if (isTrainingParticipantList.errors == null) {
            trainingParticipant = [
              ...trainingParticipant!,
              ...isTrainingParticipantList.trainingScheduledParticipant!
            ];

            isTrainingParticipantList.trainingScheduledParticipant!;
          }
          if (isTrainingParticipantList.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }

      if (trainingParticipant != null && trainingParticipant.isNotEmpty) {
        await dataProvide.insertTrainingParticipant(trainingParticipant);
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  getTrainingRegistrationAttendanceList(String trainingScheduleGuid) async {
    int pageNumber = 1;
    int pageSize = 100;
    List<TrainingRegistrationAttendanceDataModel>?
        trainingRegistrationAttendanceData = [];
    bool shouldLoop = false;
    // List<TblTrainingRegistration> trainingRegistrationList = [];
    List<TrainingScheduleParticipantModel> trainingParticipantList;
    try {
      // trainingRegistrationList = await dataProvide.getTrainingRegistration();
      trainingParticipantList = await dataProvide.getTrainingParticipant(
          scheduledGuid: trainingScheduleGuid);

      while (!shouldLoop) {
        TrainingRegistrationAttendance?
            istrainingRegistrationAttendanceDataList;
        var responseModel = await TrainingRegistrationAttendanceApi()
            .getTrainingRegistrationAttendance(
          registrationGuid: trainingScheduleGuid,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          istrainingRegistrationAttendanceDataList =
              responseModel.response as TrainingRegistrationAttendance;
          if (istrainingRegistrationAttendanceDataList.errors == null) {
            trainingRegistrationAttendanceData = [
              ...trainingRegistrationAttendanceData!,
              ...istrainingRegistrationAttendanceDataList
                  .trainingRegistrationAttendanceDataModel!,
            ];
            // trainingParticipant = [
            //   ...trainingParticipant!,
            //   ...isTrainingParticipantList.trainingScheduledParticipant!
            // ];

            // isTrainingParticipantList.trainingScheduledParticipant!;
          }
          if (istrainingRegistrationAttendanceDataList.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }

      // if (trainingParticipant != null && trainingParticipant.isNotEmpty) {
      //   await dataProvide.insertTrainingParticipant(trainingParticipant);
      //   return true;
      // }
      List<TrainingScheduleParticipantModel>
          currentTrainingScheduleParticipantModel = [];
      if (trainingRegistrationAttendanceData != null &&
          trainingRegistrationAttendanceData.isNotEmpty) {
        for (var eachAttendance in trainingRegistrationAttendanceData) {
          List<TrainingScheduleParticipantModel> trainingParticipantListTemp =
              trainingParticipantList
                  .where(
                    (element) =>
                        element.phoneNo.toString() ==
                        eachAttendance.mobileNo.toString(),
                  )
                  .toList();
          currentTrainingScheduleParticipantModel = [
            ...currentTrainingScheduleParticipantModel,
            ...trainingParticipantListTemp
          ];
        }
      }
      for (var participant in currentTrainingScheduleParticipantModel) {
        // participant.isAttendanceMarked = true;
        await dataProvide.updateParticipant(participant);
      }

      return true;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }

  Future<void> downloadTrainingSurveyQuestions(String surveyIdval) async {
    List<TrainingSurveyQuestionDatum> trainingSurveyQuestionList = [];
    TrainingSurveyQuestionModel trainingSurveyQuestionModel;
    var responseModel = await TrainingSurveyQuestionsApi()
        .getTrainingSurveyQuestions(surveyId: surveyIdval.toString());
    if (responseModel.isSuccess) {
      trainingSurveyQuestionModel =
          responseModel.response as TrainingSurveyQuestionModel;
      if (trainingSurveyQuestionModel.errors == null) {
        trainingSurveyQuestionList = [
          ...trainingSurveyQuestionList,
          ...trainingSurveyQuestionModel.data!
        ];
      }
      if (trainingSurveyQuestionList.isNotEmpty) {
        await DataProvider().deleteTrainingSurveyQuestion(surveyIdval);
      }

      for (var element in trainingSurveyQuestionList) {
        await DataProvider().insertTrainingSurveyQuestion(element);
      }
    }
  }

  Future<void> downloadTrainingSurveyQuestionsOpt(String surveyIdval) async {
    List<TrainingSurveyQuestionOptionsDatum> trainingSurveyQuestionOptList = [];
    TrainingSurveyQuestionOptionsModel trainingSurveyQuestionOptModel;
    var responseModel = await TrainingSurveyQuestionOptionsApi()
        .getTrainingSurveyQuestionOptions(surveyId: surveyIdval.toString());
    if (responseModel.isSuccess) {
      trainingSurveyQuestionOptModel =
          responseModel.response as TrainingSurveyQuestionOptionsModel;
      if (trainingSurveyQuestionOptModel.errors == null) {
        trainingSurveyQuestionOptList = [
          ...trainingSurveyQuestionOptList,
          ...trainingSurveyQuestionOptModel.data!
        ];
      }
      if (trainingSurveyQuestionOptList.isNotEmpty) {
        await DataProvider().deleteTrainingSurveyQuestionOpt(surveyIdval);
      }
      for (var element in trainingSurveyQuestionOptList) {
        await DataProvider().insertTrainingSurveyQuestionOptions(element);
      }
    }
  }

  Future<List<QuestionData>> getSurevyPollResponse(
      String? reGuid, String? surveyId) async {
    int pageNumber = 1;
    int pageSize = 500;
    List<QuestionData>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        QuestionModel? allMasterData;
        ResponseModel responseModel =
            await SurveyPollRequest().getSurveyPollData(
          regGuid: reGuid,
          surveyId: surveyId,
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as QuestionModel;

          if (allMasterData.errors == null) {
            List<QuestionData> dataAll = allMasterData.data!;
            masterData.addAll(dataAll);

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 500;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }

      return masterData;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return masterData;
    }
  }

  Future<bool> downloadHandHoldingParticepent() async {
    var userInfo = await UserInfo().getUserCredentials();
    int pageNumber = 1;
    int pageSize = 100;
    List<TrainingHandHoldingParticepent>? masterData = [];

    bool shouldLoop = false;
    try {
      while (!shouldLoop) {
        HandHoldingParicepentModel? allMasterData;
        ResponseModel responseModel =
            await HandHoldinApi().getHandHoldingParticepentList(
          empid: userInfo['email'],
          pageNumber: pageNumber,
          pageSize: pageSize,
        );
        if (responseModel.isSuccess) {
          allMasterData = responseModel.response as HandHoldingParicepentModel;

          if (allMasterData.errors == null) {
            List<TrainingHandHoldingParticepent> dataAll = allMasterData.data!;
            for (var element in dataAll) {
              // element.Mobileno = mobile;

              masterData.add(element);
            }

            // Map<String, dynamic> schedule = data[i];
          }
          if (allMasterData.nextPage == null) {
            shouldLoop = true;
          } else {
            pageSize = 100;
            pageNumber = pageNumber + 1;
            shouldLoop = false;
          }
        } else {
          shouldLoop = true;
        }
      }
      if (masterData != null && masterData.isNotEmpty) {
        for (var element in masterData) {
          await DataProvider().saveHandHoldingParticepent(element);
        }
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      return false;
    }
  }
}

TblTrainingHandHolding convertHandHolding(HandHoldingItem item) {
  TblTrainingHandHolding tblTrainingHandHolding = TblTrainingHandHolding(
      handHoldingGuid: item.handHoldingGuid ?? '',
      scheduleGuid: item.scheduleGuid ?? '',
      year: item.year ?? '',
      trainingName: item.trainingName ?? '',
      handHoldingDate: item.handHoldingDate ?? '',
      handHoldingIntervention: item.handHoldingIntervention ?? '',
      topicsCovered: item.topicsCovered ?? '',
      topicsCoveredName: item.topicsCoveredName ?? '',
      facilitatorName: item.facilitatorName ?? '',
      observer: item.observer ?? '',
      observerName: item.observerName ?? '',
      sessionParticipant: item.sessionParticipant ?? '',
      remark: item.remark ?? '',
      other: item.other ?? '',
      active: 1,
      createdBy: item.createdBy ?? '',
      createdOn: item.createdOn ?? '',
      updatedOn: item.updatedOn ?? '',
      updatedBy: item.updatedBy ?? '',
      SyncingDate: item.createdOn ?? '',
      isEdited: 0,
      Module: item.module ?? '',
      ModuleName: item.moduleName ?? '',
      attendingPseArpanTraining: item.attendingPseArpanTraining,
      modeOfGroupMeeting: item.modeOfGroupMeeting ?? '',
      stateId: item.stateId ?? '',
      districtId: item.districtId ?? '',
      blockId: item.blockId ?? ''
      // Assign the processed data directly
      );
  return tblTrainingHandHolding;
}

TrainingHandHoldingAttendance convertAttendanceModel(
    Attendance attendanceItem) {
  TrainingHandHoldingAttendance processedAttendance =
      TrainingHandHoldingAttendance(
    handHoldingGuid: attendanceItem.handHoldingGuid ?? '',
    mobileNo: attendanceItem.mobileNo ?? '',
    createdBy: attendanceItem.createdBy ?? '',
    createdOn: attendanceItem.createdOn ?? '',
    updatedOn: attendanceItem.updatedOn ?? '',
    updatedBy: attendanceItem.updatedBy ?? '',
    isEdited: 0,
  );
  return processedAttendance;
}

List<TblTrainingSchedule> convertrainingSchedule(
    List<TrainingSchedule> alldata, String userID) {
  List<TblTrainingSchedule> allvalue = alldata
      .map((schedule) => TblTrainingSchedule(
          scheduleGuid: schedule.scheduleGuid,
          communicationYear: schedule.CommunicationYear,
          year: schedule.Year,
          communicationEstablishment: schedule.CommunicationEstablishment,
          trainingApproach: schedule.trainingApproach,
          trainingType: schedule.trainingType,
          trainingName: schedule.trainingName,
          typeOfGroup: schedule.typeOfGroup,
          hostEstablishment: schedule.hostEstablishment,
          participantEstablishment: schedule.participantEstablishment,
          participantEstablishmentName: schedule.participantEstablishmentName,
          modeOfTraining: schedule.modeOfTraining,
          duration: schedule.duration,
          firstDate: schedule.firstDate,
          lastDate: schedule.lastDate,
          mediumofInstruction: schedule.mediumofInstruction,
          mediumofInstructionName: schedule.mediumofInstructionName,
          trainingTheme: schedule.trainingTheme,
          topicsCovered: schedule.topicsCovered,
          topicsCoveredName: schedule.topicsCoveredName,
          trainer: schedule.tainer,
          trainerName: schedule.trainerName,
          otherTheme: schedule.otherTheme,
          preSurveyId: schedule.preSurveyId,
          postSurveyId: schedule.postSurveyId,
          feedbackSurveyId: schedule.feedbackSurveyId,
          active: 1,
          isEdited: 0,
          UserId: userID,
          StartTime: schedule.StartTime,
          EndTime: schedule.EndTime,
          stateId: schedule.stateId,
          districtId: schedule.districtId,
          blockId: schedule.blockId,
          isParticipant: schedule.isParticipant,
          participantStateId: schedule.participantStateId,
          participantDistrictId: schedule.participantDistrictId,
          participantBlockId: schedule.participantBlockId,
          ministryId: schedule.ministryId))
      .toList();
  return allvalue;
}

List<TblTrainingRegistration> convertRegData(
    List<TrainingRegistration> alldata) {
  List<TblTrainingRegistration> allvalue = alldata.map((registration) {
    return TblTrainingRegistration(
        registrationGuid: registration.registrationGuid,
        scheduleGuid: registration.scheduleGuid,
        participantEstablishment: registration.participantEstablishment,
        participantEstablishmentName: registration.participantEstablishmentName,
        mediumOfInstruction: registration.mediumofInstruction,
        topicsCovered: registration.topicsCovered,
        topicsCoveredName: registration.topicsCoveredName,
        trainer: registration.trainer,
        trainerName: registration.trainerName,
        trainingCode: registration.trainingCode,
        batchNo: registration.batchNo,
        syncingDate: registration.syncingdate,
        countryId: '${registration.countryId ?? 0}',
        stateId: '${registration.stateId ?? 0}',
        districtId: '${registration.districtId ?? 0}',
        active: 1,
        createdBy: registration.createdBy,
        createdOn: registration.createdOn,
        updatedOn: registration.updatedOn,
        updatedBy: registration.updatedBy,
        Block: registration.Block,
        observerName: registration.observerName,
        observer: registration.observer,
        isEdited: 0,
        noInternet: registration.noInternet,
        notes: registration.notes,
        trainingDate: registration.trainingDate,
        batchVenue: registration.batchVenue);
  }).toList();
  return allvalue;
}

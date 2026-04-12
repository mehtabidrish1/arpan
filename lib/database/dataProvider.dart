import 'dart:convert';
import 'dart:io';

import 'package:arpan/api/indirectData_uploadImageApi.dart';
import 'package:arpan/constants/api_constants.dart';
import 'package:arpan/models/tbl_error_logs.dart';
import 'package:arpan/models/training_registration_session.dart';
import 'package:arpan/models/training_surveyQuestionModel.dart';
import 'package:arpan/table_model/tbl_master_model.dart';
import 'package:arpan/table_model/tbl_session_attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/secure_storage_keys.dart';
import '../models/TrainerEstablishmentList_model.dart';
import '../models/indirectData_uploadImageModel.dart';
import '../models/tbl_batch_attendence_data.dart';
import '../models/tbl_partial_attendance_data.dart';
import '../models/tbl_trainner_list.dart';
import '../models/training_hand_holding_module_model.dart';
import '../models/training_registration.dart';
import '../models/training_schedule_participant_model.dart';
import '../models/training_surveyQuestionOptionsModel.dart';
import '../models/uploadImageModel.dart';
import '../table_model/notification_model.dart';
import '../table_model/tblAttendance_count.dart';
import '../table_model/tblTraningIndirectData_list.dart';
import '../table_model/tbl_IndividualPartner.dart';
import '../table_model/tbl_Training_HandHolding_Particepent.dart';
import '../table_model/tbl_block_model.dart';
import '../table_model/tbl_designation_model.dart';
import '../table_model/tbl_district_model.dart';
import '../table_model/tbl_particepent_training_details.dart';
import '../table_model/tbl_participant_scan_details.dart';
import '../table_model/tbl_state_model.dart';
import '../table_model/tbl_teacher_grade_model.dart';
import '../table_model/tbl_training_handHolding_attendance.dart';
import '../table_model/tbl_training_hand_holding.dart';
import '../table_model/tbl_training_registration_model.dart';
import '../table_model/tbl_training_schedule_model.dart';
import '../table_model/tblsurvey_response.dart';
import '../table_model/training_indirect_data_model.dart';
import '../utils/common.dart';
import '../utils/log_files.dart';
import 'databaseHelper.dart';

class DataProvider {
  final db = DatabaseHelper.database;

  Future insertParticipent(TrainingScheduleParticipantModel state) async {
    try {
      // await db!.insert(Constants.trainingScheduleParticipantList, state.toJson());
      String tableName = Constants.trainingScheduleParticipantList;
      var data = state.toJson();
      final List<Map<String, dynamic>> result = await db!.query(
        tableName,
        where: 'PhoneNo = ? and Lower(ScheduleGuid)=?',
        whereArgs: [
          data['PhoneNo'],
          data['ScheduleGuid'].toString().toLowerCase()
        ],
      );

      if (result.isNotEmpty) {
        await db!.update(
          tableName,
          data,
          where: 'PhoneNo = ? and Lower(ScheduleGuid)=?',
          whereArgs: [
            data['PhoneNo'],
            data['ScheduleGuid'].toString().toLowerCase()
          ],
        );
      } else {
        await db!.insert(tableName, data);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      //print(e);
    }
  }

  Future<List<TrainingScheduleParticipantModel>> getStateList() async {
    final List<Map<String, dynamic>> maps =
        await db!.query(Constants.trainingScheduleParticipantList);
    List<TrainingScheduleParticipantModel> stateData = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      stateData.add(state);
    }

    return stateData;
  }

  Future<List<TrainingScheduleParticipantModel>> uploadParticipantList(
      {String? mobileno}) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.trainingScheduleParticipantList,
        where: "IsEdited = ?",
        whereArgs: [1]);
    List<TrainingScheduleParticipantModel> stateData = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      stateData.add(state);
    }
    if (mobileno != null && mobileno.isNotEmpty) {
      var regData =
          stateData.where((element) => element.phoneNo == mobileno).toList();
      return regData;
    }

    return stateData;
  }

  Future<int> updateParticipant(TrainingScheduleParticipantModel model) async {
    return await db!.update(
        Constants.trainingScheduleParticipantList, model.toJson(),
        where: "PhoneNo = ? and Lower(ScheduleGuid)=?",
        whereArgs: [model.phoneNo, model.scheduleGuid!.toLowerCase()]);
  }

  Future<void> deleteState(TrainingScheduleParticipantModel model) async {
    await db!.delete(Constants.trainingScheduleParticipantList,
        where: "RegistrationGuid = ?", whereArgs: [model.registrationGuid]);
  }

  Future<void> insertTrainingRegistration(
      List<TblTrainingRegistration> trainingRegistration) async {
    // await db!.delete(Constants.trainingRegistration);
    if (trainingRegistration.isNotEmpty) {
      for (var element in trainingRegistration) {
        String tableName = Constants.trainingRegistration;
        var data = element.toJson();
        final List<Map<String, dynamic>> result = await db!.query(
          tableName,
          where: 'Lower(RegistrationGuid) = ?',
          whereArgs: [data['RegistrationGuid'].toString().toLowerCase()],
        );

        if (result.isNotEmpty) {
          await db!.update(
            tableName,
            data,
            where: 'Lower(RegistrationGuid) = ?',
            whereArgs: [data['RegistrationGuid'].toString().toLowerCase()],
          );
        } else {
          await db!.insert(tableName, data);
        }
      }
    }
  }

  updateUploadAttendance(String? guid) async {
    String tableName = Constants.TblSessionAttendance;
    await db!.update(
      tableName,
      {'IsEdited': 0},
      where: 'lower(RegistrationGuid) = ?',
      whereArgs: [guid!.toLowerCase()],
    );
  }

  Future<void> insertTrainingSessionAttendanceList(
      List<TblSessionAttendance> attendance) async {
    for (var element in attendance) {
      await insertTrainingSessionAttendance(element);
    }
  }

  Future<void> insertTrainingSessionAttendance(
      TblSessionAttendance attendance) async {
    String tableName = Constants.TblSessionAttendance;
    try {
      var data = attendance.toJson();
      final List<Map<String, dynamic>> result = await db!.query(
        tableName,
        where: 'lower(RegistrationGuid) = ? and phoneNo=?',
        whereArgs: [
          attendance.RegistrationGuid!.toLowerCase(),
          attendance.phoneNo
        ],
      );

      if (result.isNotEmpty) {
        await db!.update(
          tableName,
          data,
          where: 'lower(RegistrationGuid) = ? and phoneNo=?',
          whereArgs: [
            attendance.RegistrationGuid!.toLowerCase(),
            attendance.phoneNo
          ],
        );
      } else {
        await db!.insert(tableName, data);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  Future<void> deleteTrainingSessionAttendance(String guid) async {
    String tableName = Constants.TblSessionAttendance;
    await db!.delete(tableName,
        where: "Lower(RegistrationGuid) = ?", whereArgs: [guid!.toLowerCase()]);
  }

  Future<List<TblSessionAttendance>> getTrainingSessionAttendance(
      String guid) async {
    String tableName = Constants.TblSessionAttendance;
    final List<Map<String, dynamic>> result = await db!.query(
      tableName,
      where: 'lower(RegistrationGuid) = ?',
      whereArgs: [guid.toLowerCase()],
    );
    List<TblSessionAttendance> trainingSurveyQuestionData = [];
    for (var element in result) {
      TblSessionAttendance trainingSurveyQuestionDatum =
          TblSessionAttendance.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<List<TblSessionAttendance>> uploadTrainingSessionAttendance() async {
    String tableName = Constants.TblSessionAttendance;
    final List<Map<String, dynamic>> result = await db!.rawQuery(
        'SELECT DISTINCT RegistrationGuid,ScheduleGuid FROM $tableName where IsEdited=1');
    List<TblSessionAttendance> trainingSurveyQuestionData = [];
    for (var element in result) {
      TblSessionAttendance trainingSurveyQuestionDatum =
          TblSessionAttendance.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<List<TblBatchPartialAttendanceData>>
      uploadTrainingPartialAttendance() async {
    String tableName = Constants.tblPartial_Attendance;
    final List<Map<String, dynamic>> result = await db!.rawQuery(
        'SELECT DISTINCT RegistrationGuid FROM $tableName where IsEdited=1');
    List<TblBatchPartialAttendanceData> trainingSurveyQuestionData = [];
    for (var element in result) {
      TblBatchPartialAttendanceData trainingSurveyQuestionDatum =
          TblBatchPartialAttendanceData.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<void> insertTrainingSchedule(
      List<TblTrainingSchedule> tblTrainingSchedule) async {
    // await db!.delete(Constants.TrainingSchedule);
    if (tblTrainingSchedule.isNotEmpty) {
      for (var element in tblTrainingSchedule) {
        final List<Map<String, dynamic>> result = await db!.query(
          Constants.TrainingSchedule,
          where: 'Lower(ScheduleGuid) = ?',
          whereArgs: [element.scheduleGuid!.toLowerCase()],
        );

        if (result.isNotEmpty) {
          await db!.update(
            Constants.TrainingSchedule,
            element.toJson(),
            where: 'Lower(ScheduleGuid) = ?',
            whereArgs: [element.scheduleGuid!.toLowerCase()],
          );
        } else {
          await db!.insert(Constants.TrainingSchedule, element.toJson());
        }
      }
    }
  }

  Future<void> insertAttendanceCount(
      List<TblAttendanceCount> tblattenCount, String regGuid) async {
    await db!.delete(Constants.tblAttendance_count,
        where: 'Lower(RegistrationGuid)=?',
        whereArgs: [regGuid!.toLowerCase()]);
    if (tblattenCount.isNotEmpty) {
      for (var element in tblattenCount) {
        element.RegistrationGuid = regGuid;

        await db!.insert(Constants.tblAttendance_count, element.toJson());
      }
    }
  }

  Future<bool> insertTrainingBatch(
      TblTrainingRegistration trainingRegistration) async {
    try {
      String tableName = Constants.trainingRegistration;
      var data = trainingRegistration.toJson();
      final List<Map<String, dynamic>> result = await db!.query(
        tableName,
        where: 'Lower(RegistrationGuid) = ?',
        whereArgs: [data['RegistrationGuid'].toString().toLowerCase()],
      );

      if (result.isNotEmpty) {
        await db!.update(
          tableName,
          data,
          where: 'Lower(RegistrationGuid) = ?',
          whereArgs: [data['RegistrationGuid'].toString().toLowerCase()],
        );
      } else {
        await db!.insert(tableName, data);
      }

      return true;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
  }

  Future<bool> insertSurveyData(
      List<SurveyResponse> responseData, String mobile) async {
    try {
      for (var element in responseData) {
        // await db!.delete(Constants.Survey_Response,
        //   where: 'SurveyId = ? and MobileNo=? and Lower(RegistrationGuid)=? ',
        //   whereArgs: [element.surveyId, mobile, element.registrationGuid!.toLowerCase()]);
        // await db!.insert(Constants.Survey_Response, element.toJson());
        final result = await db!.query(
          Constants.Survey_Response,
          where:
              'SurveyId = ? AND MobileNo = ? AND Lower(RegistrationGuid) = ? AND QuestionID = ?',
          whereArgs: [
            element.surveyId,
            mobile,
            element.registrationGuid,
            element.questionId
          ],
        );

        if (result.isNotEmpty) {
          // Record exists: update it
          await db!.update(
            Constants.Survey_Response,
            element.toJson(),
            where:
                'SurveyId = ? AND MobileNo = ? AND Lower(RegistrationGuid) = ? AND QuestionID = ?',
            whereArgs: [
              element.surveyId,
              mobile,
              element.registrationGuid,
              element.questionId
            ],
          );
        } else {
          // Record doesn't exist: insert new
          await db!.insert(Constants.Survey_Response, element.toJson());
        }
      }

      return true;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
  }

  Future<int> getSurveyData(
      String? surveyId, String? mobileNo, String? regGuid) async {
    try {
      final List<Map<String, dynamic>> maps = await db!.query(
          Constants.Survey_Response,
          where: 'SurveyId = ? and MobileNo=? and Lower(RegistrationGuid)=? ',
          whereArgs: [surveyId, mobileNo, regGuid!.toLowerCase()]);
      List<SurveyResponse> stateData = [];
      for (var element in maps) {
        SurveyResponse state = SurveyResponse.fromJson(element);
        stateData.add(state);
      }

      return stateData.length;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return 0;
    }
  }

  Future<int> getSurveyDataOffline(String? mobileNo) async {
    try {
      final List<Map<String, dynamic>> maps = await db!.query(
          Constants.Survey_Response,
          where: 'MobileNo=? and IsEdited=? ',
          whereArgs: [mobileNo, 1]);
      List<SurveyResponse> stateData = [];
      for (var element in maps) {
        SurveyResponse state = SurveyResponse.fromJson(element);
        stateData.add(state);
      }

      return stateData.length;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return 0;
    }
  }

  Future<List<SurveyResponse>> getSurveyAllData(
      String? surveyId, String? mobileNo, String? regGuid) async {
    try {
      final List<Map<String, dynamic>> maps = await db!.query(
          Constants.Survey_Response,
          where: 'SurveyId = ? and MobileNo=? and Lower(RegistrationGuid)=? ',
          whereArgs: [surveyId, mobileNo, regGuid!.toLowerCase()]);
      List<SurveyResponse> stateData = [];
      for (var element in maps) {
        SurveyResponse state = SurveyResponse.fromJson(element);
        stateData.add(state);
      }

      return stateData;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return [];
    }
  }

  Future<void> insertMasterData(List<TblMasterModel> masterData) async {
    await db!.delete(Constants.TblMaster);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.TblMaster, element.toJson());
      }
    }
  }

  Future<void> insertPartial_Attendance(
      List<TblBatchPartialAttendanceData> masterData, String? regGuid) async {
    await db!.delete(
      Constants.tblPartial_Attendance,
      where: 'Lower(RegistrationGuid) = ? ',
      whereArgs: [regGuid!.toLowerCase()],
    );
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tblPartial_Attendance, element.toJson());
      }
    }
  }

  Future<void> insertPartial_AttendanceDownload(
      List<TblBatchPartialAttendanceData> masterData) async {
    await db!.delete(
      Constants.tblPartial_Attendance,
    );
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tblPartial_Attendance, element.toJson());
      }
    }
  }

  Future<void> UpdatePartial_Attendance(String? regGuid) async {
    try {
      await db!.rawQuery(
          'Update ${Constants.tblPartial_Attendance} set IsEdited=\'0\' where Lower(registrationGuid)=\'${regGuid!.toLowerCase()}\' ');
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  Future<void> insertBatchAttendance(
      List<TblBatchAttendanceData> masterData) async {
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        String tableName = Constants.tblBatch_Attendance;
        var data = element.toJson();
        final List<Map<String, dynamic>> result = await db!.query(
          tableName,
          where: 'Lower(RegistrationGuid) = ? and MobileNo=?',
          whereArgs: [
            data['RegistrationGuid'].toString().toLowerCase(),
            data['MobileNo']
          ],
        );

        if (result.isNotEmpty) {
          await db!.update(
            tableName,
            data,
            where: 'Lower(RegistrationGuid) = ?  and MobileNo=?',
            whereArgs: [
              data['RegistrationGuid'].toString().toLowerCase(),
              data['MobileNo']
            ],
          );
        } else {
          await db!.insert(tableName, data);
        }
      }
    }
  }

  Future<void> insertStateData(List<TblStateModel> masterData) async {
    await db!.delete(Constants.tbl_state);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tbl_state, element.toJson());
      }
    }
  }

  Future<void> insertTeacherGrade(List<TblTeacherGradeModel> masterData) async {
    await db!.delete(Constants.tbl_TeacherGrade);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tbl_TeacherGrade, element.toJson());
      }
    }
  }

  Future<void> insertDistrictData(List<TblDistrictModel> masterData) async {
    await db!.delete(Constants.tbl_district);
    // if (masterData.isNotEmpty) {
    //   for (var element in masterData) {
    //     await db!.insert(Constants.tbl_district, element.toJson());
    //   }
    // }
    if (masterData.isNotEmpty) {
      Batch batch = db!.batch();

      for (var element in masterData) {
        batch.insert(Constants.tbl_district, element.toJson());
      }

      await batch.commit(noResult: true);
    }
  }

  Future<void> insertBlockData(List<BlockDatum> masterData) async {
    await db!.delete(Constants.tbl_block);
    // if (masterData.isNotEmpty) {
    //   for (var element in masterData) {
    //     await db!.insert(Constants.tbl_block, element.toJson());
    //   }
    // }
    if (masterData.isNotEmpty) {
      Batch batch = db!.batch(); // Start a batch operation

      for (var element in masterData) {
        batch.insert(Constants.tbl_block, element.toJson());
      }

      await batch.commit(noResult: true); // Commit all inserts at once
    }
  }

  Future<void> insertDesignationData(
      List<TblDesignationModel> masterData) async {
    await db!.delete(Constants.tbl_designation);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tbl_designation, element.toJson());
      }
    }
  }

  Future<void> insertIndividualPartnerData(
      List<TblIndividualPartner> masterData) async {
    await db!.delete(Constants.tbl_IndividualPartner);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tbl_IndividualPartner, element.toJson());
      }
    }
  }

  Future<List<TblIndividualPartner>> getIndividualPartnerList() async {
    String tableName = Constants.tbl_IndividualPartner;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'partnerName');

    List<TblIndividualPartner> tbMaster = [];

    for (var element in result) {
      TblIndividualPartner state = TblIndividualPartner.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<void> insertTrainingHandHoldingModuleList(
      List<TrainingHandHoldingModuleData> masterData) async {
    await db!.delete(Constants.tbl_TrainingHandHoldingModuleList);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(
            Constants.tbl_TrainingHandHoldingModuleList, element.toJson());
      }
    }
  }

  Future<void> insertTrainerEstablishmentList(
      List<TrainerEstablishmentDatum> masterData) async {
    await db!.delete(Constants.tblTrainerEstablishment);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tblTrainerEstablishment, element.toJson());
      }
    }
  }

  Future<void> insertTrainerList(List<TrainerModel> masterData) async {
    await db!.delete(Constants.tblTrainerList);
    if (masterData.isNotEmpty) {
      for (var element in masterData) {
        await db!.insert(Constants.tblTrainerList, element.toJson());
      }
    }
  }

  Future<List<TrainerEstablishmentDatum>> getTrainerEstablishmentList() async {
    String tableName = Constants.tblTrainerEstablishment;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'Name');

    List<TrainerEstablishmentDatum> tbMaster = [];

    for (var element in result) {
      TrainerEstablishmentDatum state =
          TrainerEstablishmentDatum.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TrainerModel>> getTrainerList() async {
    String tableName = Constants.tblTrainerList;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'Name');

    List<TrainerModel> tbMaster = [];

    for (var element in result) {
      TrainerModel state = TrainerModel.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TrainingHandHoldingModuleData>>
      getTrainingHandHoldingModuleList() async {
    String tableName = Constants.tbl_TrainingHandHoldingModuleList;
    List<Map<String, dynamic>> result = await db!.query(tableName);

    List<TrainingHandHoldingModuleData> tbMaster = [];

    for (var element in result) {
      TrainingHandHoldingModuleData state =
          TrainingHandHoldingModuleData.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TblStateModel>> getAllState() async {
    String tableName = Constants.tbl_state;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'StateName');

    List<TblStateModel> tbMaster = [];

    for (var element in result) {
      TblStateModel state = TblStateModel.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TblDistrictModel>> getAllDistrict() async {
    String tableName = Constants.tbl_district;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'districtName');

    List<TblDistrictModel> tbMaster = [];
    for (var element in result) {
      TblDistrictModel state = TblDistrictModel.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TblTeacherGradeModel>> getTeacherGradeList() async {
    String tableName = Constants.tbl_TeacherGrade;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'TeacherGrade');

    List<TblTeacherGradeModel> tbMaster = [];
    for (var element in result) {
      TblTeacherGradeModel state = TblTeacherGradeModel.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<BlockDatum>> getAllBlock() async {
    String tableName = Constants.tbl_block;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'BlockName');

    List<BlockDatum> tbMaster = [];
    for (var element in result) {
      BlockDatum state = BlockDatum.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TblDesignationModel>> getAllDesignation() async {
    String tableName = Constants.tbl_designation;
    List<Map<String, dynamic>> result =
        await db!.query(tableName, orderBy: 'EnglishDesignation');

    List<TblDesignationModel> tbMaster = [];
    for (var element in result) {
      TblDesignationModel state = TblDesignationModel.fromJson(element);
      tbMaster.add(state);
    }
    return tbMaster;
  }

  Future<List<TblTrainingRegistration>> getTrainingRegistration() async {
    final List<Map<String, dynamic>> maps =
        await db!.query(Constants.trainingRegistration);
    List<TblTrainingRegistration> trainingRegistration = [];
    for (var element in maps) {
      TblTrainingRegistration state = TblTrainingRegistration.fromJson(element);
      trainingRegistration.add(state);
    }

    return trainingRegistration;
  }

  Future<List<TblTrainingHandHolding>> getHandholingRegistration(
      String scheduleGuid) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.Training_HandHolding,
        where: 'Lower(ScheduleGuid) = ?',
        whereArgs: [scheduleGuid.toLowerCase()]);
    List<TblTrainingHandHolding> trainingRegistration = [];
    for (var element in maps) {
      TblTrainingHandHolding state = TblTrainingHandHolding.fromJson(element);
      trainingRegistration.add(state);
    }

    return trainingRegistration;
  }

  Future<List<TblTrainingHandHolding>> uploadHandholingRegistration() async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.Training_HandHolding,
        where: 'isEdited = ?',
        whereArgs: [1]);
    List<TblTrainingHandHolding> trainingRegistration = [];
    for (var element in maps) {
      TblTrainingHandHolding state = TblTrainingHandHolding.fromJson(element);
      trainingRegistration.add(state);
    }

    return trainingRegistration;
  }

  Future<List<TblTrainingRegistration>> getUploadTrainingRegistration() async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.trainingRegistration,
        where: 'IsEdited = ?',
        whereArgs: [1]);
    List<TblTrainingRegistration> trainingRegistration = [];
    for (var element in maps) {
      TblTrainingRegistration state = TblTrainingRegistration.fromJson(element);
      trainingRegistration.add(state);
    }

    return trainingRegistration;
  }

  Future<List<TblAttendanceCount>> getTrainingBatchCount(String regguid) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.tblAttendance_count,
        where: 'Lower(RegistrationGuid) = ?',
        whereArgs: [regguid!.toLowerCase()]);
    List<TblAttendanceCount> trainingRegistration = [];
    for (var element in maps) {
      TblAttendanceCount state = TblAttendanceCount.fromJson(element);
      trainingRegistration.add(state);
    }

    return trainingRegistration;
  }

  Future<List<TblTrainingSchedule>> getTrainingSchedule(String userId) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.TrainingSchedule,
        where: 'UserId = ?',
        whereArgs: [userId]);

    List<TblTrainingSchedule> trainingRegistration = [];
    for (var element in maps) {
      TblTrainingSchedule state = TblTrainingSchedule.fromJson(element);
      trainingRegistration.add(state);
    }

    final List<Map<String, dynamic>> mapsMaster = await db!.query(
        Constants.TblMaster,
        where: 'Flag = ?',
        whereArgs: ['TrainingTheme']);

    List<TblMasterModel> tbMaster = [];
    for (var element in mapsMaster) {
      TblMasterModel state = TblMasterModel.fromJson(element);
      tbMaster.add(state);
    }
    List<TblTrainingSchedule> trainingRegistrationResult = [];
    for (var element1 in trainingRegistration) {
      try {
        element1.trainingTheme = tbMaster
            .where((element) => element1.trainingTheme == element.value)
            .first
            .text;
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }

      trainingRegistrationResult.add(element1);
    }

    return trainingRegistrationResult;
  }

  Future insertTrainingSurveyQuestion(TrainingSurveyQuestionDatum data) async {
    return await db!.insert(Constants.trainingSurveyQuestions, data.toJson());
  }

  Future deleteTrainingSurveyQuestion(String surveyId) async {
    return await db!.delete(Constants.trainingSurveyQuestions,
        where: 'SurveyId = ?', whereArgs: [surveyId]);
  }

  Future deleteTrainingSurveyQuestionOpt(String surveyId) async {
    return await db!.delete(Constants.trainingSurveyQuestionOptions,
        where: 'SurveyId = ?', whereArgs: [surveyId]);
  }

  Future<List<TrainingSurveyQuestionDatum>> getTrainingSurveyQuestions(
      String surveyId) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.trainingSurveyQuestions,
        where: 'SurveyId = ?',
        whereArgs: [surveyId],
        orderBy: 'CAST(QuestionNo AS INTEGER) ASC');
    List<TrainingSurveyQuestionDatum> trainingSurveyQuestionData = [];
    for (var element in maps) {
      TrainingSurveyQuestionDatum trainingSurveyQuestionDatum =
          TrainingSurveyQuestionDatum.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<List<TrainingSurveyQuestionOptionsDatum>>
      getTrainingSurveyQuestionOptions(String surveyId) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.trainingSurveyQuestionOptions,
        where: 'SurveyId = ?',
        whereArgs: [surveyId]);
    List<TrainingSurveyQuestionOptionsDatum> trainingSurveyQuestionData = [];
    for (var element in maps) {
      TrainingSurveyQuestionOptionsDatum trainingSurveyQuestionDatum =
          TrainingSurveyQuestionOptionsDatum.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future insertTrainingSurveyQuestionOptions(
      TrainingSurveyQuestionOptionsDatum data) async {
    return await db!
        .insert(Constants.trainingSurveyQuestionOptions, data.toJson());
  }

  Future<void> insertTrainingParticipant(
      List<TrainingScheduleParticipantModel> trainingParticipant) async {
    // await db!.delete(Constants.trainingScheduleParticipantList);
    if (trainingParticipant.isNotEmpty) {
      for (var element in trainingParticipant) {
        String tableName = Constants.trainingScheduleParticipantList;
        var data = element.toJson();
        final List<Map<String, dynamic>> result = await db!.query(
          tableName,
          where: 'Lower(ScheduleGuid) = ? AND PhoneNo = ?',
          whereArgs: [
            data['ScheduleGuid'].toString().toLowerCase(),
            data['PhoneNo']
          ],
        );

        if (result.isNotEmpty) {
          await db!.update(
            tableName,
            data,
            where: 'Lower(ScheduleGuid) = ? AND PhoneNo = ?',
            whereArgs: [
              data['ScheduleGuid'].toString().toLowerCase(),
              data['PhoneNo']
            ],
          );
        } else {
          await db!.insert(tableName, data);
        }
      }
    }
  }

  Future<List<TrainingScheduleParticipantModel>> getTrainingParticipant(
      {String? scheduledGuid}) async {
    final List<Map<String, dynamic>> maps;
    if (scheduledGuid != null && scheduledGuid.isNotEmpty) {
      maps = await db!.query(Constants.trainingScheduleParticipantList,
          where: 'LOWER(ScheduleGuid) = ? ',
          whereArgs: [scheduledGuid!.toLowerCase()]);
    } else {
      maps = await db!.query(Constants.trainingScheduleParticipantList);
    }

    List<TrainingScheduleParticipantModel> trainingParticipant = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  Future<List<TrainingScheduleParticipantModel>> getTrainingParticipantAttendance(
      {String? scheduledGuid, String? registrationGuid}) async {
    final List<Map<String, dynamic>> maps;
    if (scheduledGuid != null && scheduledGuid.isNotEmpty && registrationGuid != null && registrationGuid.isNotEmpty) {
      maps = await db!.query(Constants.trainingScheduleParticipantList,
          where: 'LOWER(ScheduleGuid) = ? and LOWER(RegistrationGuid) =?',
          whereArgs: [scheduledGuid.toLowerCase(),registrationGuid.toLowerCase()]);
    } else {
      maps = await db!.query(Constants.trainingScheduleParticipantList);
    }

    List<TrainingScheduleParticipantModel> trainingParticipant = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  Future<List<TrainingScheduleParticipantModel>> getParticipantcurentTraining(
      String? scheduledGuid, String mobile) async {
    final List<Map<String, dynamic>> maps;
    if (scheduledGuid != null && scheduledGuid.isNotEmpty) {
      maps = await db!.query(Constants.trainingScheduleParticipantList,
          where: 'LOWER(ScheduleGuid) = ? and PhoneNo=? ',
          whereArgs: [scheduledGuid!.toLowerCase(), mobile]);
    } else {
      maps = await db!.query(Constants.trainingScheduleParticipantList);
    }

    List<TrainingScheduleParticipantModel> trainingParticipant = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  Future<List<TrainingScheduleParticipantModel>>
      getTrainingParticipantWithMobile({String? mobileNo}) async {
    final List<Map<String, dynamic>> maps;
    if (mobileNo != null && mobileNo.isNotEmpty) {
      maps = await db!.query(Constants.trainingScheduleParticipantList,
          where: 'LOWER(PhoneNo) = ? ', whereArgs: [mobileNo.toLowerCase()]);
    } else {
      maps = await db!.query(Constants.trainingScheduleParticipantList);
    }

    List<TrainingScheduleParticipantModel> trainingParticipant = [];
    for (var element in maps) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  /* Future<bool> deleteAllDatabase() async {
    try {
      await db!.delete(Constants.trainingScheduleParticipantList);
      await db!.delete(Constants.trainingRegistration);
      await db!.delete(Constants.uploadImage);
      return true;
    } catch (Ex) {
      print(Ex);
      return false;
    }
  }*/

  Future insertImage(UploadImageModel data) async {
    return await db!.insert(Constants.uploadImage, data.toMap());
  }

  Future<List<UploadImageModel>> getImageList() async {
    final List<Map<String, dynamic>> maps =
        await db!.query(Constants.uploadImage);
    List<UploadImageModel> imageData = [];
    for (var element in maps) {
      UploadImageModel image = UploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future insertIndirectDataImage(IndirectDataUploadImageModel data) async {
    return await db!.insert(Constants.indirectDataUploadImage, data.toMap());
  }

  Future deleteIndirectDataImage(
      String imagename, String indirectDataGuid) async {
    await db!.delete(Constants.indirectDataUploadImage,
        where: "Lower(image) = ? and Lower(IndirectDataGuid) = ? ",
        whereArgs: [imagename!.toLowerCase(), indirectDataGuid!.toLowerCase()]);
  }

  Future<List<IndirectDataUploadImageModel>> getIndirectDataImageList() async {
    final List<Map<String, dynamic>> maps =
        await db!.query(Constants.indirectDataUploadImage);
    List<IndirectDataUploadImageModel> imageData = [];
    for (var element in maps) {
      IndirectDataUploadImageModel image =
          IndirectDataUploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future<int> insertOrUpdateParticepent(ParticipantScanDetails details) async {
    try {
      String tableName = Constants.particepent_scan_details;

      final existingDetails =
          await findByMobileNo(details.mobileNo!, details.registrationGuid!);

      if (existingDetails) {
        // Update the existing row
        return await db!.update(
          tableName,
          details.toJson(),
          where: 'MobileNo = ? and Lower(RegistrationGuid)=?',
          whereArgs: [
            details.mobileNo,
            details.registrationGuid!.toLowerCase()
          ],
        );
      } else {
        // Insert a new row
        return await db!.insert(tableName, details.toJson());
      }
    } catch (e) {
      return 0;
    }
  }

  Future<bool> findByMobileNo(String mobileNo, String registrationGuid) async {
    String tableName = Constants.particepent_scan_details;

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'MobileNo = ? and Lower(RegistrationGuid)=?',
      whereArgs: [mobileNo, registrationGuid.toLowerCase()],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<ParticipantScanDetails> getParticipantScanDetailsReg(
      String mobileNo, String registrationGuidval) async {
    String tableName = Constants.particepent_scan_details;

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'MobileNo = ? and lower(RegistrationGuid)=?',
      whereArgs: [mobileNo, registrationGuidval.toLowerCase()],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ParticipantScanDetails.fromJson(maps.first);
    } else {
      return ParticipantScanDetails();
    }
  }

  Future<List<ParticipantScanDetails>>
      getParticipantScanDetailsForUpload() async {
    String tableName = Constants.particepent_scan_details;

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'IsEdited = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return ParticipantScanDetails.listFromJson(maps);
    } else {
      return [];
    }
  }

  Future<ParticipantScanDetails> getParticipantScanDetails(
      String mobileNo) async {
    String tableName = Constants.particepent_scan_details;

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'MobileNo = ?',
      whereArgs: [mobileNo],
    );

    if (maps.isNotEmpty) {
      return ParticipantScanDetails.fromJson(maps.last);
    } else {
      return ParticipantScanDetails();
    }
  }

  Future<void> insertParticepentTrainingDetails(
      ParticipantTrainingDetails details) async {
    //await db!.delete(Constants.TrainingRegistrationSession);

    String tableName = Constants.tbl_particepent_training_details;
    var data = details.toJson();
    final List<Map<String, dynamic>> result = await db!.query(
      tableName,
      where: 'MobileNo = ?',
      whereArgs: [data['MobileNo']],
    );

    if (result.isNotEmpty) {
      await db!.update(
        tableName,
        data,
        where: 'MobileNo = ?',
        whereArgs: [data['MobileNo']],
      );
    } else {
      await db!.insert(tableName, data);
    }
  }

  Future<ParticipantTrainingDetails> getParticipantTraingDeatils(
      String mobileNo, String registrationGuidval) async {
    String tableName = Constants.tbl_particepent_training_details;

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'MobileNo = ? and lower(RegistrationGuid)=?',
      whereArgs: [mobileNo, registrationGuidval.toLowerCase()],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ParticipantTrainingDetails.fromJson(maps.first);
    } else {
      return ParticipantTrainingDetails();
    }
  }

  updateFlagOfUploadImage(String sessionGuid) async {
    await db!.rawQuery(
        'Update ${Constants.uploadImage} set isUploaded=\'1\' where registrationGuid=\'${sessionGuid}\' ');
  }

  Future<List<UploadImageModel>> getUploadImageSessionList() async {
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'select DISTINCT registrationGuid FROM ${Constants.uploadImage} where isUploaded=\'0\'');
    List<UploadImageModel> imageData = [];
    for (var element in maps) {
      UploadImageModel image = UploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future<List<UploadImageModel>> getImageForupload(String sessionGuid) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.uploadImage,
        where: 'registrationGuid = ?',
        whereArgs: [sessionGuid]);
    List<UploadImageModel> imageData = [];
    for (var element in maps) {
      UploadImageModel image = UploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  updateFlagOfIndirectUploadImage(String indirectDataGuid) async {
    await db!.rawQuery(
        'Update ${Constants.indirectDataUploadImage} set isUploaded=\'1\' where IndirectDataGuid=\'${indirectDataGuid}\' ');
  }

  Future<List<IndirectDataUploadImageModel>>
      getIndirectUploadImageSessionList() async {
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        'select DISTINCT IndirectDataGuid FROM ${Constants.indirectDataUploadImage} where isUploaded=\'0\'');
    List<IndirectDataUploadImageModel> imageData = [];
    for (var element in maps) {
      IndirectDataUploadImageModel image =
          IndirectDataUploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future<List<IndirectDataUploadImageModel>> getIndirectDataImageForupload(
      String indirectDataGuid) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        Constants.indirectDataUploadImage,
        where: 'IndirectDataGuid = ?',
        whereArgs: [indirectDataGuid]);
    List<IndirectDataUploadImageModel> imageData = [];
    for (var element in maps) {
      IndirectDataUploadImageModel image =
          IndirectDataUploadImageModel.fromMap(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future<List<TblMasterModel>> getMastrerListData(String flag) async {
    final List<Map<String, dynamic>> maps = await db!
        .query(Constants.TblMaster, where: 'Flag = ?', whereArgs: [flag]);
    List<TblMasterModel> imageData = [];
    for (var element in maps) {
      TblMasterModel image = TblMasterModel.fromJson(element);
      imageData.add(image);
    }

    return imageData;
  }

  Future<void> insertTraningIndirectDataList(
      List<TblTraningIndirectDataList> indirectDataList) async {
    // await db!.delete(Constants.TrainingSchedule);
    if (indirectDataList.isNotEmpty) {
      for (var element in indirectDataList) {
        final List<Map<String, dynamic>> result = await db!.query(
          Constants.TblTraningIndirectDataList,
          where:
              'Lower(ScheduleGuid) = ? and Lower(RegistrationGuid)=?  and Mobileno=?',
          whereArgs: [
            element.scheduleGuid!.toLowerCase(),
            element.registrationGuid!.toLowerCase(),
            // element.sessionGuid!.toLowerCase(),
            element.Mobileno
          ],
        );

        if (result.isNotEmpty) {
          await db!.update(
            Constants.TblTraningIndirectDataList,
            element.toJson(),
            where:
                'Lower(ScheduleGuid) = ? and Lower(RegistrationGuid)=?  and Mobileno=?',
            whereArgs: [
              element.scheduleGuid!.toLowerCase(),
              element.registrationGuid!.toLowerCase(),
              // element.sessionGuid!.toLowerCase(),
              element.Mobileno
            ],
          );
        } else {
          await db!
              .insert(Constants.TblTraningIndirectDataList, element.toJson());
        }
      }
    }
  }

  Future<List<TblTraningIndirectDataList>> getTblTraningIndirectDataList(
      String phone) async {
    final List<Map<String, dynamic>> maps = await db!.query(
      Constants.TblTraningIndirectDataList,
      where: 'Mobileno=?',
      whereArgs: [phone],
    );
    List<TblTraningIndirectDataList> stateData = [];
    for (var element in maps) {
      TblTraningIndirectDataList state =
          TblTraningIndirectDataList.fromJson(element);
      stateData.add(state);
    }

    return stateData;
  }

  Future<void> deleteTblTraningIndirectDataList(String mobile) async {
    await db!.delete(Constants.TblTraningIndirectDataList,
        where: 'Mobileno=?', whereArgs: [mobile]);
  }

  Future<void> saveIndirectTrainingData(TrainingIndirectData element) async {
    // await db!.delete(Constants.TrainingSchedule);

    final List<Map<String, dynamic>> result = await db!.query(
      Constants.Training_IndirectData,
      where: 'Lower(IndirectDataGuid) = ?',
      whereArgs: [
        element.indirectDataGuid!.toLowerCase(),
      ],
    );

    if (result.isNotEmpty) {
      await db!.update(
        Constants.Training_IndirectData,
        element.toJson(),
        where: 'Lower(IndirectDataGuid) = ?',
        whereArgs: [
          element.indirectDataGuid!.toLowerCase(),
        ],
      );
    } else {
      await db!.insert(Constants.Training_IndirectData, element.toJson());
    }
  }

  Future<List<TrainingIndirectData>> getindirctTraingingAllData(
      TblTraningIndirectDataList indirectData) async {
    List<TrainingIndirectData> stateData = [];

    final List<Map<String, dynamic>> maps = await db!.query(
      Constants.Training_IndirectData,
      where: 'Lower(ScheduleGuid) = ? and Lower(RegistrationGuid) = ? ',
      whereArgs: [
        indirectData.scheduleGuid!.toLowerCase(),
        indirectData.registrationGuid!.toLowerCase(),
        //indirectData.sessionGuid!.toLowerCase(),
      ],
    );

    for (var element in maps) {
      TrainingIndirectData state = TrainingIndirectData.fromJson(element);
      stateData.add(state);
    }

    return stateData;
  }

  Future<List<TrainingIndirectData>> getindirctTraingingData(
      {String? indirectDataGuid}) async {
    List<TrainingIndirectData> stateData = [];
    if (indirectDataGuid == null) {
      return stateData;
    }
    final List<Map<String, dynamic>> maps = await db!.query(
      Constants.Training_IndirectData,
      where: 'Lower(IndirectDataGuid) = ?',
      whereArgs: [
        indirectDataGuid!.toLowerCase(),
      ],
    );

    for (var element in maps) {
      TrainingIndirectData state = TrainingIndirectData.fromJson(element);
      stateData.add(state);
    }

    return stateData;
  }

  Future<List<TrainingIndirectData>> uploadindirctTraingingData() async {
    final List<Map<String, dynamic>> maps = await db!.query(
      Constants.Training_IndirectData,
      where: 'IsEdited=?',
      whereArgs: [1],
    );
    List<TrainingIndirectData> stateData = [];
    for (var element in maps) {
      TrainingIndirectData state = TrainingIndirectData.fromJson(element);
      stateData.add(state);
    }

    return stateData;
  }

  Future<List<TrainingHandHoldingParticepent>>
      getTrainingHandHoldingParticepentData(TblTrainingSchedule element1,
          TblTrainingHandHolding handholding) async {
    List<TrainingHandHoldingParticepent> stateData = [];
    final List<Map<String, dynamic>> maps1;
    if (element1.scheduleGuid != null && element1.scheduleGuid!.isNotEmpty) {
      maps1 = await db!.query(Constants.trainingScheduleParticipantList,
          where: 'LOWER(ScheduleGuid) = ? ',
          whereArgs: [element1.scheduleGuid!.toLowerCase()]);
    } else {
      maps1 = await db!.query(Constants.trainingScheduleParticipantList);
    }

    //  List<TrainingScheduleParticipantModel> trainingParticipant = [];
    for (var element in maps1) {
      TrainingScheduleParticipantModel state =
          TrainingScheduleParticipantModel.fromJson(element);
      stateData.add(TrainingHandHoldingParticepent(
          HandHoldingGuid: handholding.handHoldingGuid,
          IsEdited: 0,
          OrganisationCode: state.organisationCode,
          attendedArpanSessionChildSexualAbuse:
              state.attendedArpanSessionChildSexualAbuse,
          city: state.stateId,
          createdBy: state.createdBy,
          createdOn: state.createdOn,
          designation: state.designation,
          districtId: state.districtId,
          email: state.email,
          fullName: state.fullName,
          gender: state.gender,
          monthYearAttendSession: state.monthYearAttendSession,
          organisationName: state.organisationName,
          phoneNo: state.phoneNo,
          pinCode: state.pinCode,
          scheduleGuid: state.scheduleGuid,
          stateId: state.stateId,
          tehsilName: state.districtId,
          timestamp: '',
          updatedBy: state.createdBy,
          updatedOn: state.createdOn));
    }

    final List<Map<String, dynamic>> maps = await db!.query(
      Constants.Training_HandHolding_Particepent,
      where: 'LOWER(HandHoldingGuid) = ? ',
      whereArgs: [
        handholding.handHoldingGuid!.toLowerCase(),
      ],
    );

    for (var element in maps) {
      TrainingHandHoldingParticepent state =
          TrainingHandHoldingParticepent.fromJson(element);

      stateData.add(state);
    }

    List<TrainingHandHoldingParticepent> uniqueStateData = [];

    for (var participant in stateData) {
      // Check if the current phoneNo is not already present in uniqueStateData
      bool isUnique = uniqueStateData.every((uniqueParticipant) =>
          uniqueParticipant.phoneNo != participant.phoneNo);

      // If it's unique, add it to the uniqueStateData list
      if (isUnique) {
        uniqueStateData.add(participant);
      }
    }

    return uniqueStateData;
  }

  Future<void> saveHandHoldingParticepent(
      TrainingHandHoldingParticepent element) async {
    // await db!.delete(Constants.TrainingSchedule);

    final List<Map<String, dynamic>> result = await db!.query(
      Constants.Training_HandHolding_Particepent,
      where: 'Lower(HandHoldingGuid) = ? and PhoneNo=?',
      whereArgs: [
        element.HandHoldingGuid!.toLowerCase(),
        element.phoneNo,
      ],
    );

    if (result.isNotEmpty) {
      await db!.update(
        Constants.Training_HandHolding_Particepent,
        element.toJson(),
        where: 'Lower(HandHoldingGuid) = ? and PhoneNo=?',
        whereArgs: [
          element.HandHoldingGuid!.toLowerCase(),
          element.phoneNo,
        ],
      );
    } else {
      await db!
          .insert(Constants.Training_HandHolding_Particepent, element.toJson());
    }
  }

  Future<void> saveHandHoldingDataAttendance(
      TrainingHandHoldingAttendance element) async {
    // await db!.delete(Constants.TrainingSchedule);

    final List<Map<String, dynamic>> result = await db!.query(
      Constants.Training_HandHolding_Attendance,
      where: 'Lower(HandHoldingGuid) = ? and MobileNo=?',
      whereArgs: [element.handHoldingGuid!.toLowerCase(), element.mobileNo],
    );

    if (result.isNotEmpty) {
      /* await db!.update(
        Constants.Training_HandHolding_Attendance,
        element.toJson(),
        where: 'Lower(HandHoldingGuid) = ? and MobileNo=? ',
        whereArgs: [
          element.handHoldingGuid!.toLowerCase(),
          element.mobileNo
        ],
      );*/
    } else {
      await db!
          .insert(Constants.Training_HandHolding_Attendance, element.toJson());
    }
  }

  Future<void> saveHandHoldingData(TblTrainingHandHolding element) async {
    final List<Map<String, dynamic>> result = await db!.query(
      Constants.Training_HandHolding,
      where: 'Lower(HandHoldingGuid) = ?',
      whereArgs: [
        element.handHoldingGuid!.toLowerCase(),
      ],
    );

    if (result.isNotEmpty) {
      await db!.update(
        Constants.Training_HandHolding,
        element.toJson(),
        where: 'Lower(HandHoldingGuid) = ? ',
        whereArgs: [
          element.handHoldingGuid!.toLowerCase(),
        ],
      );
    } else {
      await db!.insert(Constants.Training_HandHolding, element.toJson());
    }
  }

  Future<void> deleteHandHoldingAttendance(String guid) async {
    String tableName = Constants.Training_HandHolding_Attendance;
    await db!.delete(tableName,
        where: "Lower(HandHoldingGuid) = ? ", whereArgs: [guid.toLowerCase()]);
  }

  Future<void> insertHandHoldingAttendance(
      TrainingHandHoldingAttendance attendance) async {
    String tableName = Constants.Training_HandHolding_Attendance;
    await db!.insert(tableName, attendance.toJson());
  }

  Future<void> updateHandHolingFlag(String guid) async {
    String tableName = Constants.Training_HandHolding_Attendance;
    //
    // await db!.insert(tableName, attendance.toJson());

    await db!.rawQuery(
        'Update ${tableName} set isEdited=\'0\' where HandHoldingGuid=\'${guid}\' ');
  }

  Future<List<TrainingHandHoldingAttendance>> getHandHoldAttendance(
      String guid) async {
    String tableName = Constants.Training_HandHolding_Attendance;
    final List<Map<String, dynamic>> result = await db!.query(
      tableName,
      where: 'Lower(HandHoldingGuid) = ? ',
      whereArgs: [guid.toLowerCase()],
    );
    List<TrainingHandHoldingAttendance> trainingSurveyQuestionData = [];
    for (var element in result) {
      TrainingHandHoldingAttendance trainingSurveyQuestionDatum =
          TrainingHandHoldingAttendance.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<List<TrainingHandHoldingAttendance>> uploadHandHoldAttendance() async {
    String tableName = Constants.Training_HandHolding_Attendance;
    final List<Map<String, dynamic>> result = await db!.rawQuery(
        'SELECT DISTINCT HandHoldingGuid FROM $tableName where isEdited=1');
    List<TrainingHandHoldingAttendance> trainingSurveyQuestionData = [];
    for (var element in result) {
      TrainingHandHoldingAttendance trainingSurveyQuestionDatum =
          TrainingHandHoldingAttendance.fromJson(element);
      trainingSurveyQuestionData.add(trainingSurveyQuestionDatum);
    }
    return trainingSurveyQuestionData;
  }

  Future<List<ParticipantScanDetails>> getParticipantOfflineRecord() async {
    String tableName = Constants.particepent_scan_details;
    List<ParticipantScanDetails> allData = [];

    final List<Map<String, dynamic>> maps = await db!.query(
      tableName,
      where: 'IsEdited = ? ',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      for (var element in maps) {
        ParticipantScanDetails trainingSurveyQuestionDatum =
            ParticipantScanDetails.fromJson(element);
        allData.add(trainingSurveyQuestionDatum);
      }
    }
    return allData;
  }

  Future<List<SurveyResponse>> getSurveyDataForUpload(
      String? surveyId, String? mobileNo, String? regGuid) async {
    List<SurveyResponse> stateData = [];
    try {
      final List<Map<String, dynamic>> maps = await db!.query(
          Constants.Survey_Response,
          where:
              'SurveyId = ? and MobileNo=? and Lower(RegistrationGuid)=? and IsEdited=?',
          whereArgs: [surveyId, mobileNo, regGuid!.toLowerCase(), 1]);

      for (var element in maps) {
        SurveyResponse state = SurveyResponse.fromJson(element);
        stateData.add(state);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    return stateData;
  }

  Future<List<SurveyResponse>> getSurveyDataOfflineForUpload(
      String? mobileNo) async {
    List<SurveyResponse> stateData = [];
    try {
      final List<Map<String, dynamic>> maps = await db!.query(
          Constants.Survey_Response,
          where: 'MobileNo=? and IsEdited=?',
          whereArgs: [mobileNo, 1]);

      for (var element in maps) {
        SurveyResponse state = SurveyResponse.fromJson(element);
        stateData.add(state);
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    return stateData;
  }

  Future<List<TblBatchAttendanceData>> getBatchAttendanceList(
      String? regGuid) async {
    final List<Map<String, dynamic>> maps;
    if (regGuid != null && regGuid.isNotEmpty) {
      maps = await db!.query(Constants.tblBatch_Attendance,
          where: 'LOWER(RegistrationGuid) = ? ',
          whereArgs: [regGuid!.toLowerCase()]);
    } else {
      maps = await db!.query(Constants.tblBatch_Attendance);
    }

    List<TblBatchAttendanceData> trainingParticipant = [];
    for (var element in maps) {
      TblBatchAttendanceData state = TblBatchAttendanceData.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  Future<List<TblBatchPartialAttendanceData>> getBatchPartialAttendanceList(
      String? regGuid) async {
    final List<Map<String, dynamic>> maps;
    if (regGuid != null && regGuid.isNotEmpty) {
      maps = await db!.query(Constants.tblPartial_Attendance,
          where: 'LOWER(RegistrationGuid) = ? ',
          whereArgs: [regGuid!.toLowerCase()]);
    } else {
      maps = await db!.query(Constants.tblPartial_Attendance);
    }

    List<TblBatchPartialAttendanceData> trainingParticipant = [];
    for (var element in maps) {
      TblBatchPartialAttendanceData state =
          TblBatchPartialAttendanceData.fromJson(element);
      trainingParticipant.add(state);
    } //"9767F57C-C886-47EE-B32B-0C9426713433" "9767f57c-c886-47ee-b32b-0c9426713433"

    return trainingParticipant;
  }

  insertErrorLog(ErrorLog errorlog) {
    db!.insert('tbl_error_logs', errorlog.toMap());
  }

  Future<List<NotificationModel>> getNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson =
        prefs.getStringList(SecureStorageKeys.notificationData);

    if (tasksJson == null) {
      return [];
    }

    return tasksJson
        .map((taskJson) => NotificationModel.fromMap(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> insertNotification(NotificationModel task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<NotificationModel> tasks = await getNotification();
    tasks.add(task);
    await prefs.setStringList(SecureStorageKeys.notificationData,
        tasks.map((task) => jsonEncode(task.toMap())).toList());
  }

  /* Future<void> updateTask(NotificationModel updatedTask) async {
    final prefs = await SharedPreferences.getInstance();
    List<NotificationModel> tasks = await getNotification();
    tasks = tasks.map((task) => task.id == updatedTask.id ? updatedTask : task).toList();
    await prefs.setStringList(_key, tasks.map((task) => jsonEncode(task.toMap())).toList());
  }*/

  Future<void> deleteNotification(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    List<NotificationModel> tasks = await getNotification();
    tasks.removeWhere((task) => task.notificationtype == taskId);
    await prefs.setStringList(SecureStorageKeys.notificationData,
        tasks.map((task) => jsonEncode(task.toMap())).toList());
    await prefs.clear();
  }
}

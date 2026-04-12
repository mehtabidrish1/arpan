import '../api/training_surveyQuestionOptionsApi.dart';
import '../api/training_surveyQuestionsApi.dart';
import '../database/dataProvider.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';

class DownloadData {
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
}

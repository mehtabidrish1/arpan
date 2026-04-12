import '../models/training_surveyQuestionModel.dart';

bool questionVisibe(TrainingSurveyQuestionDatum _surveyQuestion,
    Map<String, dynamic> paramsAll) {
  Map<String, Map<String, String>> _formdata = {};
  Map<String, String> _Childformdata = {};
  _formdata = paramsAll['_formdata'];
  _Childformdata = _formdata[_surveyQuestion.questionId.toString()] ?? {};

  if (_surveyQuestion.isDependent == 1 &&
      (_surveyQuestion.condition ?? '').isNotEmpty) {
    String skip_condition = _surveyQuestion.condition ?? '';
  }

  return true;
}

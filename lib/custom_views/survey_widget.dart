import 'package:arpan/custom_views/custom_dropdown_widget.dart';
import 'package:arpan/custom_views/custom_radio_widget.dart';
import 'package:arpan/custom_views/custom_rating_widget.dart';
import 'package:arpan/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

import '../models/training_surveyQuestionModel.dart';
import 'custom_checkbox_widget.dart';
import 'custom_text_widget.dart';

class SurveyWidget {
  List<Widget> createSurveyQuestionWidget(paramsAll,
      List<TrainingSurveyQuestionDatum> _SurveyQuestion, _updateState) {
    var customWidget = <Widget>[];
    for (var i = 0; i < _SurveyQuestion.length; i++) {
      var dynamicWidget;
      if (_SurveyQuestion[i].questionTypeId == 1) {
        dynamicWidget = CustomTextWidget(
          paramsAll,
          _SurveyQuestion[i],
          _updateState,
        );
      } else if (_SurveyQuestion[i].questionTypeId == 2) {
        dynamicWidget = CustomRatingWidget(
          paramsAll,
          _SurveyQuestion[i],
          _updateState,
        );
      } else if (_SurveyQuestion[i].questionTypeId == 4) {
        // dynamicWidget = CustomDropdownWidget(
        //   paramsAll,
        //   _SurveyQuestion[i],
        //   _updateState,
        // );
        dynamicWidget = CustomRadioWidget(
          paramsAll,
          _SurveyQuestion[i],
          _updateState,
        );
      } else if (_SurveyQuestion[i].questionTypeId == 5) {
        dynamicWidget = CustomCheckboxWidget(
          paramsAll,
          _SurveyQuestion[i],
          _updateState,
        );
      }
      if (dynamicWidget != null) {
        customWidget.add(dynamicWidget);
      }
    }
    return customWidget;
  }
}

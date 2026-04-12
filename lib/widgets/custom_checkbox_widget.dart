import 'package:flutter/material.dart';

import '../custom_views/custom_label_widget.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';

class CustomCheckboxWidget extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  final ValueChanged<int> update;
  final TrainingSurveyQuestionDatum _surveyQuestion;
  const CustomCheckboxWidget(this.paramsAll, this._surveyQuestion, this.update,
      {Key? key})
      : super(key: key);

  @override
  State<CustomCheckboxWidget> createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  late TrainingSurveyQuestionDatum _surveyQuestion;
  late Map<String, Object> _formdata;
  late Map<String, String> checkvalue = {};

  final dataKey = GlobalKey();
  late String keyvalue;
  late ValueChanged<int> update;

  List<TrainingSurveyQuestionOptionsDatum> _QuestionOption = [];
  @override
  void initState() {
    super.initState();

    update = widget.update;
    _surveyQuestion = widget._surveyQuestion;

    _formdata = widget.paramsAll['_formdata'];
    keyvalue = _surveyQuestion.questionId.toString();
    _QuestionOption = widget.paramsAll['questionOption']
        // .where((values) => values.flag == _surveyQuestion.flag)
        .where((values) => values.questionId == _surveyQuestion.questionId)
        .toList();
    setCheckedValue();

    //data = checkedValue(_formdata[keyvalue].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelWidget(
          _surveyQuestion,
          widget.paramsAll,
        ),
        Column(
          children: [
            for (var item in _QuestionOption)
              CheckboxListTile(
                title: Text('${item.text}'.toUpperCase()),
                value: checkvalue.containsKey(item.questionOptionId.toString()),
                onChanged: (value) {
                  setState(() {
                    if (!value!) {
                      checkvalue.remove(item.questionOptionId.toString());
                    } else {
                      checkvalue[item.questionOptionId.toString()!] =
                          item.questionOptionId.toString()!;
                    }

                    getCheckedValue();
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
          ],
        )
      ],
    );
  }

  void getCheckedValue() {
    var allValue = '';
    checkvalue.forEach((key, value) {
      if (allValue.length == 0) {
        allValue = value;
      } else {
        allValue = allValue + ',' + value;
      }
    });
    _formdata[_surveyQuestion.questionId.toString()] = allValue;
  }

  void setCheckedValue() {
    var allValue = _formdata[_surveyQuestion.questionId.toString()].toString();
    if (allValue.isNotEmpty) {
      if (allValue.contains(',')) {
        var value = allValue.split(',');
        value.forEach((element) {
          checkvalue[element] = element;
        });
      } else {
        checkvalue[allValue] = allValue;
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/style/style1.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';
import '../utils/lableText.dart';
import 'custom_label_widget.dart';

class CustomRadioWidget extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  final ValueChanged<int> update;
  final TrainingSurveyQuestionDatum _surveyQuestion;
  const CustomRadioWidget(this.paramsAll, this._surveyQuestion, this.update,
      {Key? key})
      : super(key: key);

  @override
  State<CustomRadioWidget> createState() => _CustomRadioWidgetState();
}

class _CustomRadioWidgetState extends State<CustomRadioWidget> {
  late TrainingSurveyQuestionDatum _surveyQuestion;
  late TrainingSurveyQuestionDatum _surveyQuestionFixed;

  late Map<String, Map<String, String>> _formdata;
  late Map<String, String> _Childformdata = {};
  final dataKey = GlobalKey();
  late String keyvalue;
  TextEditingController myController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode();
  late ValueChanged<int> update;
  late Map<String, String> skip = {};
  List<String> items = [];

  // ignore: non_constant_identifier_names
  List<TrainingSurveyQuestionOptionsDatum> _QuestionOption = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    update = widget.update;
    _surveyQuestion = widget._surveyQuestion;
    _surveyQuestionFixed = _surveyQuestion;
    _formdata = widget.paramsAll['_formdata'];
    _Childformdata = _formdata[_surveyQuestion.questionId.toString()] ?? {};
    keyvalue = _surveyQuestion.questionId.toString();
    _QuestionOption = widget.paramsAll['questionOption']
        // .where((values) => values.flag == _surveyQuestion.flag)
        .where((values) => values.questionId == _surveyQuestion.questionId)
        .toList();
    for (int i = 0; i < _QuestionOption.length; i++) {
      items.add(returnTextValue(_QuestionOption[i]));
    }
    if (_Childformdata.containsKey('other')) {
      myController.text = _Childformdata['other'].toString();
    } else {
      myController.text = '';
    }
    setState(() {});
  }

  var languageId = 1;

  @override
  void initState() {
    super.initState();
    languageId = widget.paramsAll['languageId'];
  }

  @override
  Widget build(BuildContext context) {
    var pick = '';
    _formdata = widget.paramsAll['_formdata'];
    if (_formdata.containsKey(keyvalue)) {
      _Childformdata = _formdata[keyvalue] ?? {};
      pick = _Childformdata[keyvalue] ?? '';
    }

    skip = widget.paramsAll['skip'];
    var isVisible = true;
    if (skip.containsValue(_surveyQuestion.questionId.toString())) {
      isVisible = false;
      _surveyQuestion.isQuestionMandatory = 0;
      _formdata.remove(_surveyQuestion.questionId.toString());
      _Childformdata.clear();
    } else {
      _surveyQuestion = _surveyQuestionFixed;
    }
    return Visibility(
      visible: isVisible,
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomLabelWidget(
            _surveyQuestion,
            widget.paramsAll,
          ),
          Column(
            children: _QuestionOption.map((e) {
              return RadioListTile<String>(
                title: Text(returnTextValue(e)),
                value: e.questionOptionId.toString(),
                groupValue: pick,
                onChanged: (String? value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _Childformdata[keyvalue] = value!;
                  _formdata[keyvalue] = _Childformdata;

                  update(1);
                },
              );
            }).toList(),
            // [
            //   if (items != null && items.isNotEmpty) ...[
            //     for (var item in items) ...[
            //       Row(
            //         children: [
            //           SizedBox(
            //             height: 30.h,
            //             width: 30.h,
            //             child: Radio<String>(
            //               value: item,
            //               groupValue: pick,
            //               onChanged: (checked) async {
            //                 FocusScope.of(context).requestFocus(FocusNode());
            //                 _Childformdata[keyvalue] = checked!;
            //                 _formdata[keyvalue] = _Childformdata;

            //                 update(1);
            //               },
            //             ),
            //           ),
            //           Text(item),
            //         ],
            //       )
            //     ],
            //   ]
            // ],
          )
        ],
      ),
    );
  }

  returnTextValue(TrainingSurveyQuestionOptionsDatum item) {
    String value = item.text ?? '';
    if (languageId == 2) {
      value = item.textHindi ?? item.text ?? '';
    } else if (languageId == 3) {
      value = item.textMarathi ?? item.text ?? '';
    }
    return value;
  }
}

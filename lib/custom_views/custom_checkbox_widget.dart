import 'package:flutter/material.dart';

import '../constants/style/style1.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';
import '../utils/lableText.dart';
import 'custom_label_widget.dart';

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
  late TrainingSurveyQuestionDatum _surveyQuestionFixed;
  late List<TrainingSurveyQuestionDatum> _surveyQuestionAll;
  late Map<String, Map<String, String>> _formdata;
  late Map<String, String> _Childformdata = {};
  late Map<String, String> checkvalue = {};
  late Map<String, String> skip = {};

  TextEditingController myController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode();

  final dataKey = GlobalKey();
  late String keyvalue;
  late ValueChanged<int> update;

  List<TrainingSurveyQuestionOptionsDatum> _QuestionOption = [];
  var languageId=1;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
     languageId=widget.paramsAll['languageId'];

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
    setCheckedValue();

    if (_Childformdata.containsKey('other')) {
      myController.text = _Childformdata['other'].toString();
    } else {
      myController.text = '';
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
 languageId=widget.paramsAll['languageId'];

    //data = checkedValue(_formdata[keyvalue].toString());
  }

  @override
  Widget build(BuildContext context) {
    _formdata = widget.paramsAll['_formdata'];

    skip = widget.paramsAll['skip'];
    var isVisible = true;
    if (skip.containsValue(_surveyQuestion.questionId.toString())) {
      isVisible = false;
      _surveyQuestion.isQuestionMandatory = 0;
      checkvalue.clear();

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
            children: [
              for (var item in _QuestionOption) ...[
                CheckboxListTile(
                  title: Text(
                    '${returnTextValue(item)}'.toUpperCase(),
                    style: Styles.grey12500,
                  ),
                  value:
                      checkvalue.containsKey(item.questionOptionId.toString()),
                  onChanged: (value) {
                    setState(() {
                      if (!value!) {
                        checkvalue.remove(item.questionOptionId.toString());
                        if (item.isOther == 1) {
                          _Childformdata.remove('other');
                          myController.text = '';
                        }
                        if (skip.containsKey(
                                '${item.questionId}${item.questionOptionId}') &&
                            (item.skippedQuestionIds == null ||
                                item.skippedQuestionIds!.isEmpty)) {
                          skip.remove(
                              '${item.questionId}${item.questionOptionId}');
                        }
                      } else {
                        if (item.isOther == 1) {
                          _Childformdata['other'] = '';
                        }
                        checkvalue[item.questionOptionId.toString()!] =
                            item.questionOptionId.toString()!;
                        if (item.skippedQuestionIds != null &&
                            item.skippedQuestionIds!.isNotEmpty) {
                          skip['${item.questionId}${item.questionOptionId}'] =
                              item.skippedQuestionIds!;
                        }
                      }

                      getCheckedValue();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
              if (_Childformdata.containsKey('other')) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: _textFieldFocusNode,
                    key: Key('$keyvalue other'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _textFieldFocusNode.requestFocus();
                        return LabelText.getText('Otherempty');
                      }
                      return null;
                    },

                    maxLength: 250,
                    // onEditingComplete: () {
                    //   checkValidation();
                    // },
                    controller: myController,
                    onChanged: (val) async {
                      _Childformdata['other'] = val;
                      _formdata[keyvalue] = _Childformdata;

                      // update(1);
                    },
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                      hintText: LabelText.getText('Other'),
                      label: Text(LabelText.getText('Other')),
                      counterText: "",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ],
          )
        ],
      ),
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
    _Childformdata[_surveyQuestion.questionId.toString()] = allValue;
    _formdata[_surveyQuestion.questionId.toString()] = _Childformdata;
  }

  void setCheckedValue() {
    var allValue = _Childformdata[_surveyQuestion.questionId.toString()] ?? '';
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

  returnTextValue(TrainingSurveyQuestionOptionsDatum item)
  {
     String value=item.text??'';
    if(languageId==2){
     value=item.textHindi??item.text??'';
    }else
      if(languageId==3){
     value=item.textMarathi??item.text??'';
    
    }
    return value;
  }
}

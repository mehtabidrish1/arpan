import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/style/style1.dart';
import '../models/training_surveyQuestionModel.dart';
import '../models/training_surveyQuestionOptionsModel.dart';
import '../utils/lableText.dart';
import 'custom_label_widget.dart';

class CustomDropdownWidget extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  final ValueChanged<int> update;
  final TrainingSurveyQuestionDatum _surveyQuestion;
  const CustomDropdownWidget(this.paramsAll, this._surveyQuestion, this.update,
      {Key? key})
      : super(key: key);

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
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
    if (_Childformdata.containsKey('other')) {
      myController.text = _Childformdata['other'].toString();
    } else {
      myController.text = '';
    }
    setState(() {});
  }
  var languageId=1;

  @override
  void initState() {
    super.initState();
     languageId=widget.paramsAll['languageId'];

  }

  @override
  Widget build(BuildContext context) {
    _formdata = widget.paramsAll['_formdata'];

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<TrainingSurveyQuestionOptionsDatum>(
                        focusColor: Colors.transparent,
                        isExpanded: true,
                        key: Key(
                          keyvalue,
                        ),
                        hint: Text(LabelText.getText('pleaseSelect')),
                        value: _Childformdata[_surveyQuestion.questionId
                                        .toString()] !=
                                    null &&
                                _QuestionOption != null
                            ? _QuestionOption.firstWhere(
                                (element) =>
                                    element.questionOptionId
                                        .toString()
                                        .toString() ==
                                    _Childformdata[
                                        _surveyQuestion.questionId.toString()],
                              )
                            : null,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: Styles.grey12500,
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        // ignore: prefer_null_aware_operators
                        items: _QuestionOption != null
                            ? _QuestionOption.map((e) => DropdownMenuItem(
                                value: e, child: Text(returnTextValue(e)))).toList()
                            : null,
                        onChanged: (val) async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _Childformdata[
                                  _surveyQuestion.questionId.toString()] =
                              val?.questionOptionId.toString()! as String;
                          if (val!.isOther == 1) {
                            _Childformdata['other'] = '';
                          } else {
                            _Childformdata.remove('other');
                            myController.text = '';
                          }

                          _formdata[_surveyQuestion.questionId.toString()] =
                              _Childformdata;
                          if (skip.containsKey(val.questionId) &&
                              (val.skippedQuestionIds == null ||
                                  val.skippedQuestionIds!.isEmpty)) {
                            skip.remove(val.questionId);
                          } else if (val.skippedQuestionIds != null &&
                              val.skippedQuestionIds!.isNotEmpty) {
                            skip[val.questionId!] = val.skippedQuestionIds!;
                          }

                          //  setState(() {
                          update(1);
                          // });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (_Childformdata.containsKey('other')) ...[
                  TextFormField(
                    focusNode: _textFieldFocusNode,
                    key: Key('$keyvalue other'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _textFieldFocusNode.requestFocus();
                        return LabelText.getText('Otherempty');
                      }
                      return null;
                    },

                    // keyboardType: inputType,
                    //inputFormatters: inputFormattersvalue,
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
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
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

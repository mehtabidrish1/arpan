import 'package:arpan/custom_views/custom_label_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/training_surveyQuestionModel.dart';

class CustomTextWidget extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  final ValueChanged<int> update;
  final TrainingSurveyQuestionDatum _surveyQuestion;
  const CustomTextWidget(this.paramsAll, this._surveyQuestion, this.update,
      {Key? key})
      : super(key: key);

  @override
  State<CustomTextWidget> createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  late TrainingSurveyQuestionDatum _surveyQuestion;
  late TrainingSurveyQuestionDatum _surveyQuestionFixed;
  late Map<String, String> skip = {};

  late Map<String, Map<String, String>> _formdata;
  late Map<String, String> _Childformdata = {};

  final dataKey = GlobalKey();
  late String keyvalue;
  //List<MaskValidation> _maskValidation;
  late ValueChanged<int> update;
  late TextInputType inputType;
  late int length;
  TextEditingController myController = TextEditingController();
  FocusNode _textFieldFocusNode = FocusNode();
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
    inputType = TextInputType.text;
    length = _surveyQuestion.maxLength ?? 50;

    if (_Childformdata.containsKey(keyvalue)) {
      myController.text = _Childformdata[keyvalue].toString();
    } else {
      myController.text = '';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _formdata = widget.paramsAll['_formdata'];

    skip = widget.paramsAll['skip'];
    var isVisible = true;
    if (skip.containsValue(_surveyQuestion.questionId.toString())) {
      isVisible = false;
      _formdata.remove(_surveyQuestion.questionId.toString());
      _surveyQuestion.isQuestionMandatory = 0;
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
            child: TextFormField(
              key: Key(keyvalue),
              keyboardType: inputType,
              //inputFormatters: inputFormattersvalue,
              maxLength: length,
              // onEditingComplete: () {
              //   checkValidation();
              // },
              focusNode: _textFieldFocusNode,
              validator: (value) {
                if (_surveyQuestion.isQuestionMandatory == 1 &&
                    (value == null || value.isEmpty)) {
                  _textFieldFocusNode.requestFocus();
                  return '${_surveyQuestion.question} is empty';
                }
                return null;
              },
              controller: myController,
              onChanged: (val) async {
                _Childformdata[keyvalue] = val;
                _formdata[keyvalue] = _Childformdata;

                // update(1);
              },
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
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
        ],
      ),
    );
  }
}

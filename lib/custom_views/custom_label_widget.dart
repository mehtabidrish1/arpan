import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants/style/style1.dart';
import '../models/training_surveyQuestionModel.dart';
import '../utils/lableText.dart';
import 'custom_dialog.dart';

class CustomLabelWidget extends StatefulWidget {
  final TrainingSurveyQuestionDatum _SurveyQuestion;
  final Map<String, dynamic> paramsAll;
  const CustomLabelWidget(this._SurveyQuestion, this.paramsAll, {Key? key})
      : super(key: key);

  @override
  State<CustomLabelWidget> createState() => _CustomLabelWidgetState();
}

class _CustomLabelWidgetState extends State<CustomLabelWidget> {
  int languageId = 1;
  @override
  Widget build(BuildContext context) {
    languageId = widget.paramsAll['languageId'];
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: widget._SurveyQuestion.isQuestionMandatory == 1
                        ? '*'
                        : '  ',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: widget._SurveyQuestion.questionNo ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: (' ')),
                  TextSpan(
                    text: (retunQuestion()),
                    style: Styles.black134,
                  ),
                  if (retunInstruction() != null &&
                      retunInstruction().toString().length > 2) ...[
                    TextSpan(text: ('\n')),
                    TextSpan(
                      text: retunInstruction(),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expanded(child: Text('_projectMorbidityQuestion   projectMorbidityQuestionInstructions_projectMorbidityQuestion   projectMorbidityQuestionInstructions_projectMorbidityQuestion   projectMorbidityQuestionInstructions_projectMorbidityQuestion   projectMorbidityQuestionInstructions_projectMorbidityQuestion   projectMorbidityQuestionInstructions')),

          (retunInstruction() != null &&
                  retunInstruction().toString().length > 2)
              ? IconButton(
                  alignment: Alignment.topCenter,
                  visualDensity: VisualDensity.compact,
                  iconSize: 24.0,
                  onPressed: () {
                    customDialog(
                      context,
                      title: 'Q-' +
                          widget._SurveyQuestion.questionNo! +
                          ' ' +
                          retunQuestion(),
                      content: retunInstruction(),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            LabelText.close,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  icon: Icon(
                    Icons.info,
                    color: Theme.of(context).indicatorColor,
                  ),
                )
              : const SizedBox(
                  height: 36,
                  width: 36,
                )
        ],
      ),
    );
  }

  String retunQuestion() {
    String value = widget._SurveyQuestion.question ?? '';
    if (languageId == 2) {
      value = widget._SurveyQuestion.questionHindi ??
          widget._SurveyQuestion.question ??
          '';
    } else if (languageId == 3) {
      value = widget._SurveyQuestion.questionMarathi ??
          widget._SurveyQuestion.question ??
          '';
    }
    return value;
  }

  String retunInstruction() {
    String value = widget._SurveyQuestion.questionInstructions ?? '';
    if (languageId == 2) {
      value = widget._SurveyQuestion.questionInstructionsHindi ??
          widget._SurveyQuestion.questionInstructions ??
          '';
    } else if (languageId == 3) {
      value = widget._SurveyQuestion.questionInstructionsMarathi ??
          widget._SurveyQuestion.questionInstructions ??
          '';
    }
    return value;
  }
}

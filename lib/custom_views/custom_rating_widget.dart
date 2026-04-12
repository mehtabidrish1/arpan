import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/training_surveyQuestionModel.dart';
import 'custom_label_widget.dart';

class CustomRatingWidget extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  final ValueChanged<int> update;
  final TrainingSurveyQuestionDatum _surveyQuestion;
  const CustomRatingWidget(this.paramsAll, this._surveyQuestion, this.update,
      {Key? key})
      : super(key: key);

  @override
  State<CustomRatingWidget> createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  late TrainingSurveyQuestionDatum _surveyQuestion;
  late Map<String, Map<String, String>> _formdata;
  late Map<String, String> _Childformdata = {};
  late Map<String, String> checkvalue = {};
  List<String> items = [];

  final dataKey = GlobalKey();
  late String keyvalue;
  late ValueChanged<int> update;
   int languageId=1;
  @override
  void initState() {
    super.initState();
 languageId=widget.paramsAll['languageId'];
    update = widget.update;
    _surveyQuestion = widget._surveyQuestion;

    _formdata = widget.paramsAll['_formdata'];
    _Childformdata = _formdata[_surveyQuestion.questionId.toString()] ?? {};
    keyvalue = _surveyQuestion.questionId.toString();
    int ratingStartValue = _surveyQuestion.ratingStartValue ?? 0;
    int ratingEndValue = _surveyQuestion.ratingEndValue ?? 0;
    for (int i = ratingStartValue; i <= ratingEndValue; i++) {
      items.add(i.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var pick = '';
    if (_formdata.containsKey(keyvalue)) {
      _Childformdata = _formdata[keyvalue] ?? {};
      pick = _Childformdata[keyvalue] ?? '';
    }

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabelWidget(
          _surveyQuestion,
          widget.paramsAll,
        ),
        Container(
          height: 80.h*(items.length/5),
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 5,
            children: [
              if (items != null && items.isNotEmpty) ...[
                for (var item in items) ...[
                  Row(
                    children: [
                      SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: Radio<String>(
                          value: item,
                          groupValue: pick,
                          onChanged: (checked) async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _Childformdata[keyvalue] = checked!;
                            _formdata[keyvalue] = _Childformdata;

                            update(1);
                          },
                        ),
                      ),
                      Text(item),
                    ],
                  )
                ],
              ]
            ],
          ),
        )
      ],
    );
  }
  /*
   Container(
              child: FlutterRadioGroup(
                titles: items,
                labelVisible: false,
                // defaultSelected: items.indexOf(pick),

                orientation: RGOrientation.HORIZONTAL,
                onChanged: (index) async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var checked = items[index!];
                  update(1);
                },
                // ),
              ),
            )
  */
}

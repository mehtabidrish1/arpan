import 'dart:convert';

import 'package:arpan/utils/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../../api/survey_response_api.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../custom_views/survey_widget.dart';
import '../../../database/dataProvider.dart';
import '../../../models/training_surveyQuestionModel.dart';
import '../../../models/training_surveyQuestionOptionsModel.dart';
import '../../../table_model/notification_model.dart';
import '../../../table_model/tbl_participant_scan_details.dart';
import '../../../table_model/tblsurvey_response.dart';
import '../../../utils/DownloadData.dart';
import '../../../utils/arpan_notification.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_loading_indicator.dart';

class SurveyQuestionsScreen extends StatefulWidget {
  final surveyId;
  final String? presurvey;
  final String? registrationGuidval;
  final String? scheduleGuid;
  final ParticipantScanDetails userdetails;

  const SurveyQuestionsScreen(this.surveyId, this.presurvey,
      this.registrationGuidval, this.scheduleGuid, this.userdetails,
      {Key? key})
      : super(key: key);

  @override
  State<SurveyQuestionsScreen> createState() => _SurveyQuestionsScreenState();
}

class _SurveyQuestionsScreenState extends State<SurveyQuestionsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final _formKey = GlobalKey<FormState>();

  late List<TrainingSurveyQuestionDatum> preSurveyQuestion = [];
  late List<TrainingSurveyQuestionOptionsDatum> preSurveyQuestionOpt = [];
  Map<String, Map<String, String>> _formdata = {};
  Map<String, dynamic> paramsAll = {};
  Map<String, String> questionSkiped = {};

  Map<String, Object> focusSet = {};
  var mobileNo;
  var isDisposed = false;
  ParticipantScanDetails _userdetails = ParticipantScanDetails();
  int languageId = 1;
  bool _isLoading = false;

  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];

  @override
  void initState() {
    super.initState();
    LabelText.getLang(languageId);
    getQuestions();
  }

  Future<void> getQuestions() async {
    if (!isDisposed) {
      widget.registrationGuidval;
      var langID = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.langId);
      if (langID != null) {
        languageId = int.parse(langID);
        LabelText.getLang(languageId);
        selectedLanguagevalue = languages[languageId - 1];
      }

      mobileNo = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.phone);
      preSurveyQuestion =
          await DataProvider().getTrainingSurveyQuestions(widget.surveyId);
      preSurveyQuestionOpt = await DataProvider()
          .getTrainingSurveyQuestionOptions(widget.surveyId);
      _userdetails = await DataProvider()
          .getParticipantScanDetailsReg(mobileNo!, widget.registrationGuidval!);
      setState(() {
        isDisposed = true;
      });
      //  surveyFinised();
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.grey.shade300,
        //backgroundColor: ProjectThemeValue.getTheme('Themeprimary_color', ProjectThemeValue.Themeprimary_color, allTheme),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.popAndPushNamed(
            context,
            RouteConstants.questionListScreen,
          ),
        ),
        title: Text(
          widget.presurvey!,
          style: TextStyle(color: Colors.black),
        ),

        actions: [
          Center(
            child: Text(
              selectedLanguagevalue,
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language,
              color: Colors.green,
            ),
            offset: Offset(0, 60),
            onSelected: (selectedLanguage) async {
              selectedLanguagevalue = selectedLanguage!;

              LabelText.getLang(languages.indexOf(selectedLanguagevalue) + 1);
              await customSecureStorage.writeSecureValue(
                  key: SecureStorageKeys.langId,
                  value: (languages.indexOf(selectedLanguagevalue) + 1)
                      .toString());
              languageId = languages.indexOf(selectedLanguagevalue) + 1;

              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return languages.map((String language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language.trim()),
                );
              }).toList();
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: refreshPageQuestions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: Text('Loading...'));
                  default:
                    if (snapshot.hasError) {
                      return const SizedBox(
                        height: 10,
                      );
                    } else if (preSurveyQuestion.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Survey questions not available. Please try again.'),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null // Disable button when loading
                                : () async {
                                    var internet = await Validate()
                                        .checkInternetConnectivity();
                                    if (internet) {
                                      setState(() {
                                        isDisposed = false;
                                        _isLoading = true;
                                      });

                                      await DownloadData()
                                          .downloadTrainingSurveyQuestions(
                                              widget.surveyId);
                                      await DownloadData()
                                          .downloadTrainingSurveyQuestionsOpt(
                                              widget.surveyId);
                                      await getQuestions();

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      Toast.show('Internet Connection Required',
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                    }
                                  },
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text('Retry'),
                          )
                        ],
                      ));
                    } else {
                      paramsAll['questionOption'] = preSurveyQuestionOpt;
                      paramsAll['languageId'] = languageId;
                      // paramsAll['SurveyQuestion'] = preSurveyQuestion;
                      paramsAll['_formdata'] = _formdata;
                      paramsAll['focusSet'] = focusSet;
                      List<TrainingSurveyQuestionDatum> preSurveyQuestionData =
                          snapshot.data ?? [];
                      paramsAll['SurveyQuestion'] = preSurveyQuestionData;
                      paramsAll['skip'] = questionSkiped;

                      return SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CreateQuestionView(paramsAll),
                          ),
                        ),
                      );
                    }
                }
              },
            ),
      bottomNavigationBar: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
              buttonColor: Colors.green,
              // buttonColor: ColorConstants.defaultRedColor,
              textColor: ColorConstants.whiteColorText,
              buttonTitle: LabelText.getText('submit'),
              height: 49.h,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await saveSurverData();
                }
              }),
        ),
      ),
    );
  }

  saveSurverData() async {
    bool isFiled = checkValidation();
    if (!isFiled) {
      return;
    }
    List<SurveyResponse> surveyResponseData = [];
    if (_formdata.isNotEmpty) {
      _formdata.forEach((key, value) {
        Map<String, String> _Childformdata = value;
        var surveydata = SurveyResponse();
        surveydata.surveyId = widget.surveyId.toString();
        surveydata.mobileNo = mobileNo;
        surveydata.registrationGuid = widget.registrationGuidval!;
        surveydata.scheduleGuid = widget.scheduleGuid;
        surveydata.questionId = key;
        surveydata.languageID = languageId.toString();
        surveydata.response = _Childformdata[key];
        surveydata.isEdited = 1;
        if (_Childformdata.containsKey('other')) {
          surveydata.otherResponse = _Childformdata['other'];
        } else {
          surveydata.otherResponse = '';
        }
        surveydata.createdOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
        //if (key.toLowerCase() == '${key}_other')

        surveyResponseData.add(surveydata);
      });
      print(surveyResponseData);

      // _userdetails.isEdited = 1;
      // await DataProvider().insertOrUpdateParticepent(_userdetails);
      await DataProvider().insertSurveyData(surveyResponseData, mobileNo);
      if (widget.presurvey == LabelText.presurvey) {
        // await ArpanNotification().displayNotification(            'Arpan', 'Pre survey questions filled successfully');
        await DataProvider().deleteNotification('1');
        await DataProvider().insertNotification(NotificationModel(
            notificationtype: '1',
            notificationmsg: 'Pre survey questions filled successfully'));

        setState(() {});
      } else if (widget.presurvey == LabelText.postsurvey) {
        //   await ArpanNotification().displayNotification(            'Arpan', 'Post survey questions filled successfully');
        await DataProvider().insertNotification(NotificationModel(
            notificationtype: '1',
            notificationmsg: 'Post survey questions filled successfully'));

        setState(() {});
      }

      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            FocusScope.of(context).unfocus();
            isDisposed = true;
            if (await checkForComplete()) {
              surveyFinised();
            } else {
              await Navigator.popAndPushNamed(
                  context, RouteConstants.questionListScreen,
                  result: null);
            }
          },
          func: () async {
            String jsonBatch = jsonEncode(surveyResponseData);
            var response = await SurveyResponseAPI()
                .postSurveyResponse(postBody: jsonDecode(jsonBatch));
            if (response.isSuccess) {
              for (var element in surveyResponseData) {
                element.isEdited = 0;
              }
              await DataProvider()
                  .insertSurveyData(surveyResponseData, mobileNo);
              // _userdetails.isEdited = 0;
              // await DataProvider().insertOrUpdateParticepent(_userdetails);
              return LabelText.success;
            } else {
              return LabelText.uploadFailed;
            }
          },
          goOnline: false,
          title: LabelText.pleaseWait,
        ),
      );

      return true;
    }
  }

  bool checkValidation() {
    List<TrainingSurveyQuestionDatum> preSurveyQuestionData =
        paramsAll['SurveyQuestion'];
    for (var element in preSurveyQuestionData) {
      if (element.isQuestionMandatory == 1 &&
          !_formdata.containsKey(element.questionId.toString())) {
        Toast.show('${element.question} is mandatory',
            duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
        return false;
        break;
      }
    }

    return true;
  }

  Future<List<TrainingSurveyQuestionDatum>> refreshPageQuestions() async {
    return preSurveyQuestion;
  }

  Future<bool> checkForComplete() async {
    var surveyIdList = _userdetails.surveyId?.split(",");
    String preSurveyId = surveyIdList != null ? surveyIdList[0] : '0';
    String postSurveyId = surveyIdList != null ? surveyIdList[1] : '0';
    String feedbackSurveyId = surveyIdList != null ? surveyIdList[2] : '0';

    int isPrefield = await DataProvider()
        .getSurveyData(preSurveyId, mobileNo, _userdetails.registrationGuid);
    int isPostfield = await DataProvider()
        .getSurveyData(postSurveyId, mobileNo, _userdetails.registrationGuid);
    int isFeedbackfield = await DataProvider().getSurveyData(
        feedbackSurveyId, mobileNo, _userdetails.registrationGuid);

    if (preSurveyId != '0' &&
        postSurveyId != '0' &&
        feedbackSurveyId != '0' &&
        isPrefield > 0 &&
        isPostfield > 0 &&
        isFeedbackfield > 0) {
      return true;
    } else if (preSurveyId == '0' &&
        postSurveyId != '0' &&
        feedbackSurveyId != '0' &&
        isPostfield > 0 &&
        isFeedbackfield > 0) {
      return true;
    } else if (postSurveyId == '0' &&
        preSurveyId != '0' &&
        feedbackSurveyId != '0' &&
        isPrefield > 0 &&
        isFeedbackfield > 0) {
      return true;
    } else if (feedbackSurveyId == '0' &&
        postSurveyId != '0' &&
        preSurveyId != '0' &&
        isPostfield > 0 &&
        isPrefield > 0) {
      return true;
    } else if (preSurveyId == '0' &&
        postSurveyId == '0' &&
        feedbackSurveyId != '0' &&
        isFeedbackfield > 0) {
      return true;
    } else if (preSurveyId == '0' &&
        postSurveyId != '0' &&
        feedbackSurveyId == '0' &&
        isPostfield > 0) {
      return true;
    } else if (preSurveyId != '0' &&
        postSurveyId == '0' &&
        feedbackSurveyId != '0' &&
        isFeedbackfield > 0 &&
        isPrefield > 0) {
      return true;
    } else if (preSurveyId != '0' &&
        postSurveyId == '0' &&
        feedbackSurveyId == '0' &&
        isPrefield > 0) {
      return true;
    } else if (preSurveyId == '0' &&
        postSurveyId != '0' &&
        feedbackSurveyId == '0' &&
        isPostfield > 0) {
      return true;
    } else if (preSurveyId == '0' &&
        postSurveyId == '0' &&
        feedbackSurveyId != '0' &&
        isFeedbackfield > 0) {
      return true;
    } else if (feedbackSurveyId == '0' &&
        isPostfield > 0 &&
        (preSurveyId != '0' && isPrefield > 0)) {
      return true;
    }

    return false;
  }

  surveyFinised() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 250.h,
            width: 300.w,
            child: Column(
              children: [
                Image.asset(
                  'assets/win.png', // Replace with your image asset path
                  height: 120.h,
                  width: 120.w,
                ),
                SizedBox(height: 10),
                Text(
                  'Congratulations',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'You have completed training successfully',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                CustomElevatedButton(
                  textColor: ColorConstants.whiteColorText,
                  buttonTitle: 'Continue',
                  height: 48.h,
                  onPressed: () async {
                    // Close the popup when the button is pressed

                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.questionListScreen,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CreateQuestionView extends StatefulWidget {
  final Map<String, dynamic> paramsAll;
  const CreateQuestionView(this.paramsAll, {Key? key}) : super(key: key);

  @override
  State<CreateQuestionView> createState() => _CreateQuestionViewState();
}

class _CreateQuestionViewState extends State<CreateQuestionView> {
  void _updateState(int index) {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: SurveyWidget().createSurveyQuestionWidget(widget.paramsAll,
            widget.paramsAll['SurveyQuestion'], _updateState));
  }
}

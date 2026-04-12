import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../custom_views/custom_label_widget.dart';
import '../../../database/dataProvider.dart';
import '../../../models/training_surveyQuestionModel.dart';
import '../../../models/training_surveyQuestionOptionsModel.dart';
import '../../../table_model/tbl_participant_scan_details.dart';
import '../../../table_model/tblsurvey_response.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';

class PostSurveyScorePage extends StatefulWidget {
   final surveyId;
  final String? presurvey;
  final String? registrationGuidval;
  final String? scheduleGuid;
  final ParticipantScanDetails    userdetails;
  const PostSurveyScorePage(this.surveyId, this.presurvey,
      this.registrationGuidval, this.scheduleGuid,this.userdetails,
      {Key? key})
      : super(key: key);
  @override
  _PostSurveyScorePageState createState() => _PostSurveyScorePageState();
}

class _PostSurveyScorePageState extends State<PostSurveyScorePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> paramsAll = {};

  late List<TrainingSurveyQuestionDatum> preSurveyQuestion = [];
  late List<TrainingSurveyQuestionOptionsDatum> preSurveyQuestionOpt = [];
  Map<String, Map<String, String>> _formdata = {};
   var mobileNo;
  var isDisposed = false;
  ParticipantScanDetails _userdetails =ParticipantScanDetails();
    int languageId = 1;
   List<SurveyResponse> postSureveyData=[]; 
  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];
    @override
  void initState() {
    super.initState();
    LabelText.getLang(languageId);
  }
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      postSureveyData=await DataProvider().getSurveyAllData(widget.surveyId,mobileNo,widget.registrationGuidval!);
   
      setState(() {
        isDisposed = true;
      });
    //  surveyFinised();
    }
  }
   Future<List<TrainingSurveyQuestionDatum>> refreshPageQuestions() async {
    return preSurveyQuestion;
  }
        final ScrollController scrcontroller = ScrollController();

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
          onPressed: () =>  Navigator.of(context).pop(),
        ),
        title: Text(
         "${widget.presurvey} Score",
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
          key: SecureStorageKeys.langId,value:(languages.indexOf(selectedLanguagevalue) + 1).toString());
               languageId=languages.indexOf(selectedLanguagevalue) + 1;
              
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
      body: FutureBuilder(
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
              } else {
                 paramsAll['languageId']=languageId;
                return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        controller: scrcontroller,
                        physics: const ClampingScrollPhysics(),
                        itemCount: preSurveyQuestion.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final _trainingBatch =
                              preSurveyQuestion[index];

                          if (_trainingBatch == null) return null;

                          return GestureDetector(
                            onTap: () async {
                            },
                            child: listQuestionList(_trainingBatch, index),
                          );
                        },
                      );
              }
          }
        },
      ),
     
    );
  }
  Widget listQuestionList(TrainingSurveyQuestionDatum trainingBatch, int index) {
    String question="";
    String givenAnswer="";
    String correctAnswer='';
    bool isAnswerisCorrect=true;
    String savedAnswer='';
    try{
    savedAnswer=  postSureveyData.where((element) => element.questionId==trainingBatch.questionId).first.response!;


        if (languages.indexOf(selectedLanguagevalue) == 1) {
          question=trainingBatch.questionHindi!;
      correctAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.point==1).first.textHindi!;
    givenAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.questionOptionId.toString()==savedAnswer).first.textHindi!;
     isAnswerisCorrect=correctAnswer==givenAnswer;
  
    }else if (languages.indexOf(selectedLanguagevalue) == 2) {
      question=trainingBatch.questionMarathi!;
      correctAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.point==1).first.textMarathi!;
       givenAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.questionOptionId.toString()==savedAnswer).first.textMarathi!;
 isAnswerisCorrect=correctAnswer==givenAnswer;
    }else{
       question=trainingBatch.question!;
      correctAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.point==1).first.text!;

    givenAnswer=preSurveyQuestionOpt.where((element) => element.questionId==trainingBatch.questionId && element.questionOptionId.toString()==savedAnswer).first.text!;
 isAnswerisCorrect=correctAnswer==givenAnswer;
    }
    
    
    }
    catch(e){}

    return Card(
      // color: (index + 1) % 2 == 1 ? Color(0xffFFF7F7) : Color(0xffFFE5E6),
        child: Container(
         // height: 50.h,
          decoration: BoxDecoration(
            //color: Color(0xffF7F8FA),
            border: Border.all(color: Color(0xffBABABA)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabelWidget(
              trainingBatch,
             paramsAll,
            ),
         
         Text(
             'Correct Answer: ${correctAnswer}',
             style: TextStyle(
               fontStyle: FontStyle.italic,
               color: Colors.green,
             ),
           ),
                        Text(
                            'Your Response: ${givenAnswer}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: isAnswerisCorrect? Colors.green:Colors.red,
                            ),
                          ),
              ],
            ),
          ),
        ));
  }

}
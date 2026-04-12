import 'dart:convert';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../database/dataProvider.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../utils/validate.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../../widgets/registration_drop_down.dart';
import '../../../widgets/registration_text_field.dart';
import '../../api/hand_holding_apis.dart';
import '../../table_model/tbl_Training_HandHolding_Particepent.dart';
import '../../table_model/tbl_designation_model.dart';
import '../../table_model/tbl_master_model.dart';
import '../../table_model/tbl_teacher_grade_model.dart';
import '../../table_model/tbl_training_hand_holding.dart';
import '../../utils/log_files.dart';

class HouseHoldRegistraionParticipantModule extends StatefulWidget {
  final TblTrainingHandHolding? handholing;
  final TrainingHandHoldingParticepent? particepentDetail;
  const HouseHoldRegistraionParticipantModule(
      {Key? key, this.handholing, this.particepentDetail})
      : super(key: key);

  @override
  State<HouseHoldRegistraionParticipantModule> createState() =>
      _HouseHoldRegistraionParticipantModuleState();
}

class _HouseHoldRegistraionParticipantModuleState
    extends State<HouseHoldRegistraionParticipantModule> {
  DataProvider dbhelper = DataProvider();
  TrainingHandHoldingParticepent trainingDatum =
      TrainingHandHoldingParticepent();
  List<TrainingHandHoldingParticepent> trainingList = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController participantProfileController = TextEditingController();
  TextEditingController otherParticipantProfileController =
      TextEditingController();
  TextEditingController udiseCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  List<TblMasterModel> genderModelList = [];
  List<TblDesignationModel> designationModelList = [];
  List<String> genderlList = [];
  List<String> designationList = [];
  List<TblTeacherGradeModel> teacherGradeList = [];
  List<String> teacherDesignationList = [];
  List<String> teacherGrades = [];
  List<int> targetMinistryIds = [];
  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];
  Map<String, bool> gradeSelection = {};
  bool isBackPressed = false;
  int genderindex = 0;
  int designationindex = 0;
  bool apiData = false;
  int languageId = 1;
  // String? selectedMinistryId;

  setAllListData() async {
    designationModelList.clear();
    designationModelList = await DataProvider().getAllDesignation();
    designationModelList.add(TblDesignationModel(
        id: 9999999,
        englishDesignation: LabelText.getText('Other'),
        hindiDesignation: LabelText.getText('Other'),
        marathiDesignation: LabelText.getText('Other')));
    teacherGradeList = await DataProvider().getTeacherGradeList();
    genderModelList.clear();
    designationList.clear();
    designationList.add(LabelText.getText('selectDesignation'));
    if (languages.indexOf(selectedLanguagevalue) == 1) {
      genderModelList = await DataProvider().getMastrerListData('GenderHindi');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.hindiDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.hindiDesignation!);
      }
    } else if (languages.indexOf(selectedLanguagevalue) == 2) {
      genderModelList =
          await DataProvider().getMastrerListData('GenderMarathi');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.marathiDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.marathiDesignation!);
      }
    } else {
      genderModelList =
          await DataProvider().getMastrerListData('GenderEnglish');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.englishDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.englishDesignation!);
      }
    }

    if (teacherGradeList.isNotEmpty) {
      teacherGrades = teacherGradeList.map((e) => e.teacherGrade).toList();
    }
    for (var grade in teacherGrades) {
      gradeSelection[grade] = false;
    }
    teacherGrades.add('OK');

    genderlList.clear();
    genderlList.add(LabelText.getText('pleaseSelect'));
    for (var element in genderModelList) {
      genderlList.add(element.text);
    }

    participantProfileController.text = designationList[designationindex];
    genderController.text = genderlList[genderindex];
    apiData = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LabelText.getLang(languageId);
  }

  var userInfo;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isBackPressed) {
      userInfo = await UserInfo().getUserCredentials();
      var langID = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.langId);
      if (langID != null) {
        languageId = int.parse(langID);
        LabelText.getLang(languageId);
        selectedLanguagevalue = languages[languageId - 1];
      }
      await setAllListData();

      if (widget.particepentDetail != null) {
        trainingDatum = widget.particepentDetail!;

        setAllData();
      }
    }

    setState(() {
      isBackPressed = true;
    });
  }

  setAllData() {
    if (trainingDatum != null) {
      firstNameController.text = trainingDatum.fullName ?? '';
      mobileController.text = trainingDatum.phoneNo ?? '';
      try {
        genderController.text = genderModelList
            .where((element) => element.value == trainingDatum.gender)
            .first
            .text;
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      try {
        if (languages.indexOf(selectedLanguagevalue) == 1) {
          participantProfileController.text = designationModelList
              .where((element) =>
                  element.id.toString() == trainingDatum.designation)
              .first
              .hindiDesignation!;
        } else if (languages.indexOf(selectedLanguagevalue) == 2) {
          participantProfileController.text = designationModelList
              .where((element) =>
                  element.id.toString() == trainingDatum.designation)
              .first
              .marathiDesignation!;
        } else {
          participantProfileController.text = designationModelList
              .where((element) =>
                  element.id.toString() == trainingDatum.designation)
              .first
              .englishDesignation!;
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: ColorConstants.defaultBackgroundColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 300.w,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  isBackPressed = true;
                  Navigator.pop(context, null);
                },
              ),
              Text(
                LabelText.registration,
                style:
                    Styles.red164.copyWith(color: ColorConstants.defaultMaroon),
              )
            ],
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
                languageId = languages.indexOf(selectedLanguagevalue) + 1;
                await customSecureStorage.writeSecureValue(
                    key: SecureStorageKeys.langId,
                    value: (languageId).toString());

                LabelText.getLang(languageId);
                //LabelText.getLang(languages.indexOf(selectedLanguagevalue) + 1);
                await setAllListData();
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
          ]),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: !apiData
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        RegistrationTextField(
                          subTitle: LabelText.getText('firstname'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LabelText.getText('fullNameEmpty');
                            } else if (!RegExp(r'[a-z ,.-]+$')
                                .hasMatch(value!)) {
                              return 'Invalid Name';
                            }
                            return null;
                          },
                          textEditingController: firstNameController,
                          title: LabelText.getText('firstname'),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        if (genderlList.isNotEmpty) ...[
                          RegistrationDropDown(
                            subTitle: LabelText.getText('gender'),
                            validator: (value) {
                              var validate = Validate().validateGender(value);
                              return validate;
                            },
                            initialValue: LabelText.getText('pleaseSelect'),
                            items: genderlList,
                            textEditingController: genderController,
                            title: LabelText.getText('gender'),
                            onChanged: (value) {
                              if (value == null) {
                                genderindex = 0;
                              } else {
                                genderindex = int.parse(value);
                              }
                              try {
                                if (genderModelList.isNotEmpty &&
                                    value !=
                                        LabelText.getText('pleaseSelect')) {
                                  // genderController.text = value.toString();
                                  setState(() {});
                                }
                              } catch (error, stackTrace) {
                                logError(error, stackTrace);
                              }
                            },
                          ),
                        ],
                        SizedBox(
                          height: 12.h,
                        ),
                        RegistrationTextField(
                          subTitle: LabelText.getText('mobileNo'),
                          validator: (value) {
                            var validate =
                                Validate().validateMobileNumber(value!);
                            return validate;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'(^[0-9]{1,10})')),
                          ],
                          textEditingController: mobileController,
                          title: LabelText.getText('mobileNo'),
                          textInputType: TextInputType.number,
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        if (designationList.isNotEmpty) ...[
                          RegistrationDropDown(
                            subTitle: LabelText.getText('participantProfile'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value ==
                                      LabelText.getText('selectDesignation')) {
                                return LabelText.getText('designationempty');
                              }
                              return null;
                            },
                            initialValue:
                                LabelText.getText('selectDesignation'),
                            items: designationList,
                            textEditingController: participantProfileController,
                            title: LabelText.getText('participantProfile'),
                            onChanged: (value) {
                              setState(() {});
                              // try {
                              //   if (languages.indexOf(selectedLanguagevalue) ==
                              //       1) {
                              //     selectedMinistryId = designationModelList
                              //         .firstWhere((element) =>
                              //             element.hindiDesignation ==
                              //             participantProfileController.text)
                              //         .ministryId!;
                              //   } else if (languages
                              //           .indexOf(selectedLanguagevalue) ==
                              //       2) {
                              //     selectedMinistryId = designationModelList
                              //         .firstWhere((element) =>
                              //             element.marathiDesignation ==
                              //             participantProfileController.text)
                              //         .ministryId!;
                              //   } else {
                              //     selectedMinistryId = designationModelList
                              //         .firstWhere((element) =>
                              //             element.englishDesignation ==
                              //             participantProfileController.text)
                              //         .ministryId!;
                              //   }
                              //   setState(() {});
                              //   // }
                              // } catch (error, stackTrace) {
                              //   logError(error, stackTrace);
                              // }
                            },
                          ),
                          if (participantProfileController.text ==
                              LabelText.getText('Other')) ...[
                            const SizedBox(height: 12),
                            RegistrationTextField(
                              subTitle:
                                  LabelText.getText('otherParticipantProfile'),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LabelText.getText('designationempty');
                                }
                                return null;
                              },
                              textEditingController:
                                  otherParticipantProfileController,
                              title:
                                  LabelText.getText('otherParticipantProfile'),
                              onChanged: (value) {
                                if (kDebugMode) {
                                  print(value);
                                }
                              },
                            ),
                          ],
                          // if (teacherGrades.isNotEmpty &&
                          //     teacherDesignationList.contains(
                          //         participantProfileController.text)) ...[
                          //   SizedBox(
                          //     height: 12.h,
                          //   ),
                          //   Container(
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 10.w, vertical: 2.h),
                          //     // color: Colors.red,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(
                          //           color: const Color(0xff707070), width: 1),
                          //       boxShadow: const [
                          //         BoxShadow(
                          //           color: Color(0x4d000000),
                          //           offset: Offset(0.0, 1.0),
                          //           blurRadius: 3.0,
                          //         ),
                          //       ], //border of dropdown button
                          //       borderRadius: BorderRadius.circular(15),
                          //     ),
                          //     child: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         DropdownButton<String>(
                          //           isExpanded: true,
                          //           underline: Container(),
                          //           hint:
                          //               Text(LabelText.getText('selectGrade')),
                          //           items: teacherGrades.map((String grade) {
                          //             return DropdownMenuItem<String>(
                          //               alignment: Alignment.topRight,
                          //               value: grade,
                          //               onTap: () => setState(() {}),
                          //               child: grade == 'OK'
                          //                   ? InkWell(
                          //                       child: Padding(
                          //                         padding:
                          //                             const EdgeInsets.all(8.0),
                          //                         child: Text(grade,
                          //                             style: Styles.black164
                          //                                 .copyWith(
                          //                                     fontSize: 18,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .w600,
                          //                                     color:
                          //                                         Colors.blue)),
                          //                       ),
                          //                       onTap: () {
                          //                         Navigator.of(context).pop();
                          //                         setState(() {});
                          //                       },
                          //                     )
                          //                   : StatefulBuilder(
                          //                       builder: (BuildContext context,
                          //                           StateSetter setState) {
                          //                         return CheckboxListTile(
                          //                           title: Text(grade),
                          //                           value:
                          //                               gradeSelection[grade],
                          //                           onChanged: (bool? value) {
                          //                             setState(() {
                          //                               gradeSelection[grade] =
                          //                                   value ?? false;
                          //                             });
                          //                           },
                          //                         );
                          //                       },
                          //                     ),
                          //             );
                          //           }).toList(),
                          //           onChanged: (_) {
                          //             setState(() {});
                          //           },
                          //         ),
                          //         if (gradeSelection.containsValue(true)) ...[
                          //           Wrap(
                          //             spacing: 6.0,
                          //             runSpacing: 6.0,
                          //             children: gradeSelection.entries
                          //                 .where((entry) => entry.value)
                          //                 .map((entry) => Chip(
                          //                       label: Text(entry.key),
                          //                       onDeleted: () {
                          //                         setState(() {
                          //                           gradeSelection[entry.key] =
                          //                               false;
                          //                         });
                          //                       },
                          //                     ))
                          //                 .toList(),
                          //           ),
                          //         ]
                          //       ],
                          //     ),
                          //   )
                          // ],
                          // if (targetMinistryIds.contains(14) ||
                          //     selectedMinistryId == '14') ...[
                          //   const SizedBox(height: 12),
                          //   RegistrationTextField(
                          //     subTitle: LabelText.getText('schoolUDISEcode'),
                          //     decoration: const InputDecoration(
                          //         border: InputBorder.none),
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return LabelText.getText('pleaseenter');
                          //       }
                          //       return null;
                          //     },
                          //     textEditingController: udiseCodeController,
                          //     title: LabelText.getText('schoolUDISEcode'),
                          //     onChanged: (value) {
                          //       if (kDebugMode) {
                          //         print(value);
                          //       }
                          //     },
                          //   ),
                          // ],
                        ],
                        SizedBox(height: 10.h)
                      ],
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: CurvedButton(
            buttonTitle: 'Submit',
            style: Styles.white146,
            buttonColor: ColorConstants.defaultMaroon,
            height: 40.h,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await saveData();
                } catch (error, stackTrace) {
                  logError(error, stackTrace);
                }
              }
            }),
      ),
    );
  }

  saveData() async {
    String gendervalue = genderModelList
        .where((element) => element.text == genderController.text)
        .first
        .value;

    String designationvalue = "";
    if (languages.indexOf(selectedLanguagevalue) == 1) {
      designationvalue = designationModelList
          .where((element) =>
              element.hindiDesignation == participantProfileController.text)
          .first
          .id
          .toString();
    } else if (languages.indexOf(selectedLanguagevalue) == 2) {
      designationvalue = designationModelList
          .where((element) =>
              element.marathiDesignation == participantProfileController.text)
          .first
          .id
          .toString();
    } else {
      designationvalue = designationModelList
          .where((element) =>
              element.englishDesignation == participantProfileController.text)
          .first
          .id
          .toString();
    }

    // if (attendedBeforeController.text == LabelText.getText('yes')) {
    //   attendedBeforevalue = 'Yes';
    // } else if (attendedBeforeController.text == LabelText.getText('no')) {
    //   attendedBeforevalue = 'No';
    // }

    // var orgName = establishmentController.text;
    // var orgCode = null;
    // if (orgName != 'Other') {
    //   orgCode = trainerEstablishment
    //       .where((element) => element.name == orgName)
    //       .first
    //       .establishmentCode;
    // } else {
    //   orgName = organizationNameController.text;
    // }
    // String outputDateString = monthAndYearController.text;
    // if (monthAndYearController.text.isNotEmpty &&
    //     monthAndYearController.text != "N/a") {
    //   DateTime inputDate =
    //       DateFormat("dd/MM/yyyy").parse(monthAndYearController.text);
    //   outputDateString = DateFormat("yyyy-MM-dd").format(inputDate);
    // }
    trainingDatum = TrainingHandHoldingParticepent(
      // stateId: stateVal,
      // districtId: distictValue,
      fullName: firstNameController.text,
      // tehsilName: tehsilNameController.text,
      // email: emailController.text,
      phoneNo: mobileController.text,
      phoneNoTen: mobileController.text,
      // attendedArpanSessionChildSexualAbuse: attendedBeforevalue,
      // city: cityStatusController.text,
      scheduleGuid: widget.handholing!.scheduleGuid,
      HandHoldingGuid: widget.handholing!.handHoldingGuid,
      particitantGuid: Uuid().v1(),
      gender: gendervalue,
      // pinCode: zipPostalPinCodeController.text,
      // organisationName: orgName,
      // OrganisationCode: orgCode,
      designation: designationvalue,
      otherDesignation: otherParticipantProfileController.text,
      // monthYearAttendSession: outputDateString,
      createdOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdBy: userInfo['email'].toString(),
      updatedOn: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      updatedBy: userInfo['email'].toString(),
      IsEdited: 1,
    );

//json.encode(data.toJson()

    await dbhelper.saveHandHoldingParticepent(trainingDatum);

    uploadData();
  }

  uploadData() async {
    TrainingHandHoldingParticepent regDetail = trainingDatum;
    await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
          secondFunc: () async {
            FocusScope.of(context).unfocus();
            isBackPressed = true;
            Navigator.pop(context, regDetail);
          },
          func: () async {
            List<TrainingHandHoldingParticepent> allData = [];
            allData.add(trainingDatum);
            String jsonBatch = jsonEncode(allData);
            var responseModel = await HandHoldinApi()
                .postHandHoldingAddParticipantList(
                    postBody: jsonDecode(jsonBatch));
            if (responseModel.isSuccess) {
              regDetail.IsEdited = 0;

              await DataProvider().saveHandHoldingParticepent(regDetail);

              return LabelText.success;
            } else {
              return LabelText.uploadFailed;
            }
          },
          title: LabelText.pleaseWait),
    );
  }
}

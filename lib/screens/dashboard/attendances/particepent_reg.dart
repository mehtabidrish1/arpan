// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// import '../../../api/training_participant_registration_api.dart';
// import '../../../constants/color_constants.dart';
// import '../../../constants/style/style1.dart';
// import '../../../database/dataProvider.dart';
// import '../../../models/training_schedule_participant_model.dart';
// import '../../../table_model/tbl_master_model.dart';
// import '../../../table_model/tbl_training_registration_model.dart';
// import '../../../utils/common.dart';
// import '../../../utils/lableText.dart';
// import '../../../utils/log_files.dart';
// import '../../../utils/validate.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/custom_loading_indicator.dart';
// import '../../../widgets/registration_drop_down.dart';
// import '../../../widgets/registration_text_field.dart';

// class AddParticipantModule extends StatefulWidget {
//   const AddParticipantModule({Key? key}) : super(key: key);

//   @override
//   State<AddParticipantModule> createState() => _AddParticipantModuleState();
// }

// class _AddParticipantModuleState extends State<AddParticipantModule> {
//   DataProvider dbhelper = DataProvider();
//   TrainingScheduleParticipantModel trainingDatum =
//       TrainingScheduleParticipantModel();
//   List<TrainingScheduleParticipantModel> trainingList = [];

//   TextEditingController doaController = TextEditingController();
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController mobileController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController approvedStatusController = TextEditingController();
//   TextEditingController cityStatusController = TextEditingController();

//   TextEditingController zipPostalPinCodeController = TextEditingController();

//   TextEditingController organizationNameController = TextEditingController();

//   TextEditingController participantProfileController = TextEditingController();
//   TextEditingController attendedBeforeController = TextEditingController();
//   TextEditingController monthAndYearController = TextEditingController();
//   TextEditingController tehsilNameController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();
//   DateTime? dob;
//   bool hasAttendedBefore = false;
//   var userInfo;
//   List<TblMasterModel> genderModelList = [];
//   List<TblMasterModel> designationModelList = [];
//   List<String> genderlList = [];
//   List<String> designationList = [];
//   bool apiData = false;

//   setAllListData() async {
//     genderModelList = await DataProvider().getMastrerListData('GenderEnglish');
//     genderlList.clear();
//     genderlList.add(LabelText.selectGender);
//     for (var element in genderModelList) {
//       genderlList.add(element.text);
//     }
//     designationModelList = await DataProvider()
//         .getMastrerListData('TrainingParticipantDesignationEnglish');
//     designationList.clear();
//     designationList.add(LabelText.selectDesignation);
//     for (var e in designationModelList) {
//       designationList.add(e.text);
//     }
//     apiData = true;
//     setState(() {});
//   }

//   @override
//   Future<void> didChangeDependencies() async {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     userInfo = await UserInfo().getUserCredentials();
//     await setAllListData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.defaultBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: ColorConstants.defaultBackgroundColor,
//         title: Text(LabelText.registration, style: Styles.black145),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             FocusScope.of(context).unfocus();
//             Navigator.pop(context, null);
//           },
//         ),
//         elevation: 0,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Center(
//           child: !apiData
//               ? CircularProgressIndicator()
//               : SizedBox(
//                   height: 640.h,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 25.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return LabelText.fullNameEmpty;
//                               } else if (!RegExp(r'[a-z ,.-]+$')
//                                   .hasMatch(value!)) {
//                                 return 'Invalid Name';
//                               }
//                               return null;
//                             },
//                             textEditingController: firstNameController,
//                             title: LabelText.firstname,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email address';
//                               }

//                               if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                                 return 'Please enter a valid email address';
//                               }

//                               return null;
//                             },
//                             textEditingController: emailController,
//                             title: LabelText.emailText,
//                             textInputType: TextInputType.emailAddress,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationDropDown(
//                             validator: (value) {
//                               var validate =
//                                   Validate().validateApprovedStatus(value);
//                               return validate;
//                             },
//                             initialValue: LabelText.selectApproved,
//                             items: [LabelText.yes, LabelText.no],
//                             textEditingController: approvedStatusController,
//                             title: LabelText.approvedStatus,
//                             onChanged: (value) {
//                               print(value);
//                               print(approvedStatusController.text);
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               var validate =
//                                   Validate().validateMobileNumber(value!);
//                               return validate;
//                             },
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                   RegExp(r'(^[0-9]{1,10})')),
//                             ],
//                             textEditingController: mobileController,
//                             title: LabelText.mobileNo,
//                             textInputType: TextInputType.number,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationDropDown(
//                             validator: (value) {
//                               var validate = Validate().validateGender(value);
//                               return validate;
//                             },
//                             initialValue: LabelText.selectGender,
//                             items: genderlList,
//                             textEditingController: genderController,
//                             title: LabelText.gender,
//                             onChanged: (value) {
//                               try {
//                                 if (genderModelList.isNotEmpty &&
//                                     value != LabelText.selectGender) {
//                                   genderController.text = value.toString();
//                                   setState(() {});
//                                 }
//                               } catch (error, stackTrace) {
//                                 logError(error, stackTrace);
//                               }
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your city.';
//                               }
//                               return null;
//                             },
//                             textEditingController: cityStatusController,
//                             title: LabelText.city,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Tehsil Name';
//                               }
//                               return null;
//                             },
//                             textEditingController: tehsilNameController,
//                             title: LabelText.tehsilName,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return LabelText.zipPostalPinCodeempty;
//                               } else if (value.length > 6 || value.length < 6) {
//                                 return 'Invalid Pincode';
//                               }
//                               return null;
//                             },
//                             textEditingController: zipPostalPinCodeController,
//                             title: LabelText.zipPostalPinCode,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RegistrationTextField(
//                             decoration:
//                                 InputDecoration(border: InputBorder.none),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Organization.';
//                               }
//                               return null;
//                             },
//                             textEditingController: organizationNameController,
//                             title: LabelText.nameOfOrganization,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           RegistrationDropDown(
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return LabelText.designationempty;
//                               }
//                               return null;
//                             },
//                             initialValue: LabelText.selectDesignation,
//                             items: designationList,
//                             textEditingController: participantProfileController,
//                             title: LabelText.participantProfile,
//                             onChanged: (value) {
//                               try {
//                                 if (designationModelList.isNotEmpty &&
//                                     value != LabelText.selectDesignation) {
//                                   participantProfileController.text =
//                                       value.toString();
//                                   setState(() {});
//                                 }
//                               } catch (error, stackTrace) {
//                                 logError(error, stackTrace);
//                               }
//                             },
//                           ),
//                           // RegistrationTextField(
//                           //   decoration: InputDecoration(border: InputBorder.none),
//                           //   validator: (value) {
//                           //     if (value == null || value.isEmpty) {
//                           //       return "Please enter Participant's Designation.";
//                           //     }
//                           //     return null;
//                           //   },
//                           //   textEditingController: participantProfileController,
//                           //   title: LabelText.participantProfile,
//                           //   onChanged: (value) {
//                           //     print(value);
//                           //   },
//                           // ),
//                           SizedBox(
//                             height: 12.h,
//                           ),
//                           RegistrationDropDown(
//                             validator: (value) {
//                               var validate =
//                                   Validate().validateAttendedBedore(value);
//                               return validate;
//                             },
//                             initialValue: LabelText.pleaseSelect,
//                             textEditingController: attendedBeforeController,
//                             items: [
//                               LabelText.pleaseSelect,
//                               LabelText.yes,
//                               LabelText.no
//                             ],
//                             title: LabelText.attendedBefore,
//                             onChanged: (value) {
//                               if (value.toString() == '1') {
//                                 hasAttendedBefore = true;
//                                 attendedBeforeController.text = 'Yes';
//                                 monthAndYearController.text = '';
//                                 setState(() {});
//                               } else if (value.toString() == '2') {
//                                 hasAttendedBefore = false;
//                                 attendedBeforeController.text = 'No';
//                                 monthAndYearController.text = 'Na';
//                                 setState(() {});
//                               } else {
//                                 hasAttendedBefore = false;
//                                 setState(() {});
//                                 monthAndYearController.text = 'Na';
//                               }
//                             },
//                           ),
//                           if (hasAttendedBefore) ...[
//                             SizedBox(
//                               height: 12.h,
//                             ),
//                             RegistrationTextField(
//                               decoration:
//                                   InputDecoration(border: InputBorder.none),
//                               validator: null,
//                               textEditingController: monthAndYearController,
//                               title: LabelText.monthAndYearAttending,
//                               onChanged: (value) {},
//                             ),
//                           ],
//                           SizedBox(
//                             height: 25.h,
//                           ),
//                           CustomButton(
//                               textColor: ColorConstants.whiteColorText,
//                               buttonTitle: LabelText.submit,
//                               buttonColor: Colors.green,
//                               height: 49.h,
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   if (attendedBeforeController.text.isEmpty) {
//                                     monthAndYearController.text = 'N/a';
//                                   }
//                                   if (monthAndYearController.text.isEmpty) {
//                                     monthAndYearController.text = 'N/a';
//                                   }
//                                 }
//                               })
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

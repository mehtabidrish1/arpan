import 'package:arpan/api/trainer_login_api.dart';
import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/secure_storage_keys.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/screens/dashboard/dashboard_screen.dart';
import 'package:arpan/screens/dashboard/survey/questionList.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/utils/validate.dart';
import 'package:arpan/widgets/custom_button.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pinput/pinput.dart';
import 'package:toast/toast.dart';

import '../../api/dynamic_response/dynamic_responses.dart';
import '../../constants/route_constants.dart';
import '../../utils/download_data.dart';
import '../../utils/log_files.dart';
import '../../viewmodels/login_state_view_model.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/default_text_field.dart';
import '../dashboard/survey/registration_particepent.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isTrainer = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  bool showOtpScreen = false;
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  DataDownload dataDownload = DataDownload();
  final _formKey = GlobalKey<FormState>();

  String Email = '';
  String PassWord = '';
  String countryCode = '';

  Future<bool> onWillPop() async {
    if (!isTrainer) {
      showOtpScreen = false;
      setState(() {});
    }
    return false;
  }

  resetControllersAndState() {
    emailController.clear();
    passwordControler.clear();
    mobileNoController.clear();
    showOtpScreen = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
          top: false,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/leftButterflyTheme.png'),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isTrainer) ...[
                              Image.asset(
                                "assets/trainner_logo.png",
                                width: 165.w,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 15.h),
                                decoration: const BoxDecoration(
                                    color: Color(0xfff5f5f5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        buttonTitle: LabelText.trainer,
                                        textColor:
                                            ColorConstants.whiteColorText,
                                        textFontWeight: isTrainer
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        buttonColor: isTrainer
                                            ? const Color(0xff006476)
                                            : const Color(0xff14A49B),
                                        onPressed: () {
                                          setState(() {
                                            isTrainer = true;
                                          });
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          _formKey.currentState?.reset();
                                          resetControllersAndState();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                        buttonTitle: LabelText.participant,
                                        onPressed: () {
                                          setState(() {
                                            isTrainer = false;
                                          });
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          _formKey.currentState?.reset();
                                          resetControllersAndState();
                                        },
                                        textColor:
                                            ColorConstants.whiteColorText,
                                        buttonColor: !isTrainer
                                            ? const Color(0xff006476)
                                            : const Color(0xff14A49B),
                                        textFontWeight: !isTrainer
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              // SizedBox(height: 68.h),
                              DefaultTextField(
                                validator: (value) {
                                  var validate =
                                      Validate().validateEmail(value);
                                  return validate;
                                },
                                hintText: LabelText.userId,
                                hintStyle: Styles.grey164,
                                height: 48.h,
                                focusNode: emailFocusNode,
                                controller: emailController,
                                onChanged: (value) {
                                  Email = value.toUpperCase();
                                },
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              DefaultTextField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your valid pasword';
                                  }

                                  if (value.isEmpty) {
                                    return 'Enter a valid password!';
                                  }

                                  return null;
                                },
                                height: 48.h,
                                hintText: LabelText.password,
                                hintStyle: Styles.grey164,
                                focusNode: passwordFocusNode,
                                controller: passwordControler,
                                obscureText: true,
                                onChanged: (value) {
                                  PassWord = value;
                                  print(value);
                                },
                              ),
                              // SizedBox(
                              //   height: 19.h,
                              // ),
                              // Visibility(
                              //   visible: false,
                              //   child: Align(
                              //       alignment: Alignment.centerRight,
                              //       child: Text(
                              //         LabelText.forgotPassword,
                              //         style: Styles.defaultFont.copyWith(
                              //             color: ColorConstants.defaultRedColor),
                              //       )),
                              // ),
                              SizedBox(
                                height: 25.h,
                              ),
                              CurvedButton(
                                  buttonColor: ColorConstants.defaultMaroon,
                                  buttonTitle: LabelText.submit,
                                  style: Styles.white146,
                                  height: 35.h,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      ResponseModel? isLogin;
                                      await showCustomDialog(context,
                                          widget: ShowAlertDialogBox(
                                            goOnline: false,
                                            title: LabelText.pleaseWait,
                                            func: () async {
                                              try {
                                                isLogin =
                                                    await TrainerLoginAPI()
                                                        .arpanTrainerLogin(
                                                            empId: Email,
                                                            password: PassWord);
                                                if (isLogin!.code == 200) {
                                                  await customSecureStorage
                                                      .writeSecureValue(
                                                          key: SecureStorageKeys
                                                              .userId,
                                                          value: Email);
                                                  await customSecureStorage
                                                      .writeSecureValue(
                                                          key: SecureStorageKeys
                                                              .password,
                                                          value: PassWord);
                                                  await customSecureStorage
                                                      .writeSecureValue(
                                                          key: SecureStorageKeys
                                                              .role,
                                                          value: 'trainer');
                                                  await commonDownload();
                                                  // await dataDownload.downloadAttendceDetailList();
                                                  await dataDownload
                                                      .getPartialAttendancesDetailList();

                                                  await dataDownload
                                                      .getTrainingHandHoldingModuleList();
                                                  await dataDownload
                                                      .getTrainingHandHoldingList();

                                                  await dataDownload
                                                      .downloadTrainerList();
                                                  await dataDownload
                                                      .getTrainingRegistrationList();
                                                  await dataDownload
                                                      .downloadAttendceDetailList();
                                                }
                                                ResponseModel responseModel =
                                                    isLogin as ResponseModel;
                                                if (!responseModel.isSuccess) {
                                                  return responseModel;
                                                } else {
                                                  ref.refresh(
                                                      loginStateFutureProvider);
                                                  return (responseModel
                                                          .response)
                                                      .toString()
                                                      .replaceAll('"', '');
                                                }
                                              } catch (error, stackTrace) {
                                                logError(error, stackTrace);
                                                return error.toString();
                                              }
                                            },
                                            secondFunc: () async {
                                              if (isLogin?.code == 200) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DashboardScreen()));
                                              }
                                            },
                                          ));
                                    }
                                  }),
                            ] else ...[
                              if (showOtpScreen) ...[
                                SizedBox(
                                  height: 21.h,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                      strutStyle: StrutStyle.fromTextStyle(
                                          TextStyle(height: 1.1.h)),
                                      text: TextSpan(
                                          text: LabelText.otpNo,
                                          style: Styles.defaultFont,
                                          children: <InlineSpan>[
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RegistraionParticipantModule()));
                                                },
                                              text: "+91 " +
                                                  mobileNoController.text,
                                              style: Styles.defaultFont
                                                  .copyWith(
                                                      color: Color(0xff000000),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp),
                                            )
                                          ])),
                                ),
                                SizedBox(
                                  height: 32.h,
                                ),
                                Center(
                                  child: Pinput(
                                    length: 5,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    showCursor: true,
                                    errorTextStyle: Styles.defaultFont.copyWith(
                                        color: ColorConstants.defaultRedColor),
                                    validator: (value) {
                                      var validate =
                                          Validate().validateOTP(value!);
                                      return validate;
                                    },
                                    onCompleted: null,
                                  ),
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                CustomButton(
                                  buttonColor: ColorConstants.defaultRedColor,
                                  textColor: ColorConstants.whiteColorText,
                                  buttonTitle: LabelText.submit,
                                  height: 48.h,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      showOtpScreen = false;
                                      setState(() {});

                                      await customSecureStorage
                                          .writeSecureValue(
                                              key: SecureStorageKeys.role,
                                              value: 'participant');
                                      await customSecureStorage
                                          .writeSecureValue(
                                              key: SecureStorageKeys.phone,
                                              value: mobileNoController.text);
                                      await ref
                                          .read(loginStateProvider.notifier)
                                          .fetchState();
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const QuestionListScreen()));
                                    }
                                  },
                                ),
                              ] else ...[
                                Image.asset(
                                  "assets/participant.png",
                                  width: 165.w,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 15.h),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff5f5f5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          buttonTitle: LabelText.trainer,
                                          textColor:
                                              ColorConstants.whiteColorText,
                                          textFontWeight: isTrainer
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          buttonColor: isTrainer
                                              ? const Color(0xff006476)
                                              : const Color(0xff14A49B),
                                          onPressed: () {
                                            setState(() {
                                              isTrainer = true;
                                            });
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            _formKey.currentState?.reset();
                                            resetControllersAndState();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          buttonTitle: LabelText.participant,
                                          onPressed: () {
                                            setState(() {
                                              isTrainer = false;
                                            });
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            _formKey.currentState?.reset();
                                            resetControllersAndState();
                                          },
                                          textColor:
                                              ColorConstants.whiteColorText,
                                          buttonColor: !isTrainer
                                              ? const Color(0xff006476)
                                              : const Color(0xff14A49B),
                                          textFontWeight: !isTrainer
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                // SizedBox(height: 58.h),
                                SizedBox(
                                  child: IntlPhoneField(
                                    controller: mobileNoController,
                                    flagsButtonPadding: const EdgeInsets.all(8),
                                    dropdownIconPosition: IconPosition.trailing,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      //  FilteringTextInputFormatter.allow( RegExp(r'(^[0-9]{1,10})')),
                                    ],
                                    decoration: InputDecoration(
                                        labelText: 'Mobile No.(WhatsApp)',
                                        floatingLabelStyle: Styles.black145,
                                        labelStyle: Styles.grey164,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff707070)),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xff707070)),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        )),
                                    // decoration: const InputDecoration(
                                    //   labelText: 'Phone Number (WhatsApp)',
                                    //   border: OutlineInputBorder(
                                    //     borderSide: BorderSide(),
                                    //   ),
                                    // ),
                                    initialCountryCode: 'IN',
                                    /* validator: (value) {
                                      var validate = Validate()
                                          .validatePhoneNumber(value!.number);
                                      return validate;
                                    },*/
                                    onChanged: (phone) {
                                      countryCode = phone.countryCode;
                                      print(phone.completeNumber);
                                    },
                                  ),
                                ),
                                // SizedBox(height: 5.h),
                                // Align(
                                //     alignment: Alignment.centerRight,
                                //     child: Text(
                                //       LabelText.sendOtp,
                                //       style: Styles.grey164,
                                //     )),
                                // SizedBox(height: 5.h),
                                // DefaultTextField(
                                //   validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter your valid OTP';
                                // }

                                // if (value.isEmpty) {
                                //   return 'Enter a valid OTP!';
                                // }

                                //     return null;
                                //   },
                                //   height: 48.h,
                                //   hintText: 'OTP',
                                //   hintStyle: Styles.grey164,
                                //   // focusNode: passwordFocusNode,
                                //   // controller: passwordControler,
                                //   obscureText: true,
                                //   onChanged: (value) {
                                //     // PassWord = value;
                                //     // print(value);
                                //   },
                                // ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                CurvedButton(
                                  buttonTitle: LabelText.submit,
                                  buttonColor: ColorConstants.defaultMaroon,
                                  style: Styles.white146,
                                  height: 35.h,
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    // Add a slight delay before validation

                                    if (_formKey.currentState!.validate() &&
                                        mobileNoController.text.isNotEmpty) {
                                      await CustomSecureStorage()
                                          .writeSecureValue(
                                              key:
                                                  SecureStorageKeys.countryCode,
                                              value: countryCode);
                                      print(mobileNoController.text);
                                      // showOtpScreen = true;
                                      // setState(() {});
                                      await checkuserDetails(
                                          mobileNoController.text);
                                    } else {
                                      Toast.show(
                                          'Enter the ${LabelText.mobileNo}',
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                    }
                                    // else {
                                    //   showOtpScreen = false;
                                    //   setState(() {});
                                    // }
                                  },
                                ),
                              ],
                              SizedBox(
                                height: 15.h,
                              ),
                              Visibility(
                                visible: false,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                      strutStyle: StrutStyle.fromTextStyle(
                                          TextStyle(height: 1.1.h)),
                                      text: TextSpan(
                                          text: LabelText.dontHaveAccount,
                                          style: Styles.defaultFont,
                                          children: <InlineSpan>[
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RegistraionParticipantModule()));
                                                },
                                              text: LabelText.signUp,
                                              style: Styles.defaultFont
                                                  .copyWith(
                                                      color: ColorConstants
                                                          .defaultRedColor,
                                                      fontSize: 14.sp),
                                            )
                                          ])),
                                ),
                              ),
                            ]
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  checkuserDetails(String mobileNo) async {
    await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
        secondFunc: () async {
          FocusScope.of(context).unfocus();
          // List<TrainingScheduleParticipantModel> trainingList = [];
          // trainingList = await DataProvider()
          //     .getTrainingParticipantWithMobile(mobileNo: mobileNo);
          await customSecureStorage.writeSecureValue(
              key: SecureStorageKeys.role, value: 'participant');
          await customSecureStorage.writeSecureValue(
              key: SecureStorageKeys.phone, value: mobileNo);
          await ref.read(loginStateProvider.notifier).fetchState();
          // if (trainingList.isNotEmpty) {
          await Navigator.pushReplacementNamed(
            context,
            RouteConstants.questionListScreen,
          );
          // await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ParticepentDashboardScreen()));
          // } else {
          // await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             const RegistraionParticipantModule()));
          // }
        },
        func: () async {
          if (await Validate().checkInternetConnectivity()) {
            await commonDownload();
            // await DataDownload().getTrainingParticipantList(mobileno: mobileNo);
            // await DataDownload()
            //     .downloadTblTraningIndirectDataList(mobileNo, '');
          }

          // if (isOld) {
          //   return LabelText.alreadyRegistered;
          // } else {
          //   return LabelText.notRegistered;
          // }
          return LabelText.success;
        },
        goOnline: false,
        title: LabelText.pleaseWait,
      ),
    );

    // await DataDownload().getTrainingParticipantList(mobileno: mobileNo);
  }

  commonDownload() async {
    // await dataDownload.getMasterData();
    await dataDownload.getDesignationData();
    await dataDownload.downloadStateData();
    await dataDownload.getDistrictData();
    await dataDownload.getBlockData();
    // await dataDownload.getIndividualPartnerData();
    // await dataDownload.downloadTeacherGradeList();
    // await dataDownload.downloadTrainerEstablishmentList();
  }
}

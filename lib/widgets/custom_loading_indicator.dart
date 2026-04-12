import 'package:arpan/api/dynamic_response/dynamic_responses.dart';
import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/log_files.dart';

class LoadingModel {
  String message;
  int code;
  LoadingModel({required this.code, required this.message});
}

showCustomDialog(BuildContext context, {required Widget widget}) async {
  return await showDialog(context: context, builder: (_) => widget);
}

class ShowAlertDialogBox extends StatefulWidget {
  const ShowAlertDialogBox({
    Key? key,
    required this.func,
    required this.title,
    this.secondFunc,
    this.goOnline = false,
    // this.showSubmissionNumber = false,
  }) : super(key: key);

  final Function func;
  final Function? secondFunc;
  final String title;
  final bool? goOnline;
  // final bool showSubmissionNumber;

  @override
  State<ShowAlertDialogBox> createState() => _ShowAlertDialogBoxState();
}

class _ShowAlertDialogBoxState extends State<ShowAlertDialogBox> {
  Widget currentWidget = const Center(
    child: CircularProgressIndicator.adaptive(),
  );

  bool? isSuccess;
  var message = '';

  @override
  void initState() {
    super.initState();
    try {
      bool isResponseSuccess = true;
      widget.func().then(
        (v) {
          if (v.runtimeType == String || v.runtimeType == ResponseModel) {
            if (v.runtimeType == String) {
              message = v;
            } else if (v.runtimeType == ResponseModel) {
              ResponseModel responseModel = v;
              message = responseModel.isSuccess
                  ? LabelText.success
                  : (responseModel.response as Failure)
                      .response
                      .toString()
                      .replaceAll('"', '');
              isResponseSuccess = responseModel.isSuccess;
            }

            // setState(() {});
            isSuccess = true;
            setState(
              () {
                currentWidget = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 15.r,
                      backgroundColor: Colors.black,
                      child: Icon(
                        isResponseSuccess ? Icons.check : Icons.close,
                        size: 30.r,
                        color: ColorConstants.defaultBackgroundColor,
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    )
                  ],
                );
              },
            );
            // if (!widget.showSubmissionNumber) {
            Future.delayed(
              const Duration(
                milliseconds: 1500,
              ),
              () {
                Navigator.pop(context);
                if (isSuccess!) {
                  if (widget.secondFunc != null) {
                    widget.secondFunc!();
                  }
                }
              },
            );
          }
          // }
          else {
            setState(
              () {
                isSuccess = false;
                currentWidget = SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.transparent,
                        // child: Icon(
                        //   Icons.error_outlined,
                        //   size: radius * 3.5,
                        //   color: Colors.white,
                        // ),
                        child: Image.asset(
                          ImageConstants.appLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          v ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
            // if (!widget.showSubmissionNumber)
            Future.delayed(
              const Duration(milliseconds: 2500),
              () {
                try {
                  Navigator.pop(context);
                  if (isSuccess != null && isSuccess!) {
                    if (widget.secondFunc != null) {
                      widget.secondFunc!();
                    }
                  }
                } catch (error, stackTrace) {
                  logError(error, stackTrace);
                }
              },
            );
          }
        },
      );
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(1.r),
          ),
        ),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: 100.h,
              width: MediaQuery.of(context).size.width * 100,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: currentWidget,
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
            );
          },
        ),
        actions: const [
          // if (isSuccess != null && (widget.showSubmissionNumber || !isSuccess!))
          // if (isSuccess != null && !isSuccess!)
          // OutlinedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     if (isSuccess!) {
          //       if (widget.secondFunc != null) {
          //         widget.secondFunc!();
          //       }
          //     }
          //   },
          //   child: const Text("Ok"),
          // )
        ],
        contentPadding: EdgeInsets.only(
          top: 15.h,
          bottom:
              // isSuccess != null && (widget.showSubmissionNumber || !isSuccess!)
              isSuccess != null && !isSuccess! ? 15.h : 0,
        ),
      ),
    );
  }
}

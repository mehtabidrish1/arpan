import 'package:arpan/models/custom_model.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'log_files.dart';

class Validate {
  static Color hinttext = const Color(0xfff06e84);
  static Color interestText = Colors.white70;
  static Color mainPageField = const Color(0xff595959);
  static Color question = const Color(0xff0d4f6d);

  validatePhoneNumber(String value) {
    if (value == null || value.isEmpty) {
      return LabelText.phoneNumberValidationError;
    } /*else if (value.isNotEmpty && value.length != 10) {
      return LabelText.phoneNumberValidationError1;
    } */
    else {
      return null;
    }
  }

  validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return LabelText.otpValidationError;
    } else if (value.isNotEmpty && value.length != 5) {
      return LabelText.otpValidationError1;
    } else {
      return null;
    }
  }

  validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LabelText.emailValidationError;
    }
    // else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
    //   return LabelText.emailValidationError1;
    // }

    else {
      return null;
    }
  }

  validateGender(String? value) {
    if (value == null ||
        value.isEmpty ||
        value == LabelText.getText('pleaseSelect')) {
      return LabelText.getText('genderValidation');
    } else {
      return null;
    }
  }

  validateTypeOfTraining(String? value) {
    if (value == null || value.isEmpty) {
      return LabelText.typeOfTrainingValidationError;
    }
    return null;
  }

  validateApprovedStatus(String? value) {
    if (value == null || value.isEmpty) {
      return LabelText.approvedStatusValidation;
    } else {
      return null;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return LabelText.getText('emptyMobileNumberValidation');
    }
    /* RegExp indianMobileRegex = RegExp(r'^[6-9]\d{9}$');

    // Check if the number matches the regex pattern

    if (!indianMobileRegex.hasMatch(value.trim())) {
      return LabelText.getText('mobileNumberInvalidaValidation');
    }*/
    return null;
  }

  validateAttendedBedore(String? value) {
    if (value == null ||
        value.isEmpty ||
        value == LabelText.getText('pleaseSelect')) {
      return LabelText.attendedBeforeValidation;
    } else {
      return null;
    }
  }

  static List<MyModel> ConvertIDValueIntoList(String id, String value) {
    var myList = <MyModel>[];
    Map<String, String> idToValueMap = {};
    if (id.contains(',') && value.contains(',')) {
      List<String> ids = id.split(",");
      List<String> values = value.split(",");

      for (int i = 0; i < ids.length; i++) {
        MyModel model = MyModel();
        model.id = ids[i];
        model.value = values[i];
        myList.add(model);
        // idToValueMap[ids[i]] = values[i];
      }
    } else {
      MyModel model = MyModel();
      model.id = id;
      model.value = value;
      myList.add(model);
    }
    return myList;
  }

  static bool checkDatetimeDifferenceForPre(
      String firstDate, String startTime) {
    try {
      DateTime firstDatetime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$firstDate $startTime");

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Calculate the time difference between the found DateTime and the current DateTime
      Duration timeDifference = currentDatetime.difference(firstDatetime);

      // Check if the time difference is exactly 12 hours
      if (timeDifference.inMinutes > 0 && timeDifference.inHours <= 2) {
        return true;
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
    // Convert the provided date and time strings to DateTime objects
  }

  static bool checkDatetimeDifferenceForPost(String lastDate, String endTime) {
    try {
      if (lastDate == '' || endTime == '') {
        return false;
      }
      DateTime firstDatetime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$lastDate $endTime");

      // Subtract 1 hour from the firstDatetime
      DateTime modifiedDatetime = firstDatetime.subtract(Duration(hours: 1));

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Calculate the time difference between the modified DateTime and the current DateTime
      Duration timeDifference = currentDatetime.difference(modifiedDatetime);

      // Check if the time difference is exactly 12 hours
      if (timeDifference.inMinutes > 0 && timeDifference.inHours <= 24) {
        return true;
      } else {
        return false;
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
    // Convert the provided date and time strings to DateTime objects
  }

  static bool checkIsTrainingStart(String firstDate, String startTime) {
    try {
      //  firstDate="2023-10-11";
      //  startTime="3:30 PM";
      if (firstDate == '' || startTime == '') {
        return false;
      }
      DateTime firstDatetime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$firstDate $startTime");

      // Subtract 1 hour from the firstDatetime
      DateTime modifiedDatetime = firstDatetime.subtract(Duration(minutes: 5));

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Calculate the time difference between the modified DateTime and the current DateTime
      Duration timeDifference = currentDatetime.difference(modifiedDatetime);
      return timeDifference.inMinutes < 0;

      // Check if the time difference is exactly 12 hours
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
    // Convert the provided date and time strings to DateTime objects
  }

  static bool checkIsTrainingClosed(String lastDate, String endtime) {
    try {
      //    lastDate="2023-10-10";
      //    endtime="5:30 PM";
      if (lastDate == '' || endtime == '') {
        return false;
      }
      DateTime lastDateAndTime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$lastDate $endtime");

      // Subtract 1 hour from the firstDatetime
      //  DateTime modifiedDatetime = firstDatetime.subtract(Duration(minutes: 5));

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Calculate the time difference between the modified DateTime and the current DateTime
      Duration timeDifference = currentDatetime.difference(lastDateAndTime);
      return timeDifference.inHours > 24;
      // Check if the time difference is exactly 12 hours
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return false;
    }
    // Convert the provided date and time strings to DateTime objects
  }

  String checkDatetimeDifferenceForPreText(String firstDate, String startTime) {
    try {
      // Parse the provided date and time strings into DateTime objects
      DateTime startDatetime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$firstDate $startTime");

      // Calculate the end DateTime by adding 12 hours to the start DateTime
      DateTime endDatetime = startDatetime.add(Duration(hours: 2));

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Format the date times into strings
      String formattedStartDate =
          DateFormat("dd/MM/yyyy h:mm a").format(startDatetime);
      String formattedEndDate =
          DateFormat("dd/MM/yyyy h:mm a").format(endDatetime);

      // Return the formatted string
      return "Pre Survey will be enable from $formattedStartDate to $formattedEndDate.";
    } catch (error, stackTrace) {
      logError(
          error, stackTrace); // Logs any errors that occur during the process
      return "Error occurred during validation."; // Return an error message in case of an error
    }
  }

  String checkDatetimeDifferenceForPostText(String lastDate, String endTime) {
    try {
      if (lastDate == '' || endTime == '') {
        return "Invalid input"; // Return an error message for invalid input
      }

      // Parse the provided date and time strings into DateTime objects
      DateTime startDatetime =
          DateFormat("yyyy-MM-dd hh:mm a").parse("$lastDate $endTime");
      DateTime endDatetime = startDatetime.add(Duration(hours: 24));

      // Subtract 1 hour from the endDatetime
      DateTime modifiedDatetime = startDatetime.subtract(Duration(hours: 1));

      // Get the current DateTime
      DateTime currentDatetime = DateTime.now();

      // Calculate the time difference between the modified DateTime and the current DateTime
      Duration timeDifference = currentDatetime.difference(modifiedDatetime);

      // Check if the current DateTime is within the range [modifiedDatetime, endDatetime]

      // Format the date times into strings
      String formattedModifiedDate =
          DateFormat("dd/MM/yyyy h:mm a").format(modifiedDatetime);
      String formattedEndDate =
          DateFormat("dd/MM/yyyy h:mm a").format(endDatetime);

      // Return the formatted string
      return "Post Survey will be enable from $formattedModifiedDate to $formattedEndDate.";
    } catch (error, stackTrace) {
      logError(
          error, stackTrace); // Logs any errors that occur during the process
      return "Error occurred during validation."; // Return an error message in case of an error
    }
  }
}

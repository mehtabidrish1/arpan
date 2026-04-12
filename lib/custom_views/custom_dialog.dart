import 'package:flutter/material.dart';

dynamic customDialog(
  context, {
  String? title,
  String? content,
  required List<Widget> actions,
  bool isbarrierDismissible = false,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      // backgroundColor: Theme.of(context).primaryColorLight,
      backgroundColor: Colors.white,
      actions: actions,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(4),
          ),
        ),
        child: Text(
          title!,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
      content: Text(
        content!,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    ),
    barrierDismissible: isbarrierDismissible,
  );
}

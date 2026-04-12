import 'package:arpan/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int? defaultSelectedIndex;
  final Function(int) onChange;
  final List<String> iconList;
  const CustomBottomNavigationBar(
      {Key? key,
      this.defaultSelectedIndex = 0,
      required this.iconList,
      required this.onChange})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<String> _iconList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex ?? 0;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      navBarItemList.add(buildNavBarItem(_iconList[i], i));
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 1.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textFieldTitleColor.withOpacity(0.1),
            spreadRadius: 7,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: ColorConstants.defaultWhiteColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
      ),
      child: Row(
        children: navBarItemList,
      ),
    );
  }

  Widget buildNavBarItem(String icon, int index) {
    return InkWell(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Stack(
        children: [
          SizedBox(
            height: 40.h,
            width: 355.w / _iconList.length,
            child: Center(
              child: Image.asset(
                icon,
                fit: BoxFit.fill,
                // height: 10,
                width: 20.w,
                color: index == _selectedIndex ? Colors.green : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 43.h,
            width: 355.w / _iconList.length,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: index == _selectedIndex
                    ? const Duration(milliseconds: 300)
                    : const Duration(milliseconds: 300),
                height: 3.h,
                width: index == _selectedIndex ? 44.h : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: index == _selectedIndex
                      ? Colors.green
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

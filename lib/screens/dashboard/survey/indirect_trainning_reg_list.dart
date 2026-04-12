import 'package:arpan/database/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/style/style1.dart';
import '../../../table_model/tblTraningIndirectData_list.dart';
import '../../../table_model/training_indirect_data_model.dart';
import '../../../utils/lableText.dart';
import '../../training/hand_holding_schedule_list_page.dart';

class IndirectRegList extends StatefulWidget {
  @override
  _IndirectRegListState createState() => _IndirectRegListState();
}

class _IndirectRegListState extends State<IndirectRegList> {
  bool isDisposed = false;
  TblTraningIndirectDataList indirectData = TblTraningIndirectDataList();
  List<TrainingIndirectData> indirectDataList = [];

  String firstDate = '';
  String lastDate = '';
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        indirectData = data[0];
      }
      indirectDataList =
          await DataProvider().getindirctTraingingAllData(indirectData);

      /*  if(indirectData.firstDate!.isNotEmpty){
DateTime inputDate = DateFormat("yyyy-MM-dd").parse(indirectData.firstDate!);
   firstDate = DateFormat("dd/MM/yyyy").format(inputDate);
                                         }
    
                                         if(indirectData.lastDate!.isNotEmpty){
DateTime inputDate = DateFormat("yyyy-MM-dd").parse(indirectData.lastDate!);
   lastDate = DateFormat("dd/MM/yyyy").format(inputDate);
                                         }   */
      firstDate = indirectData.firstDate!;
      lastDate = indirectData.lastDate!;
      setState(() {
        isDisposed = true;
      });
    }
  }

  final ScrollController scrcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();

        isDisposed = true;

        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 300.w,
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  isDisposed = true;

                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.indirecttrainninglist,
                  );
                },
              ),
              Text(LabelText.indirectreglist,
                  style: Styles.red164
                      .copyWith(color: ColorConstants.defaultMaroon))
            ],
          ),
        ),
        floatingActionButton: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: () async {
                isDisposed = true;
                await Navigator.pushNamed(
                  context,
                  RouteConstants.indirecttrainningReg,
                  arguments: [indirectData, null],
                );
              },
              backgroundColor: Color(0xffF97378),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff009CA6)),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff707070),
                                width: 1), // set the border color and width
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/dateBetween.png",
                                      scale: 3.3,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Trainning Session Date",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    Spacer(),
                                    Text(
                                      indirectData.trainingSessionDate!,
                                      style: Styles.black124,
                                    )
                                  ],
                                ),
                                const Divider(color: Color(0xff707070)),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/trainingName.png",
                                      scale: 3.3,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Training Name",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        indirectData.trainingName!,
                                        style: Styles.black124,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(color: Color(0xff707070)),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/dateBetween.png",
                                      scale: 3.3,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Date Between",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${firstDate} to ${lastDate}",
                                      style: Styles.black124,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: scrcontroller,
                          physics: const ClampingScrollPhysics(),
                          itemCount: indirectDataList.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final _trainingBatch = indirectDataList[index];

                            if (_trainingBatch == null) return null;

                            return GestureDetector(
                              onTap: () async {
                                /*  await Navigator.pushNamed(
                                  context,
                                  RouteConstants.indirecttrainningReg,
                                  arguments: [
                                    indirectData,
                                    _trainingBatch.indirectDataGuid
                                  ],
                                );*/
                              },
                              child: listindeirctList(_trainingBatch, index),
                            );
                          },
                        )
                      ])))),
        ),
      ),
    );
  }

  Widget listindeirctList(TrainingIndirectData trainingBatch, int index) {
    String createdDate = '';
    if (trainingBatch.createdOn!.isNotEmpty) {
      DateTime inputDate =
          DateFormat("yyyy-MM-dd").parse(trainingBatch.createdOn!);
      createdDate = DateFormat("dd/MM/yyyy").format(inputDate);
    }
    return Card(
        color: (index + 1) % 2 == 1 ? Color(0xffFFF7F7) : Color(0xffFFE5E6),
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            //color: Color(0xffF7F8FA),
            border: Border.all(color: Color(0xffBABABA)),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TrainingTitle(
                title: LabelText.createdBy,
                text: trainingBatch.createdBy ?? '',
                icon: "assets/trainerName.png",
              ),
              TrainingTitle(
                title: LabelText.createdon,
                text: createdDate,
                icon: "assets/dateBetween.png",
              )
            ],
          ),
        ));
  }
}

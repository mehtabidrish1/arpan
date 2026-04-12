import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/screens/training/training_batch_creation.dart';
import 'package:arpan/screens/training/training_schedule_list_page.dart';
import 'package:arpan/table_model/tbl_training_registration_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../table_model/tbl_block_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/download_data.dart';
import '../../utils/lableText.dart';
import '../../widgets/custom_loading_indicator.dart';

class TrainingBatchList extends StatefulWidget {
  const TrainingBatchList({Key? key}) : super(key: key);

  @override
  State<TrainingBatchList> createState() => _TrainingBatchListState();
}

class _TrainingBatchListState extends State<TrainingBatchList> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var fillTrainingRegistrationList = <TblTrainingRegistration>[];
  var mainTrainingRegistrationList = <TblTrainingRegistration>[];

  final ScrollController scrcontroller = ScrollController();
  bool isDisposed = false;
  var trainingType = '';
  String firstDate = '';
  String lastDate = '';
  List<BlockDatum> blocks = [];
  List<String?> distinctBlocks = [];
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data;
      }
      blocks = await DataProvider().getAllBlock();

      fillTrainingRegistrationList =
          await DataProvider().getTrainingRegistration();
      fillTrainingRegistrationList = fillTrainingRegistrationList
          .where((element) =>
              element.scheduleGuid == mainTrainingSchedule.scheduleGuid)
          .toList();
      distinctBlocks = fillTrainingRegistrationList
          .map((registration) => registration.Block)
          .toSet()
          .toList();
      if (mainTrainingSchedule.trainingType != null &&
          mainTrainingSchedule.trainingType!.isNotEmpty) {
        trainingType = mainTrainingSchedule.trainingType == '2'
            ? 'Basic training'
            : 'Advanced training';
      }

      if (mainTrainingSchedule.firstDate!.isNotEmpty) {
        DateTime inputDate =
            DateFormat("yyyy-MM-dd").parse(mainTrainingSchedule.firstDate!);
        firstDate = DateFormat("dd/MM/yyyy").format(inputDate);
      }

      if (mainTrainingSchedule.lastDate!.isNotEmpty) {
        DateTime inputDate =
            DateFormat("yyyy-MM-dd").parse(mainTrainingSchedule.lastDate!);
        lastDate = DateFormat("dd/MM/yyyy").format(inputDate);
      }
      setState(() {
        isDisposed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();

        isDisposed = true;

        await Navigator.popAndPushNamed(
          context,
          RouteConstants.trainingListScreen,
        );
        return true;
      },
      child: Scaffold(
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
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  isDisposed = true;

                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.trainingListScreen,
                  );
                },
              ),
              Text(LabelText.trainingBactch,
                  style: Styles.red164.copyWith(
                    color: ColorConstants.defaultMaroon,
                  ))
            ],
          ),
        ),
        // floatingActionButton: SizedBox(
        //     width: 50,
        //     height: 50,
        //     child: FloatingActionButton(
        //       onPressed: () async {
        //         isDisposed = true;
        //         await Navigator.popAndPushNamed(
        //           context,
        //           RouteConstants.trainingBatchCreation,
        //           arguments: [mainTrainingSchedule, null],
        //         );
        //       },
        //       backgroundColor: Color(0xffF97378),
        //       child: Container(
        //         width: 50,
        //         height: 50,
        //         decoration: BoxDecoration(
        //             shape: BoxShape.circle, color: Color(0xff009CA6)),
        //         child: Icon(
        //           Icons.add,
        //           size: 30,
        //         ),
        //       ),
        //     )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff707070),
                                width: 1), // set the border color and width
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
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
                                      "Year",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    const Spacer(),
                                    Text(
                                      mainTrainingSchedule.year!,
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
                                    const Spacer(),
                                    Expanded(
                                      child: Text(
                                        mainTrainingSchedule.trainingName!,
                                        style: Styles.black124,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(color: Color(0xff707070)),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/trainerName.png",
                                      scale: 3.3,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Types of Group",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    const Spacer(),
                                    Text(
                                      mainTrainingSchedule.typeOfGroup!,
                                      style: Styles.black124,
                                    )
                                  ],
                                ),
                                const Divider(color: Color(0xff707070)),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/theme.png",
                                      scale: 3.3,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Intervention",
                                      style: Styles.grey124.copyWith(
                                          color: ColorConstants.defaultMaroon),
                                    ),
                                    const Spacer(),
                                    Text(
                                      trainingType,
                                      style: Styles.black124,
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
                                    const Spacer(),
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
                          itemCount: distinctBlocks.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final _trainingblock = distinctBlocks[index];

                            if (_trainingblock == null) return null;

                            return expendadedBlockList(_trainingblock);
                          },
                        )
                      ])))),
        ),
      ),
    );
  }

  Widget expendadedBlockList(String? block) {
    String? blockName = "";
    List<TblTrainingRegistration> childList = [];

    try {
      blockName = blocks
          .where((element) => element.id.toString() == block)
          .first
          .blockName;
      childList = fillTrainingRegistrationList
          .where((element) => element.Block == block)
          .toList();
    } catch (e) {}
    return Card(
      child: ExpansionTile(
        title: Text(
          '$blockName (${childList.length})',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        children: <Widget>[
          for (int index = 0; index < childList.length; index++) ...{
            listBatchCard(childList[index], index)
          }
        ],
      ),
    );
  }

  Widget listBatchCard(TblTrainingRegistration trainingBatch, int index) {
    String? blockName = "";
    try {
      blockName = blocks
          .where((element) => element.id.toString() == trainingBatch.Block)
          .first
          .blockName;
    } catch (e) {}
    return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color(0xff707070),
              width: 1), // set the border color and width
          borderRadius: BorderRadius.circular(20),
        ),
        // color: (index + 1) % 2 == 1 ? Color(0xffFFF7F7) : Color(0xffFFE5E6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: TrainingTitle(
                title: LabelText.block,
                text: blockName ?? '',
                icon: "assets/theme.png",
              ),
            ),
            const Divider(color: Color(0xff707070)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: TrainingTitle(
                title: LabelText.batchno,
                text: trainingBatch.batchNo ?? '',
                icon: "assets/theme.png",
              ),
            ),
            const Divider(color: Color(0xff707070)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: TrainingTitle(
                title: LabelText.trainerName,
                text: trainingBatch.trainerName,
                icon: "assets/theme.png",
              ),
            ),
            Container(
              height: 50.h,
              decoration: const BoxDecoration(
                color: Color(0xffFFE5E6),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.trainingBatchSessionList,
                          arguments: [mainTrainingSchedule, trainingBatch],
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/batch.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            LabelText.batchSession,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.trainingBatchCreation,
                          arguments: [mainTrainingSchedule, trainingBatch],
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/edit.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            LabelText.edit,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

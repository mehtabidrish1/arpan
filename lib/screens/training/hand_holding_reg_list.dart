import 'package:arpan/screens/training/training_batch_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../database/dataProvider.dart';
import '../../table_model/tbl_master_model.dart';
import '../../table_model/tbl_training_hand_holding.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/lableText.dart';
import 'hand_holding_schedule_list_page.dart';

class HandHoldingRegList extends StatefulWidget {
  const HandHoldingRegList({Key? key}) : super(key: key);

  @override
  State<HandHoldingRegList> createState() => _HandHoldingRegListState();
}

class _HandHoldingRegListState extends State<HandHoldingRegList> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var fillTrainingRegistrationList = <TblTrainingHandHolding>[];
  final ScrollController scrcontroller = ScrollController();
  bool isDisposed = false;
  var trainingType = '';
    List<TblMasterModel> handHoldingInterventionModelList = [];

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data;
      }
      fillTrainingRegistrationList = await DataProvider()
          .getHandholingRegistration(mainTrainingSchedule.scheduleGuid!);

      if (mainTrainingSchedule.trainingType != null &&
          mainTrainingSchedule.trainingType!.isNotEmpty) {
        trainingType = mainTrainingSchedule.trainingType == '2'
            ? 'Basic training'
            : 'Advanced training';
      }
       handHoldingInterventionModelList =
        await DataProvider().getMastrerListData('HandHoldingIntervention');
      setState(() {
        isDisposed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                    RouteConstants.handholdingscheduleListScreen,
                  );
                },
              ),
              Text(
                LabelText.trainingHandHolding,
                style:
                    Styles.red164.copyWith(color: ColorConstants.defaultMaroon),
              )
            ],
          ),
        ),
        floatingActionButton: SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: () async {
                isDisposed = true;
                await Navigator.popAndPushNamed(
                  context,
                  RouteConstants.handholdingreg,
                  arguments: [mainTrainingSchedule, null],
                );
              },
              backgroundColor: Color(0xffF97378),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.defaultRedColor),
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
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Card(
                          color: Color(0xffFFF7F7),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff707070),
                                width: 1), // set the border color and width
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  createRowWidget(
                                      LabelText.year,
                                      mainTrainingSchedule.year ?? '',
                                      "assets/dateBetween.png"),
                                  const Divider(color: Color(0xff707070)),
                                  createRowWidget(
                                      LabelText.trainingName,
                                      mainTrainingSchedule.trainingName ?? '',
                                      "assets/trainingName.png"),
                                  const Divider(color: Color(0xff707070)),
                                  createRowWidget(
                                      LabelText.tog,
                                      mainTrainingSchedule.typeOfGroup ?? '',
                                      "assets/trainerName.png"),
                                  const Divider(color: Color(0xff707070)),
                                  createRowWidget(LabelText.trainingType,
                                      trainingType ?? '', "assets/theme.png"),
                                ]),
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
                          itemCount: fillTrainingRegistrationList.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            final _traininghandhold =
                                fillTrainingRegistrationList[index];

                            if (_traininghandhold == null) return null;

                            return GestureDetector(
                              onTap: () async {},
                              child: listBatchCard(_traininghandhold, index),
                            );
                          },
                        )
                      ])))),
        ),
      ),
    );
  }

  Widget listBatchCard(TblTrainingHandHolding trainingBatch, int index) {
    String outputDateString = '';
    try {
      if (trainingBatch.handHoldingDate!.isNotEmpty) {
        DateTime inputDate =
            DateFormat("yyyy-MM-dd").parse(trainingBatch.handHoldingDate!);
        outputDateString = DateFormat("dd/MM/yyyy").format(inputDate);
      }
    } catch (e) {
      outputDateString = trainingBatch.handHoldingDate!;
    }
    var handHoldingIntervention="";
    try{
 handHoldingIntervention=  handHoldingInterventionModelList
          .where((element) =>
              element.value == trainingBatch.handHoldingIntervention!)
          .first
          .text;
    }catch(e){

    }
   

    return Card(
        color: (index + 1) % 2 == 1 ? Color(0xffFFF7F7) : Color(0xffFFE5E6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrainingTitle(
                title: LabelText.handholdingdate,
                text: outputDateString,
                icon: 'assets/dateBetween.png',
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: 'HandHolding Intervention',
                text: handHoldingIntervention,
                icon: 'assets/theme.png',
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: LabelText.traingName,
                text: trainingBatch.trainingName,
                icon: 'assets/trainingName.png',
              ),
              const Divider(color: Color(0xff707070)),
              // Container(
              //   height: 1,
              //   decoration: BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(
              //         color: Colors.grey[300]!,
              //         width: 1,
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.handholdingAttendance,
                          arguments: [mainTrainingSchedule, trainingBatch],
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/batch.png',
                            width: 35,
                            height: 35,
                          ),
                          Text(
                            LabelText.attendence,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.handholdingreg,
                          arguments: [mainTrainingSchedule, trainingBatch],
                        );
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/edit.png',
                            width: 35,
                            height: 35,
                          ),
                          Text(
                            LabelText.edit,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

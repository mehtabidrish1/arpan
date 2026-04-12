import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/utils/DownloadData.dart';
import 'package:arpan/widgets/custom_curvedTextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../table_model/tblTraningIndirectData_list.dart';
import '../../../utils/common.dart';
import '../../../utils/download_data.dart';
import '../../../utils/lableText.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../training/trainingList.dart';

class IndirectTrainningListPage extends StatefulWidget {
  const IndirectTrainningListPage({Key? key}) : super(key: key);

  @override
  State<IndirectTrainningListPage> createState() =>
      _IndirectTrainningListPageState();
}

class _IndirectTrainningListPageState extends State<IndirectTrainningListPage> {
  var isDisposed = false;
  List<TblTraningIndirectDataList> indirectList = [];
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final ScrollController scrcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize the board with the initial cards
  }

  loadData() async {
    var mobileNo =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.phone);
    indirectList =
        await DataProvider().getTblTraningIndirectDataList(mobileNo!);
    return indirectList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // extendBodyBehindAppBar: true,
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
                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.participentdashboardScreen,
                    );
                  },
                ),
                Text("Adult/Child Data",
                    style: Styles.red164
                        .copyWith(color: ColorConstants.defaultMaroon))
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/rightButterflyTheme.png'),
                    fit: BoxFit.fill)),
            child: FutureBuilder(
              future: loadData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: Text('Loading...'));
                  default:
                    if (snapshot.hasError) {
                      return const SizedBox(
                        height: 10,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            CurvedTextField(
                              height: 38.h,
                              onChanged: (e) {},
                              preffixIcon: const Icon(
                                Icons.search,
                                size: 28,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.cancel_outlined)),
                              hintText: 'Search',
                              hintStyle: Styles.grey164,
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                controller: scrcontroller,
                                physics: const ClampingScrollPhysics(),
                                itemCount: indirectList.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final indirectListDetail =
                                      indirectList[index];

                                  if (indirectListDetail == null) return null;

                                  return GestureDetector(
                                    onTap: () async {
                                      isDisposed = true;
                                      await Navigator.pushNamed(
                                        context,
                                        RouteConstants.indirecttrainningRegList,
                                        arguments: [indirectListDetail],
                                      );
                                    },
                                    child: listIndirectCard(
                                        indirectListDetail, index),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ));
  }

  Widget listIndirectCard(TblTraningIndirectDataList trainingBatch, int index) {
    return Card(
        // color: (index + 1) % 2 == 1 ? Colors.white : Color(0xffFFF7F7),
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
              TrainingTitle(
                title: LabelText.trainingName,
                text: trainingBatch.trainingName ?? '',
                icon: "assets/trainingName.png",
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: LabelText.trainerName,
                text: trainingBatch.trainerName,
                icon: "assets/trainerName.png",
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: LabelText.dateBetween,
                text:
                    '${trainingBatch.firstDate ?? ''} - ${trainingBatch.lastDate ?? ''}',
                icon: "assets/dateBetween.png",
              ),
            ],
          ),
        ));
  }
}

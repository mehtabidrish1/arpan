import 'package:arpan/database/dataProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/training_schedule_participant_model.dart';
import '../utils/log_files.dart';

final attendenceMarksheetProvider = StateNotifierProvider.family<
    AttendenceMarksheetController,
    List<TrainingScheduleParticipantModel>,
    String>((ref, trainingScheduleGuid) {
  return AttendenceMarksheetController(trainingScheduleGuid);
});
// ignore: prefer_function_declarations_over_variables
// Auto dispose will reload the provider whenit is called again
final attendenceMarksheetFutureProvider = FutureProvider.autoDispose
    .family<List<TrainingScheduleParticipantModel>, String>(
        (ref, trainingScheduleGuid) async {
  final provider =
      ref.watch(attendenceMarksheetProvider(trainingScheduleGuid).notifier);
  await provider.fetchState(trainingScheduleGuid);
  return ref.read(attendenceMarksheetProvider(trainingScheduleGuid));
});

class AttendenceMarksheetController
    extends StateNotifier<List<TrainingScheduleParticipantModel>> {
  AttendenceMarksheetController(String trainingScheduleGuid) : super([]);

  Future fetchState(String trainingScheduleGuid) async {
    try {
      // await DataDownload().getTrainingParticipantList(trainingScheduleGuid);
      //  await DataDownload() .getTrainingRegistrationAttendanceList(trainingScheduleGuid);
      final DataProvider dataprovider = DataProvider();
      var traingingScheduleParticipantList =
          <TrainingScheduleParticipantModel>[];
      traingingScheduleParticipantList = await dataprovider
          .getTrainingParticipant(scheduledGuid: trainingScheduleGuid);

      if (traingingScheduleParticipantList.isEmpty) {
        state = <TrainingScheduleParticipantModel>[];
      } else {
        state = traingingScheduleParticipantList;
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      //  log(e.toString(), name: 'attendenceMarkSheetController');
    }
  }
}

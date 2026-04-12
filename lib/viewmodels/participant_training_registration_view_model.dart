import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/table_model/tbl_training_schedule_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../utils/log_files.dart';

final participantTrainingRegistrationProvider = StateNotifierProvider<
    ParticipantTrainingRegistrationController,
    List<TblTrainingSchedule>>((ref) {
  return ParticipantTrainingRegistrationController();
});

// ignore: prefer_function_declarations_over_variables
// Auto dispose will reload the provider whenit is called again
final participantTrainingRegistrationFutureProvider =
    FutureProvider.autoDispose((ref) async {
  final provider = ref.watch(participantTrainingRegistrationProvider.notifier);
  await provider.fetchState();
  return ref.read(participantTrainingRegistrationProvider);
});

class ParticipantTrainingRegistrationController
    extends StateNotifier<List<TblTrainingSchedule>> {
  ParticipantTrainingRegistrationController() : super([]);

  Future fetchState() async {
    try {
      final DataProvider dataprovider = DataProvider();
      var traingingRegistrationParticipantList = <TblTrainingSchedule>[];
      traingingRegistrationParticipantList =
          await dataprovider.getTrainingSchedule('');

      if (traingingRegistrationParticipantList.isEmpty) {
        //  state = <TblTrainingRegistration>[];
      } else {
        // state = traingingRegistrationParticipantList;
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      //log(e.toString(), name: 'ParticipantTrainingRegistrationController');
    }
  }
}

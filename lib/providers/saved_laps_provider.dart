import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timerapp/models/lap_model.dart';

class SavedLapsNotifier extends StateNotifier <List<LapModel>> {
  SavedLapsNotifier() : super([]);

  void addToSavedLaps(LapModel saveLap) {
    state = [...state, saveLap];
  }

  void removeSavedLaps(LapModel removeLap) {
    state = state.where((element) => element != removeLap).toList();
  }
}

final savedLapsProvider =
    StateNotifierProvider<SavedLapsNotifier, List<LapModel>>(
  (ref) => SavedLapsNotifier(),
);





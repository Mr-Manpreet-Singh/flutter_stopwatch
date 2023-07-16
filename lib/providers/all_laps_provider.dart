import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AllLapsNotifire extends StateNotifier <List<String>> {
  AllLapsNotifire() : super([]);

  void addLap(String lap) {
    state = [...state, lap];
    debugPrint("lap Added : $lap\nTotal Laps in state = $state");
  }

  void removeAllLaps() {
    state = [];
  }
}

final allLapsProvider = StateNotifierProvider <AllLapsNotifire,List<String>> ((ref) =>  AllLapsNotifire());

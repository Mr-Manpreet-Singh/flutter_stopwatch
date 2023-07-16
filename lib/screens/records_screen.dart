import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timerapp/models/lap_model.dart';
import 'package:timerapp/providers/saved_laps_provider.dart';
import 'package:timerapp/widgets/top_navigation.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  String searchedText = "";
  @override
  Widget build(BuildContext context) {
    final laps = ref.watch(savedLapsProvider);

    List<LapModel> filteredLapsList =
        laps.where((element) => element.name.contains(searchedText)).toList();
    // List<LapModel> filteredLapsList = laps;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TopNavigation(isTimerScreen: false),
          // TopNavigation(),
          const SizedBox(height: 15),
          Card(
            elevation: 5,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchedText = value;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Search", prefixIcon: Icon(Icons.search)),
            ),
          ),
          const SizedBox(height: 15),
          (filteredLapsList.isEmpty)
              ? const Center(child: Text("No lap found"))
              : Expanded(
                  child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  itemCount: filteredLapsList.length,
                  itemBuilder: (context, index) => Container(
                    color: (index % 2 == 0)
                        ? const Color.fromRGBO(230, 230, 230, 1)
                        : const Color.fromRGBO(252, 252, 252, 1),
                    child: ListTile(
                      key: ValueKey(index),
                      title: Text(
                        filteredLapsList[index].name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        filteredLapsList[index].time,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                )),
        ],
      ),
    ));
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timerapp/models/lap_model.dart';
import 'package:timerapp/providers/all_laps_provider.dart';
import 'package:timerapp/providers/saved_laps_provider.dart';
import 'package:timerapp/widgets/top_navigation.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final _focusNode = FocusNode();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> _laps = [];
  // LapModel? _lap;
  // final String _savename = "";
  final _nameController = TextEditingController();
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    _laps = ref.read(allLapsProvider);

    if (!_focusNode.hasFocus) {
      // Hide the keyboard when there is no input field focused
      FocusManager.instance.primaryFocus?.unfocus();
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Hide the keyboard when there is no input field focused
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 10), _updateTime);
    }
  }

  void _stopTimer() {
    if (_stopwatch.isRunning) {
      showSnackBar();
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _lapTimer() {
    if (_stopwatch.isRunning) {
      String lapTime = formatTime(_stopwatch.elapsed);
      ref.read(allLapsProvider.notifier).addLap(lapTime);
      setState(() {
        _laps.add(lapTime);
      });
    }
  }

  void _resetTimer() {
    ref.read(allLapsProvider.notifier).removeAllLaps();
    _stopwatch.reset();
    _laps.clear();
    setState(() {});
  }

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _isRunning = true;
      });
    }
  }

  String formatTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds =
        (duration.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: TopNavigation(isTimerScreen: true),
                  // child: TopNavigation(),
                ),
                const SizedBox(height: 15),
                // timer data

                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Text(
                      formatTime(_stopwatch.elapsed),
                      style: const TextStyle(fontSize: 70),
                    )),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: (_isRunning) ? _lapTimer : _resetTimer,
                        child: CircleAvatar(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              const Color.fromRGBO(230, 230, 230, 1),
                          radius: 50,
                          child: Text(
                            textAlign: TextAlign.center,
                            (_isRunning) ? "Lap" : " Reset",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 22),
                          ),
                        )),
                    GestureDetector(
                        // onTap: (_isStart)?_triggerOnStop:_triggerOnStart,
                        onTap: _isRunning ? _stopTimer : _startTimer,
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: (!_isRunning)
                              ? const Color.fromRGBO(46, 170, 139, 1)
                              : const Color.fromRGBO(211, 56, 82, 1),
                          radius: 50,
                          child: Text(
                            textAlign: TextAlign.center,
                            (!_isRunning) ? "Start" : "Stop",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 22),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 15),

                // lap list

                Expanded(
                  child: ListView.builder(
                      clipBehavior: Clip.hardEdge,
                      itemCount: _laps.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            showSaveDialogBox(context, _laps[index]);
                          },
                          child: Container(
                            color: (index % 2 == 0)
                                ? const Color.fromRGBO(230, 230, 230, 1)
                                : const Color.fromRGBO(252, 252, 252, 1),
                            child: ListTile(
                              key: ValueKey(index),
                              title: Text(
                                "Lap ${index + 1}",
                                style: const TextStyle(fontSize: 20),
                              ),
                              trailing: Text(
                                _laps[index],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )));
  }

  // Saving lap

  Future<dynamic> showSaveDialogBox(BuildContext context, String lapTime) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: TextField(
                        controller: _nameController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                            hintText: "Name the Record.."),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancle")),
                        ElevatedButton.icon(
                            onPressed: () {
                              if (_nameController.text.isEmpty) return;
                              final saveName = _nameController.text;

                              ref
                                  .read(savedLapsProvider.notifier)
                                  .addToSavedLaps(
                                      LapModel(time: lapTime, name: saveName));
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Lap Saved..")));
                              _nameController.text = "";
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save")),
                      ],
                    )
                  ],
                ),
              ),
            ),
            title: const Text("Save record"),
          );
        });
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Press and hold the Lap to save")));
  }
}

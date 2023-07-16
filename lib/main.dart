import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timerapp/screens/timer_screen.dart';

void main() {
  runApp(const ProviderScope(child: TimerApp()));
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child:  MaterialApp(
        home: TimerScreen(),
        // home: TopNavigation(isTimerScreen: true),
        // home: PageViewWidget(),
      ),
    );
  }
}

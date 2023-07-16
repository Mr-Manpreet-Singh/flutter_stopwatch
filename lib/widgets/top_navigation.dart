import 'package:flutter/material.dart';
import 'package:timerapp/screens/records_screen.dart';
import 'package:timerapp/screens/timer_screen.dart';



class TopNavigation extends StatefulWidget {
  TopNavigation({super.key, required this.isTimerScreen});
   bool isTimerScreen;

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
  
  void _onRecordTap() {
    if (!widget.isTimerScreen) return;
    setState(() {
      widget.isTimerScreen = false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const RecordScreen(),
    ));
  }

  void _onTimerTap() {
    if (widget.isTimerScreen) return;
    setState(() {
      widget.isTimerScreen = true;
    });
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TimerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            style: BorderStyle.solid,
            color: const Color.fromRGBO(235, 235, 235, 1),
            width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: _onTimerTap,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (widget.isTimerScreen) ? Colors.black : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Text(
                "Timer",
                style: TextStyle(
                    fontSize: 18,
                    color:
                        (widget.isTimerScreen) ? Colors.white : Colors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onRecordTap,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (widget.isTimerScreen) ? Colors.white : Colors.black,
              ),
              // color: (widget.isTimerScreen) ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Text(
                "Records",
                style: TextStyle(
                    fontSize: 18,
                    color:
                        (widget.isTimerScreen) ? Colors.black : Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

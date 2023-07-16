import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class LapModel {
   LapModel( {required this.time, required this.name}) : id = uuid.v4();
  final String time;
  final String name;
  final String id;
  // final String lapNumber;
}


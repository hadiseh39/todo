import 'package:uuid/uuid.dart';

class Task {
  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
  }) : id = const Uuid().v4();

  final String title;
  final String id;
  final String description;
  bool isCompleted;
}

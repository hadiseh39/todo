import 'package:todo/models/model.dart';

class Task extends Model {
  bool isCompleted;

  Task({
    required super.title,
    super.description,
    this.isCompleted = false,
    required super.id,
  });
}

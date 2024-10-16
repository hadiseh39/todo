import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  Future<void> loadPlaces() async {}

  void addTask(String title, String description) async {
    final newTask = Task(title: title, description: description);

    state = [newTask, ...state];
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

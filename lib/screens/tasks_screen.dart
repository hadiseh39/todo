import 'package:flutter/material.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/add_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/widgets/task_list.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late Future<void> _taskFuture;

  @override
  void initState() {
    super.initState();
    _taskFuture = ref.read(tasksProvider.notifier).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('to do tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddTask(
                    screenTitle: 'افزودن وظیفه جدید',
                  )));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return TaskList(tasks: tasks);
          }
        },
      ),
    );
  }
}

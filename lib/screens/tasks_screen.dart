import 'package:flutter/material.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/add_task.dart';
import 'package:todo/taskslist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  //late Future<void> _taskFuture;

  @override
  void initState() {
    super.initState();
    // _taskFuture = ref.watch(tasksProvider.notifier).loadPlaces();
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
              builder: (context) => const AddTask(
                    screenTitle: 'افزودن وظیفه جدید',
                  )));
        },
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? Text('data')
          : Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        tasks[index].title,
                        style: tasks[index].isCompleted
                            ? TextStyle(
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize,
                                decoration: TextDecoration.lineThrough)
                            : Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      subtitle: Text(
                        tasks[index].description,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                      leading: tasks[index].isCompleted
                          ? IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  tasks[index].isCompleted =
                                      !tasks[index].isCompleted;
                                });
                                //TODO : tasksList[index].save();
                              })
                          : IconButton(
                              icon: const Icon(Icons.circle_outlined),
                              onPressed: () {
                                setState(() {
                                  tasks[index].isCompleted =
                                      !tasks[index].isCompleted;
                                });
                                //task.save();
                              },
                            ),
                      onTap: () {
                        setState(() {
                          // var isEditing = true;
                          // titleController.text = tasksList[index].title;
                          // descriptionController.text =
                          //     task.description;
                        });
                      },
                    );
                  }),
            ),
    );
  }
}

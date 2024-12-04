import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/add_task.dart';

import '../models/task.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key, required this.tasks});

  final List tasks;

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  int completedTasksCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCompletedTasksCount();
  }

  Future<void> _loadCompletedTasksCount() async {
    final count = await ref.read(tasksProvider.notifier).countCompletedTasks();
    setState(() {
      completedTasksCount = count;
    });
  }

  void _toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    ref.read(tasksProvider.notifier).updateTask(task);
    _loadCompletedTasksCount();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      child: widget.tasks.isEmpty
          ? Center(
              child: Text(
              'No Task Added yet',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ))
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      completedTasksCount == widget.tasks.length
                          ? 'All tasks completed!'
                          : 'Completed Tasks : $completedTasksCount of ${widget.tasks.length}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(width: 20),
                    CircularProgressIndicator(
                      value: completedTasksCount / widget.tasks.length,
                      backgroundColor: const Color.fromARGB(49, 193, 193, 193),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(widget.tasks[index].id),
                          onDismissed: (direction) {
                            ref
                                .read(tasksProvider.notifier)
                                .deleteTask(widget.tasks[index].id);

                            _loadCompletedTasksCount();

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.tasks[index].title} deleted!',
                                ),
                              ),
                            );
                          },
                          background: Container(color: Colors.red),
                          child: ListTile(
                            title: Text(
                              widget.tasks[index].title,
                              style: widget.tasks[index].isCompleted
                                  ? TextStyle(
                                      color: Colors.black,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .fontSize,
                                      decoration: TextDecoration.lineThrough)
                                  : Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                            ),
                            subtitle: Text(
                              widget.tasks[index].description,
                              style: widget.tasks[index].isCompleted
                                  ? TextStyle(
                                      color: Colors.black,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .fontSize,
                                      decoration: TextDecoration.lineThrough)
                                  : Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                            ),
                            leading: widget.tasks[index].isCompleted
                                ? IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      _toggleTaskCompletion(
                                          widget.tasks[index]);
                                    })
                                : IconButton(
                                    icon: const Icon(Icons.circle_outlined),
                                    onPressed: () {
                                      _toggleTaskCompletion(
                                          widget.tasks[index]);
                                    },
                                  ),
                            onTap: () {
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddTask(
                                          isEditing: true,
                                          task: widget.tasks[index],
                                        )));
                              });
                            },
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}

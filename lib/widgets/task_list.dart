import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/task_provider.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key, required this.tasks});

  final List tasks;

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: widget.tasks.isEmpty
          ? const Text('no task to do')
          : ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(widget.tasks[index].id),
                  onDismissed: (direction) {
                    ref
                        .read(tasksProvider.notifier)
                        .deleteTask(widget.tasks[index].id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('${widget.tasks[index].title} deleted')),
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
                          : Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    ),
                    subtitle: Text(
                      widget.tasks[index].description,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    leading: widget.tasks[index].isCompleted
                        ? IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              //setState(() {
                              widget.tasks[index].isCompleted =
                                  !widget.tasks[index].isCompleted;
                              ref
                                  .read(tasksProvider.notifier)
                                  .updateTask(widget.tasks[index]);
                              // });
                              //TODO : tasksList[index].save();
                            })
                        : IconButton(
                            icon: const Icon(Icons.circle_outlined),
                            onPressed: () {
                              widget.tasks[index].isCompleted =
                                  !widget.tasks[index].isCompleted;
                              ref
                                  .read(tasksProvider.notifier)
                                  .updateTask(widget.tasks[index]);

                              //task.save();
                            },
                          ),
                    onTap: () {
                      print(widget.tasks[index].id);
                      setState(() {
                        // var isEditing = true;
                        // titleController.text = tasksList[index].title;
                        // descriptionController.text =
                        //     task.description;
                      });
                    },
                  ),
                );
              }),
    );
  }
}

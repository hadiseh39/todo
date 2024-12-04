import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/task_provider.dart';

class AddTask extends ConsumerStatefulWidget {
  AddTask({super.key, this.isEditing = false, this.task});

  final bool isEditing;
  Task? task;

  @override
  ConsumerState<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final _taskTitleController = TextEditingController();
  final _taskDescriptionController = TextEditingController();

  void saveTask() {
    final enteredTitle = _taskTitleController.text;
    final enteredDescription = _taskDescriptionController.text;

    if (enteredTitle.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The task title can\'t be empty!'),
      ));
      return;
    }

    ref.read(tasksProvider.notifier).addTask(enteredTitle, enteredDescription);

    Navigator.of(context).pop();
  }

  void editTask() {
    widget.task!.title = _taskTitleController.text;
    widget.task!.description = _taskDescriptionController.text;

    ref.read(tasksProvider.notifier).updateTask(widget.task!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      _taskTitleController.text = widget.task!.title;
      _taskDescriptionController.text = widget.task!.description;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Task' : 'Add New Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _taskTitleController,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
                controller: _taskDescriptionController,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('cancel'),
                  ),
                  widget.isEditing
                      ? ElevatedButton.icon(
                          onPressed: editTask,
                          label: const Text('Edit'),
                          icon: const Icon(Icons.edit),
                        )
                      : ElevatedButton.icon(
                          onPressed: saveTask,
                          label: const Text('Add'),
                          icon: const Icon(Icons.add),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The task title cannot be empty'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'edit task' : 'add task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'عنوان'),
              controller: _taskTitleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)'),
              controller: _taskDescriptionController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                widget.isEditing
                    ? ElevatedButton.icon(
                        onPressed: editTask,
                        label: const Text('ویرایش'),
                        icon: const Icon(Icons.edit),
                      )
                    : ElevatedButton.icon(
                        onPressed: saveTask,
                        label: const Text('افزودن'),
                        icon: const Icon(Icons.add),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('لغو'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

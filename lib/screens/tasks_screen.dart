import 'package:flutter/material.dart';
import 'package:todo/taskslist.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('to do tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: tasksList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  tasksList[index].title,
                  style: tasksList[index].isCompleted
                      ? TextStyle(
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          decoration: TextDecoration.lineThrough)
                      : Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                ),
                subtitle: Text(
                  tasksList[index].description,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                leading: tasksList[index].isCompleted
                    ? IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          tasksList[index].isCompleted =
                              !tasksList[index].isCompleted;
                          setState(() {});
                          //tasksList[index].save();
                        })
                    : IconButton(
                        icon: const Icon(Icons.circle_outlined),
                        onPressed: () {
                          tasksList[index].isCompleted =
                              !tasksList[index].isCompleted;
                          setState(() {});
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

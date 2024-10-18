import 'package:flutter/material.dart';
import 'package:todo/providers/grocery_item_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/add_grocery.dart';
import 'package:todo/screens/add_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/widgets/grocery_list.dart';
import 'package:todo/widgets/task_list.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key, required this.provider});

  final StateNotifierProvider provider;

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late Future<void> _listFuture;

  @override
  void initState() {
    super.initState();
    if (widget.provider == tasksProvider) {
      _listFuture = ref.read(tasksProvider.notifier).loadTasks();
    } else {
      _listFuture = ref.read(groceryProvider.notifier).loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    List data = ref.watch(tasksProvider);
    if (widget.provider == groceryProvider) {
      data = ref.watch(groceryProvider);
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('to do tasks'),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            if (widget.provider == tasksProvider) {
              return AddTask();
            } else {
              return AddGrocery();
            }
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _listFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (widget.provider == tasksProvider) {
            return TaskList(tasks: data);
          } else {
            return GroceryList(groceryItems: data);
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/grocery.dart';
import 'package:todo/providers/grocery_item_provider.dart';
import 'package:todo/screens/add_grocery.dart';

class GroceryList extends ConsumerStatefulWidget {
  const GroceryList({super.key, required this.groceryItems});

  final List groceryItems;

  @override
  ConsumerState<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryList> {
  // int completedTasksCount = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   ref.read(groceryProvider.notifier).loadItems();
  // }

  // Future<void> _loadCompletedTasksCount() async {
  //   final count = await ref.read(tasksProvider.notifier).countCompletedTasks();
  //   setState(() {
  //     completedTasksCount = count;
  //   });
  // }

  // void _toggleTaskCompletion(Task task) async {
  //   task.isCompleted = !task.isCompleted;
  //   ref.read(tasksProvider.notifier).updateTask(task);
  //   _loadCompletedTasksCount();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: widget.groceryItems.isEmpty
          ? const Text('no item to buy')
          : Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       completedTasksCount == widget.groceryItems.length
                //           ? 'All tasks completed'
                //           : 'Completed Tasks: $completedTasksCount of ${widget.groceryItems.length}',
                //       style: Theme.of(context).textTheme.titleMedium!.copyWith(
                //             color: Theme.of(context).colorScheme.primary,
                //           ),
                //     ),
                //     const SizedBox(width: 20),
                //     CircularProgressIndicator(
                //       value: completedTasksCount / widget.groceryItems.length,
                //       backgroundColor: Colors.grey,
                //     ),
                //   ],
                // ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.groceryItems.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(widget.groceryItems[index].id),
                          onDismissed: (direction) {
                            ref
                                .read(groceryProvider.notifier)
                                .deleteItem(widget.groceryItems[index].id);

                            // _loadCompletedTasksCount();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.groceryItems[index].title} deleted',
                                ),
                              ),
                            );
                          },
                          background: Container(color: Colors.red),
                          child: ListTile(
                            title: Text(
                              widget.groceryItems[index].title,
                              style:
                                  // widget.groceryItems[index].isCompleted
                                  //     ? TextStyle(
                                  //         color: Colors.black,
                                  //         fontSize: Theme.of(context)
                                  //             .textTheme
                                  //             .titleMedium!
                                  //             .fontSize,
                                  //         decoration: TextDecoration.lineThrough)
                                  //:
                                  Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                            ),
                            subtitle: Text(
                              widget.groceryItems[index].description,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            trailing: Text(
                                widget.groceryItems[index].quantity.toString()),
                            leading: // widget.groceryItems[index].isCompleted?
                                widget.groceryItems[index].category.icon,

                            // : IconButton(
                            //     icon: const Icon(Icons.circle_outlined),
                            //     onPressed: () {
                            //       // _toggleTaskCompletion(
                            //       //     widget.tasks[index]);
                            //     },
                            //   ),
                            onTap: () {
                              print(widget.groceryItems[index].category
                                  .toString());
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddGrocery(
                                          isEditing: true,
                                          groceryItem:
                                              widget.groceryItems[index],
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

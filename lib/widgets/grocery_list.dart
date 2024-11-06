import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/providers/grocery_item_provider.dart';
import 'package:todo/screens/add_grocery.dart';

class GroceryList extends ConsumerStatefulWidget {
  const GroceryList({super.key, required this.groceryItems});

  final List groceryItems;

  @override
  ConsumerState<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends ConsumerState<GroceryList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: widget.groceryItems.isEmpty
          ? Center(
              child: Text(
                'چیزی برای خرید یافت نشد',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            )
          : Column(
              children: [
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

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.groceryItems[index].title} حذف شد',
                                ),
                              ),
                            );
                          },
                          background: Container(color: Colors.red),
                          child: ListTile(
                            title: Text(
                              widget.groceryItems[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                            leading: widget.groceryItems[index].category.icon,
                            onTap: () {
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

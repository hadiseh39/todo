import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/grocery.dart';
import 'package:todo/providers/grocery_item_provider.dart';

class AddGrocery extends ConsumerStatefulWidget {
  AddGrocery({super.key, this.isEditing = false, this.groceryItem});

  final bool isEditing;
  GroceryItem? groceryItem;

  @override
  ConsumerState<AddGrocery> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddGrocery> {
  final _itemTitleController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  var _selectedCategory = categories[Categories.food];

  void saveItem() {
    final enteredTitle = _itemTitleController.text;
    final enteredDescription = _itemDescriptionController.text;
    final enteredQuantity = int.tryParse(_itemQuantityController.text);
    //final selectedCategory = _selectedCategory;

    if (enteredTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The task title cannot be empty'),
      ));
      return;
    }

    ref.read(groceryProvider.notifier).addItem(
        enteredTitle, enteredDescription, enteredQuantity!, _selectedCategory);

    Navigator.of(context).pop();
  }

  void editItem() {
    widget.groceryItem!.title = _itemTitleController.text;
    widget.groceryItem!.description = _itemDescriptionController.text;

    //ref.read(tasksProvider.notifier).updateTask(widget.groceryItem!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      _itemTitleController.text = widget.groceryItem!.title;
      _itemDescriptionController.text = widget.groceryItem!.description;
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEditing ? 'edit grocery Item' : 'add grocery Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'عنوان'),
              controller: _itemTitleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)'),
              controller: _itemDescriptionController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'تعداد'),
              controller: _itemQuantityController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Expanded(
              child: DropdownButtonFormField(
                items: [
                  for (final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          category.value.icon,
                          Text(
                            '  ${category.value.title}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                widget.isEditing
                    ? ElevatedButton.icon(
                        onPressed: editItem,
                        label: const Text('ویرایش'),
                        icon: const Icon(Icons.edit),
                      )
                    : ElevatedButton.icon(
                        onPressed: saveItem,
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

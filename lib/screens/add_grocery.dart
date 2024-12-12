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
  ConsumerState<AddGrocery> createState() => _AddGroceryState();
}

class _AddGroceryState extends ConsumerState<AddGrocery> {
  final _itemTitleController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  var _selectedCategory;
  var newCt;

  Categories categoryToEnum(Category category) {
    return categories.entries
        .firstWhere((entry) => entry.value.title == category.title)
        .key;
  }

  void saveItem() {
    final enteredTitle = _itemTitleController.text;
    final enteredDescription = _itemDescriptionController.text;
    var enteredQuantity = int.tryParse(_itemQuantityController.text) ?? 1;

    if (enteredTitle.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The item title can\'t be empty!'),
      ));
      return;
    }

    final selectedCategoryEnum =
        categoryToEnum(_selectedCategory ?? categories[Categories.food]);

    ref.read(groceryProvider.notifier).addItem(enteredTitle, enteredDescription,
        enteredQuantity, selectedCategoryEnum);

    Navigator.of(context).pop();
  }

  void editItem(Categories category) {
    widget.groceryItem!.title = _itemTitleController.text;
    widget.groceryItem!.description = _itemDescriptionController.text;
    widget.groceryItem!.quantity = int.tryParse(_itemQuantityController.text)!;

    ref
        .read(groceryProvider.notifier)
        .updateItem(widget.groceryItem!, category);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      final itemCategory = categoryToEnum(widget.groceryItem!.category);
      _itemTitleController.text = widget.groceryItem!.title;
      _itemDescriptionController.text = widget.groceryItem!.description;
      _itemQuantityController.text = widget.groceryItem!.quantity.toString();
      _selectedCategory = categories[itemCategory];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Item' : 'Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _itemTitleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              controller: _itemQuantityController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              items: [
                for (final category in categories.entries)
                  DropdownMenuItem(
                    value: category.value,
                    child: Row(
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            color:
                                Theme.of(context).colorScheme.onSecondaryFixed,
                          ),
                          child: category.value.icon,
                        ),
                        Text(
                          '  ${category.value.title}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryFixed),
                        ),
                      ],
                    ),
                  )
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  if (widget.isEditing) {
                    newCt = _selectedCategory;
                  }
                });
              },
              decoration: const InputDecoration(labelText: 'Select a Category'),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
              controller: _itemDescriptionController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                        onPressed: () {
                          editItem(categoryToEnum(newCt ?? _selectedCategory));
                        },
                        label: const Text('Edit'),
                        icon: const Icon(Icons.edit),
                      )
                    : ElevatedButton.icon(
                        onPressed: saveItem,
                        label: const Text('Add'),
                        icon: const Icon(Icons.add),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

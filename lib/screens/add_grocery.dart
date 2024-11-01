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
  var _selectedCategory = categories[Categories.food];
  var newCt;

  Categories categoryToEnum(Category category) {
    return categories.entries
        .firstWhere((entry) => entry.value.title == category.title)
        .key;
  }

  void saveItem() {
    final enteredTitle = _itemTitleController.text;
    final enteredDescription = _itemDescriptionController.text;
    final enteredQuantity = int.tryParse(_itemQuantityController.text);

    if (enteredTitle.isEmpty || enteredQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The title or Quantity cannot be empty'),
      ));
      return;
    }

    final selectedCategoryEnum = categoryToEnum(_selectedCategory);

    ref.read(groceryProvider.notifier).addItem(enteredTitle, enteredDescription,
        enteredQuantity, selectedCategoryEnum);

    Navigator.of(context).pop();
  }

  void editItem(Categories category) {
    widget.groceryItem!.title = _itemTitleController.text;
    widget.groceryItem!.description = _itemDescriptionController.text;
    widget.groceryItem!.quantity = int.tryParse(_itemQuantityController.text)!;
    //final selectedCategoryEnum = categoryToEnum(category);
    print(category);

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
              decoration: const InputDecoration(labelText: 'تعداد'),
              keyboardType: TextInputType.number,
              controller: _itemQuantityController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'توضیحات (اختیاری)'),
              controller: _itemDescriptionController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Expanded(
              child: DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: [
                  for (final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value,
                      child: Row(
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
                    _selectedCategory = value!;
                    if (widget.isEditing) {
                      newCt = _selectedCategory;
                      print(newCt);
                    }
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Category'),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                widget.isEditing
                    ? ElevatedButton.icon(
                        onPressed: () {
                          editItem(categoryToEnum(newCt ?? _selectedCategory));
                          print(categoryToEnum(newCt!));
                          // final category = categoryToEnum(newCt);
                          // print(categoryToEnum(newCt));
                          // widget.groceryItem!.title = _itemTitleController.text;
                          // widget.groceryItem!.description =
                          //     _itemDescriptionController.text;
                          // widget.groceryItem!.quantity =
                          //     int.tryParse(_itemQuantityController.text)!;
                          // //final selectedCategoryEnum = categoryToEnum(category);

                          // ref.read(groceryProvider.notifier).updateItem(
                          //     widget.groceryItem!, categoryToEnum(newCt));

                          // Navigator.of(context).pop();
                        },
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

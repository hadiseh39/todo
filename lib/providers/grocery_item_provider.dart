import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/grocery.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

Future<Database> _getDatabase1() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'grocery.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE groceryItems(id TEXT PRIMARY KEY, title TEXT, description TEXT, quantity INTEGER, category TEXT)');
    },
    version: 1,
  );
  return db;
}

class GroceryItemNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemNotifier() : super(const []);

  void addItem(
    String title,
    String description,
    int quantity,
    Categories categoryEnum, // از enum به جای Category استفاده می‌کنیم
  ) async {
    final newGroceryItem = GroceryItem(
      id: const Uuid().v4(),
      title: title,
      description: description,
      quantity: quantity,
      category: categories[
          categoryEnum]!, // از map برای دریافت Category استفاده می‌کنیم
    );

    final db = await _getDatabase1();
    db.insert('groceryItems', {
      'id': newGroceryItem.id,
      'title': newGroceryItem.title,
      'description': newGroceryItem.description,
      'quantity': newGroceryItem.quantity,
      'category': categoryEnum.name,
    });
    final groceryItemData = await db.rawQuery('SELECT * FROM groceryItems');
    print(groceryItemData);

    state = [newGroceryItem, ...state];
  }

  Future<void> loadItems() async {
    final db = await _getDatabase1();
    final groceryItemData = await db.query('groceryItems');

    final groceryItems = groceryItemData
        .map((row) {
          final categoryString = row['category'] as String;

          final categoryEnum = Categories.values.firstWhere(
            (e) => e.name == categoryString,
            orElse: () => Categories.other,
          );

          return GroceryItem(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            quantity: row['quantity'] as int,
            category: categories[categoryEnum]!,
          );
        })
        .toList()
        .reversed
        .toList();

    state = groceryItems;
  }

  Future<void> deleteItem(String id) async {
    final db = await _getDatabase1();

    await db.delete(
      'groceryItems',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((groceryItem) => groceryItem.id != id).toList();
  }

  Future<void> updateItem(
    GroceryItem updatedItem,
    Categories categoryEnum,
  ) async {
    final db = await _getDatabase1();

    await db.update(
      'groceryItems',
      {
        'title': updatedItem.title,
        'description': updatedItem.description,
        'quantity': updatedItem.quantity,
        'category': categoryEnum.name,
      },
      where: 'id = ?',
      whereArgs: [updatedItem.id],
    );

    final groceryItemData = await db.rawQuery('SELECT * FROM groceryItems');
    print(groceryItemData);

    state = state.map((groceryItem) {
      if (groceryItem.id == updatedItem.id) {
        return GroceryItem(
          id: updatedItem.id,
          title: updatedItem.title,
          description: updatedItem.description,
          quantity: updatedItem.quantity,
          category: categories[categoryEnum]!,
        );
      }
      return groceryItem;
    }).toList();
  }
}

final groceryProvider =
    StateNotifierProvider<GroceryItemNotifier, List<GroceryItem>>(
  (ref) => GroceryItemNotifier(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/grocery.dart';
import 'package:todo/models/task.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'todo.db'),
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

  Future<void> loadItems() async {
    final db = await _getDatabase();
    final groceryItemData = await db.query('groceryItems');
    final groceryItems = groceryItemData
        .map((row) => GroceryItem(
              id: row['id'] as String,
              title: row['title'] as String,
              description: row['description'] as String,
              quantity: row['quantity'] as int,
              category: row['category'] as Category,
            ))
        .toList()
        .reversed
        .toList();

    state = groceryItems;
  }

  void addItem(
      String title, String description, int quantity, Category category) async {
    final newGroceryItem = GroceryItem(
        id: const Uuid().v4(),
        title: title,
        description: description,
        quantity: quantity,
        category: category);

    final db = await _getDatabase();
    db.insert('groceryItems', {
      'id': newGroceryItem.id,
      'title': newGroceryItem.title,
      'description': newGroceryItem.description,
      'quantity': newGroceryItem.quantity,
      'category': newGroceryItem.category.toString(),
    });
    state = [newGroceryItem, ...state];
  }

  Future<void> deleteItem(String id) async {
    final db = await _getDatabase();

    await db.delete(
      'groceryItems',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((task) => task.id != id).toList();
  }

  // Future<void> updateTask(Task updatedTask) async {
  //   final db = await _getDatabase();

  //   await db.update(
  //     'tasks',
  //     {
  //       'title': updatedTask.title,
  //       'description': updatedTask.description,
  //       'isCompleted': updatedTask.isCompleted ? 1 : 0,
  //     },
  //     where: 'id = ?',
  //     whereArgs: [updatedTask.id],
  //   );

  //   state = state.map((task) {
  //     if (task.id == updatedTask.id) {
  //       return updatedTask;
  //     }
  //     return task;
  //   }).toList();
  // }

  // Future<int> countCompletedTasks() async {
  //   final db = await _getDatabase();

  //   final completedCount = sql.Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM tasks WHERE isCompleted = 1'));

  //   return completedCount ?? 0;
  // }
}

final groceryProvider =
    StateNotifierProvider<GroceryItemNotifier, List<GroceryItem>>(
  (ref) => GroceryItemNotifier(),
);

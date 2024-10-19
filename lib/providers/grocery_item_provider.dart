import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/grocery.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'todo.db'),
    onCreate: (db, version) {
      // این فقط برای زمانی است که دیتابیس تازه ساخته می‌شود
      db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER)');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        // اضافه کردن جدول groceryItems در صورت نیاز به آپدیت
        print("Upgrading database and creating groceryItems table");
        db.execute(
            'CREATE TABLE groceryItems(id TEXT PRIMARY KEY, title TEXT, description TEXT, quantity INTEGER, category TEXT)');
      }
    },
    version: 2, // تغییر نسخه دیتابیس به 2
  );
  return db;
}

Future<Database> _getDatabase1() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'grocery.db'),
    onCreate: (db, version) {
      print(
          "Creating groceryItems table******************************************");
      return db.execute(
          'CREATE TABLE groceryItems(id TEXT PRIMARY KEY, title TEXT, description TEXT, quantity INTEGER, category TEXT)');
    },
    version: 1,
  );
  return db;
}

class GroceryItemNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemNotifier() : super(const []);

  // void addItem(
  //   String title,
  //   String description,
  //   int quantity,
  //   Category category,
  // ) async {
  //   final newGroceryItem = GroceryItem(
  //       id: const Uuid().v4(),
  //       title: title,
  //       description: description,
  //       quantity: quantity,
  //       category: category);

  //   final db = await _getDatabase();
  //   db.insert('groceryItems', {
  //     'id': newGroceryItem.id,
  //     'title': newGroceryItem.title,
  //     'description': newGroceryItem.description,
  //     'quantity': newGroceryItem.quantity,
  //     'category': categories.keys
  //         .firstWhere((k) => categories[k] == newGroceryItem.category)
  //         .name,
  //     //newGroceryItem.category // categories.keys
  //     //     .firstWhere((k) => categories[k] == newGroceryItem.category)
  //     //     .name,
  //   });

  //   state = [newGroceryItem, ...state];
  // }

  // ******************

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
      'category': categoryEnum.name, // ذخیره نام enum (مثلاً 'food')
    });
    print("inserted******************************************");
    final groceryItemData = await db.rawQuery('SELECT * FROM groceryItems');
    print(groceryItemData);

    state = [newGroceryItem, ...state];
  }

  Future<void> loadItems() async {
    final db = await _getDatabase1();
    final groceryItemData = await db.query('groceryItems');
    print("load******************************************");

    final groceryItems = groceryItemData
        .map((row) {
          final categoryString = row['category'] as String;
          print(
              "Category String: $categoryString +++++++++++++++++++++++++++++++++");

          // تبدیل categoryString به enum Categories
          final categoryEnum = Categories.values.firstWhere(
            (e) => e.name == categoryString,
            orElse: () => Categories.other, // اگر تطابقی یافت نشد
          );

          // استفاده از categories map برای دسترسی به Category
          return GroceryItem(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            quantity: row['quantity'] as int,
            category: categories[categoryEnum]!, // برگرداندن Category از map
          );
        })
        .toList()
        .reversed
        .toList();
    print("loaded******************************************");

    state = groceryItems;
  }

  // Future<void> loadItems() async {
  //   final db = await _getDatabase();
  //   final groceryItemData = await db.query('groceryItems');
  //   final groceryItems = groceryItemData
  //       .map((row) {
  //         // final categoryString = row['category'] as String;
  //         // final categoryEnum =
  //         // Categories.values.firstWhere((e) => e.name == categoryString);

  //         return GroceryItem(
  //           id: row['id'] as String,
  //           title: row['title'] as String,
  //           description: row['description'] as String,
  //           quantity: row['quantity'] as int,
  //           category: categories[Categories.book],
  //         );
  //       })
  //       .toList()
  //       .reversed
  //       .toList();

  //   state = groceryItems;
  // }

  Future<void> deleteItem(String id) async {
    final db = await _getDatabase1();

    await db.delete(
      'groceryItems',
      where: 'id = ?',
      whereArgs: [id],
    );

    state = state.where((groceryItem) => groceryItem.id != id).toList();
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

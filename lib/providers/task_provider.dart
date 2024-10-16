import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';
import 'package:path_provider/path_provider.dart' as syspath;
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
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER)');
    },
    version: 1,
  );
  return db;
}

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(const []);

  Future<void> loadTasks() async {
    final db = await _getDatabase();
    final taskData = await db.query('tasks');
    final tasks = taskData
        .map((row) => Task(
              id: row['id'] as String,
              title: row['title'] as String,
              description: row['description'] as String,
              isCompleted: (row['isCompleted'] as int) == 1,
            ))
        .toList();

    state = tasks;
  }

  void addTask(String title, String description) async {
    //final appdir = await syspath.getApplicationDocumentsDirectory();
    final newTask =
        Task(id: const Uuid().v4(), title: title, description: description);

    final db = await _getDatabase();
    db.insert('tasks', {
      'id': newTask.id,
      'title': newTask.title,
      'description': newTask.description,
      'isCompleted': newTask.isCompleted ? 1 : 0,
    });
    state = [newTask, ...state];
  }

  Future<void> deleteTask(String id) async {
    final db = await _getDatabase();

    // حذف تسک بر اساس id
    await db.delete(
      'tasks',
      where: 'id = ?', // شرط حذف
      whereArgs: [id], // آرگومان‌های شرط
    );

    // حذف تسک از لیست
    state = state.where((task) => task.id != id).toList();

    //await loadTasks();
  }

  Future<void> updateTask(Task updatedTask) async {
    final db = await _getDatabase();

    // آپدیت تسک با استفاده از id
    await db.update(
      'tasks',
      {
        'title': updatedTask.title,
        'description': updatedTask.description,
        'isCompleted': updatedTask.isCompleted ? 1 : 0, // تبدیل به INTEGER
      },
      where: 'id = ?',
      whereArgs: [updatedTask.id],
    );

    // آپدیت لیست محلی (state)
    state = state.map((task) {
      if (task.id == updatedTask.id) {
        return updatedTask;
      }
      return task;
    }).toList();
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(
  (ref) => TasksNotifier(),
);

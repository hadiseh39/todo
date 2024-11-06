import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/screens/tabs.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: ThemeData(
    fontFamily: 'Sahel',
  ).textTheme.copyWith(
        titleSmall: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Sahel',
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Sahel',
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Sahel',
        ),
      ),
);

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final dbPath = await sql.getDatabasesPath();
  // await sql.deleteDatabase(path.join(dbPath, 'todo.db'));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fa'),
      debugShowCheckedModeBanner: false,
      theme: theme,
      home:
          const Directionality(textDirection: TextDirection.rtl, child: Tabs()),
    );
  }
}

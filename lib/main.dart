import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/screens/tasks_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  surface: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: ThemeData().textTheme.copyWith(
        titleSmall: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TasksScreen(),
    );
  }
}

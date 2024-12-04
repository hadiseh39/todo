import 'package:flutter/material.dart';

class Category {
  Category({required this.title, required this.icon});

  final String title;
  final Icon icon;
}

enum Categories {
  food,
  clothes,
  work,
  home,
  health,
  travel,
  sport,
  education,
  entertainment,
  book,
  accessory,
  other,
}

Map categories = {
  Categories.food: Category(
    title: 'Food',
    icon: const Icon(Icons.fastfood_rounded),
  ),
  Categories.clothes: Category(
    title: 'Clothes',
    icon: const Icon(Icons.dry_cleaning_rounded),
  ),
  Categories.work: Category(
    title: 'Work',
    icon: const Icon(Icons.work),
  ),
  Categories.health: Category(
    title: 'Health',
    icon: const Icon(Icons.medication_rounded),
  ),
  Categories.sport: Category(
    title: 'Workout',
    icon: const Icon(Icons.sports_basketball_rounded),
  ),
  Categories.home: Category(
    title: 'Home',
    icon: const Icon(Icons.home),
  ),
  Categories.education: Category(
    title: 'Education',
    icon: const Icon(Icons.edit_document),
  ),
  Categories.travel: Category(
    title: 'Travel',
    icon: const Icon(Icons.airplanemode_active_rounded),
  ),
  Categories.entertainment: Category(
    title: 'Leisure',
    icon: const Icon(Icons.sports_esports),
  ),
  Categories.book: Category(
    title: 'Book',
    icon: const Icon(Icons.menu_book_sharp),
  ),
  Categories.accessory: Category(
    title: 'Accessory',
    icon: const Icon(Icons.diamond_rounded),
  ),
  Categories.other: Category(
    title: 'Other',
    icon: const Icon(Icons.more_horiz),
  ),
};

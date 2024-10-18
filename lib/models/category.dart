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
    title: 'خوراک',
    icon: const Icon(Icons.fastfood_rounded),
  ),
  Categories.clothes: Category(
    title: 'پوشاک',
    icon: const Icon(Icons.dry_cleaning_rounded),
  ),
  Categories.work: Category(
    title: 'کسب و کار',
    icon: const Icon(Icons.work),
  ),
  Categories.health: Category(
    title: 'سلامتی ، آرایشی و بهداشتی',
    icon: const Icon(Icons.medication_rounded),
  ),
  Categories.sport: Category(
    title: 'ورزش',
    icon: const Icon(Icons.sports_basketball_rounded),
  ),
  Categories.home: Category(
    title: 'لوازم خانه',
    icon: const Icon(Icons.home),
  ),
  Categories.education: Category(
    title: 'تحصیلات و آموزش',
    icon: const Icon(Icons.edit_document),
  ),
  Categories.travel: Category(
    title: 'مسافرت',
    icon: const Icon(Icons.airplanemode_active_rounded),
  ),
  Categories.entertainment: Category(
    title: 'سرگرمی',
    icon: const Icon(Icons.sports_esports),
  ),
  Categories.book: Category(
    title: 'کتاب',
    icon: const Icon(Icons.menu_book_sharp),
  ),
  Categories.accessory: Category(
    title: 'اکسسوری',
    icon: const Icon(Icons.diamond_rounded),
  ),
  Categories.other: Category(
    title: 'سایر',
    icon: const Icon(Icons.more_horiz),
  ),
};

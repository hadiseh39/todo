import 'package:flutter/material.dart';
import 'package:todo/providers/grocery_item_provider.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/screens/list_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = 'تسک ها';

    Widget activePage = ListScreen(
      key: const ValueKey('tasks'),
      provider: tasksProvider,
    );

    if (_selectedPageIndex == 1) {
      activePageTitle = 'لیست خرید';
      activePage = ListScreen(
        key: const ValueKey('groceries'),
        provider: groceryProvider,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(activePageTitle),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              'راهنما',
                              textDirection: TextDirection.rtl,
                            ),
                            content: const Text(
                              'برای افزودن آیتم‌ها، از دکمه + موجود در پایین صفحه استفاده کنید.\nو برای حذف آیتم‌ها، آن‌ها را به سمت راست یا چپ بکشید.',
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'تائید',
                                ),
                              )
                            ],
                          ));
                },
                icon: const Icon(Icons.question_mark_rounded))
          ],
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          backgroundColor: Theme.of(context).colorScheme.surface,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded),
              label: 'تسک ها',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'لیست خرید',
            ),
          ],
        ));
  }
}

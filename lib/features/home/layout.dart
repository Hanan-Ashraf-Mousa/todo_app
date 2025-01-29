import 'package:flutter/material.dart';
import 'package:todo_app/features/settings/settings_screen.dart';

import '../tasks_list/tasks_list.dart';

class Layout extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const Layout({super.key});

  @override
  State<Layout> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Layout> {
  int selectedIndex = 0;
  List<Widget> screens = [
    TasksList(),
    SettingsScreen(),
    // replace with your widget here  // Add your other screens here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0 ? 'To Do List' : 'Settings'),
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        titleSpacing: MediaQuery.of(context).size.width * 0.04,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_outlined), label: 'Tasks List'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

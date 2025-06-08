import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/auth/login/login_screen.dart';
import 'package:todo_app/features/settings/settings_view.dart';
import 'package:todo_app/features/tasks_list/add_task_bottom_sheet.dart';
import 'package:todo_app/provider/auth_providers.dart';

import '../../provider/list_provider.dart';
import '../tasks_list/tasks_list_view.dart';

class Layout extends StatefulWidget {
  static const String routeName = "HomeScreen";

  const Layout({super.key});

  @override
  State<Layout> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Layout> {
  int selectedIndex = 0;
  List<Widget> screens = [
    TasksListView(),
    SettingsView(),
    // replace with your widget here  // Add your other screens here
  ];

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedIndex == 0
            ? 'To Do List ${authProvider.currentUser!.name}'
            : 'Settings'),
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        titleSpacing: MediaQuery.of(context).size.width * 0.04,
        actions: [
          IconButton(
              onPressed: () {
                authProvider.currentUser = null;
                listProvider.tasksList = [];
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.logout))
        ],
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
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}

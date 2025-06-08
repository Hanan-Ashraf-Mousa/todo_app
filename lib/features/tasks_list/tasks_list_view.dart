import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/tasks_list/task_item.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/list_provider.dart';

import '../../provider/auth_providers.dart';

class TasksListView extends StatelessWidget {
  static const String routeName = "tasks list";

  TasksListView({super.key});

  @override
  Widget build(BuildContext context) {
    var providerList = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    if (providerList.tasksList.isEmpty) {
      providerList.refreshList(authProvider.currentUser!.id!);
    }
    return Column(
      children: [
        CalendarTimeline(
          initialDate: providerList.selectedDate,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365 * 2)),
          onDateSelected: (date) {
            providerList.changeSelectedDate(
                date, authProvider.currentUser!.id!);
          },
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: MyTheme.blackColor,
          activeDayColor: MyTheme.whiteColor,
          activeBackgroundDayColor: MyTheme.primaryColor,
          dotColor: MyTheme.whiteColor,
          locale: 'en',
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => TaskItem(
            task: providerList.tasksList[index],
          ),
          itemCount: providerList.tasksList.length,
        ))
      ],
    );
  }
}

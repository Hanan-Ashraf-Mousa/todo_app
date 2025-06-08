import 'package:flutter/material.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  var selectedDate = DateTime.now();
  Task task = Task(
      title: 'title', description: 'description', dateTime: DateTime.now());

  void refreshList(String uId) async {
    tasksList = await FirebaseUtils.getAllTasks(uId);

    // filer tasks
    tasksList = tasksList.where((task) {
      if (task.dateTime?.day == selectedDate.day &&
          task.dateTime?.month == selectedDate.month &&
          task.dateTime?.year == selectedDate.year) {
        return true;
      }
      return false;
    }).toList();
    // sort data
    tasksList.sort((task1, task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });
    notifyListeners();
  }

  changeSelectedDate(DateTime date, String uId) {
    selectedDate = date;
    refreshList(uId);
  }

  changeTask(Task taskUpdated, String uId) {
    task = taskUpdated;
    refreshList(uId);
  }
}

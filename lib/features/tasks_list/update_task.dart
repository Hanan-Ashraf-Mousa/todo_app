import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

import '../../provider/auth_providers.dart';

class UpdateTask extends StatefulWidget {
  Task task;

  UpdateTask({super.key, required this.task});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final GlobalKey<FormState> _key = GlobalKey();

  DateFormat formatDate = DateFormat('dd/MM/yyyy');
  DateTime selectedDate = DateTime.now();
  late TextEditingController titleController;

  late TextEditingController descriptionController;

  late var providerList;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedDate = widget.task.dateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    providerList = Provider.of<ListProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        toolbarHeight: size.height * 0.2,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.03, horizontal: size.width * 0.04),
        margin: EdgeInsets.symmetric(
            vertical: size.height * 0.12, horizontal: size.width * 0.1),
        width: size.width * 0.8,
        height: size.height * 0.6,
        decoration: BoxDecoration(
          color: themeProvider.currentTheme == ThemeMode.light
              ? MyTheme.whiteColor
              : MyTheme.blackColorDark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              'Edit Task',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: themeProvider.currentTheme == ThemeMode.light
                      ? MyTheme.blackColor
                      : MyTheme.whiteColor),
            ),
            Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: titleController,
                      style: TextStyle(
                          color: themeProvider.currentTheme == ThemeMode.light
                              ? MyTheme.blackColor
                              : MyTheme.whiteColor),
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                color: themeProvider.currentTheme ==
                                        ThemeMode.light
                                    ? MyTheme.blackColor
                                    : MyTheme.whiteColor,
                                fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      style: TextStyle(
                          color: themeProvider.currentTheme == ThemeMode.light
                              ? MyTheme.blackColor
                              : MyTheme.whiteColor),
                      decoration: InputDecoration(
                        labelText: 'Task description',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                color: themeProvider.currentTheme ==
                                        ThemeMode.light
                                    ? MyTheme.blackColor
                                    : MyTheme.whiteColor,
                                fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Select Time',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: themeProvider.currentTheme == ThemeMode.light
                              ? MyTheme.blackColor
                              : MyTheme.whiteColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: () {
                          showCalender();
                        },
                        child: Text(
                          formatDate
                              .format(widget.task.dateTime ?? DateTime.now()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  themeProvider.currentTheme == ThemeMode.light
                                      ? MyTheme.blackColor
                                      : MyTheme.whiteColor),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            var taskEdited = Task(
                                title: titleController.text,
                                description: descriptionController.text,
                                dateTime: selectedDate);
                            updateTask(
                                taskEdited, authProvider.currentUser!.id!);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'save changes',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: themeProvider.currentTheme ==
                                          ThemeMode.light
                                      ? MyTheme.blackColor
                                      : MyTheme.whiteColor),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void showCalender() async {
    selectedDate = (await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))))!;
  }

  void updateTask(Task task, String uid) async {
    print('${task.title}  ${task.description} ${task.dateTime}');
    var taskUpdated = Task(
        id: widget.task.id,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: selectedDate);
    await FirebaseUtils.updateTask(taskUpdated, uid);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Task updated successfully')));
    }

    providerList.changeTask(task, uid);
  }
}

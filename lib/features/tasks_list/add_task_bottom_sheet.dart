import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/auth_providers.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

import '../../my_theme.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var date = DateTime.now();
  DateFormat formatDate = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
            color: themeProvider.currentTheme == ThemeMode.light
                ? MyTheme.whiteColor
                : MyTheme.blackColorDark,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Add new Task',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: themeProvider.currentTheme == ThemeMode.light
                            ? MyTheme.blackColor
                            : MyTheme.whiteColor),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return 'Task title must not be empty';
                  },
                  decoration: InputDecoration(
                    hintText: 'enter your  task title',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: themeProvider.currentTheme == ThemeMode.light
                                ? MyTheme.greyColor
                                : MyTheme.whiteColor),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return 'Task description must not be empty';
                  },
                  decoration: InputDecoration(
                    hintText: 'enter your task description',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: themeProvider.currentTheme == ThemeMode.light
                                ? MyTheme.greyColor
                                : MyTheme.whiteColor),
                  ),
                  maxLines: 3,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Select Date',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: themeProvider.currentTheme == ThemeMode.light
                          ? MyTheme.blackColor
                          : MyTheme.whiteColor),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    showCalender();
                  },
                  child: Text(
                    formatDate.format(date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: themeProvider.currentTheme == ThemeMode.light
                            ? MyTheme.blackColor
                            : MyTheme.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void showCalender() async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (selectedDate != null) {
      date = selectedDate;
    }
    setState(() {});
  }

  Future<void> addTask() async {
    if (formKey.currentState!.validate()) {
      // add task to database.
      Task task = Task(
          title: titleController.text,
          description: descriptionController.text,
          dateTime: date);

      var authProvider = Provider.of<AuthProviders>(context, listen: false);

      await FirebaseUtils.addTaskToFireStore(
          task, authProvider.currentUser!.id!);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Task added successfully')));
      }
      var providerList = Provider.of<ListProvider>(context, listen: false);
      //  refresh list
      providerList.refreshList(authProvider.currentUser!.id!);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

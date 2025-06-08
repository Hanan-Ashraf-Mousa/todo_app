import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/tasks_list/update_task.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/list_provider.dart';

import '../../provider/auth_providers.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    var providerList = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UpdateTask(task: task)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  FirebaseUtils.deleteTaskFromFireStore(
                          task, authProvider.currentUser!.id!)
                      .timeout(Duration(milliseconds: 200), onTimeout: () {
                    debugPrint('Task deleted Successfully');
                  });
                  providerList.refreshList(authProvider.currentUser!.id!);
                },
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                backgroundColor: MyTheme.redColor,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: MyTheme.whiteColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: task.isDone ?? false
                        ? MyTheme.greenColor
                        : MyTheme.primaryColor,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(task.title ?? '',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: task.isDone ?? false
                                        ? MyTheme.greenColor
                                        : MyTheme.primaryColor,
                                  )),
                      Text(task.description ?? '',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                task.isDone ?? false
                    ? Text(
                        'Done!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: MyTheme.greenColor,
                                ),
                      )
                    : InkWell(
                        onTap: () {
                          task.isDone = true;
                          FirebaseUtils.updateTask(
                              Task(
                                  title: task.title,
                                  description: task.description,
                                  dateTime: task.dateTime,
                                  isDone: true),
                              authProvider.currentUser!.id!);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: MyTheme.primaryColor,
                            ),
                            child: Icon(
                              Icons.check,
                              color: MyTheme.whiteColor,
                              size: 35,
                            )),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

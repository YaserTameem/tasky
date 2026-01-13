import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../model/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool isLoading = false;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });
    final finalTask = PreferencesManager().getString('tasks');

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      setState(() {
        tasks =
            taskAfterDecode
                .map((e) => TaskModel.fromJson(e))
                .where((element) => element.isDone == false)
                .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  _deleteTasks(int? id) async {
    List<TaskModel> task = [];
    if (id == null) return;
    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      task = taskAfterDecode.map((e) => TaskModel.fromJson(e)).toList();
      task.removeWhere((element) => element.id == id);

      setState(() {
        tasks.removeWhere((e) => e.id == id);
      });
      final updateTask = task.map((e) => e.toMap()).toList();
      await PreferencesManager().setString('tasks', jsonEncode(updateTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "To Do Tasks",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isLoading
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                    : TaskListWidget(
                      onEdit: () {
                        _loadTask();
                      },
                      tasks: tasks,
                      onTap: (value, index) async {
                        setState(() {
                          tasks[index!].isDone = value ?? false;
                        });
                        final allData = PreferencesManager().getString('tasks');
                        if (allData != null) {
                          final List<TaskModel> allDataList =
                              (jsonDecode(allData) as List)
                                  .map((e) => TaskModel.fromJson(e))
                                  .toList();
                          final newIndex = allDataList.indexWhere(
                            (element) => element.id == tasks[index!].id,
                          );
                          allDataList[newIndex] = tasks[index!];
                          final encodedData =
                              allDataList.map((e) => e.toMap()).toList();
                          await PreferencesManager().setString(
                            'tasks',
                            jsonEncode(encodedData),
                          );
                          _loadTask();
                        }
                      },
                      onDelete: (int? id) {
                        _deleteTasks(id);
                      },
                    ),
          ),
        ),
      ],
    );
  }
}

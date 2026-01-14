import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/features/home/components/achieved_tasks_widget.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/add_task/add_task.dart';
import 'package:tasky/features/home/components/high_priority_tasks_widget.dart';
import 'package:tasky/features/home/components/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? userImage;
  bool isLoading = false;
  List<TaskModel> tasks = [];
  int totalTasks = 0;
  int doneTasks = 0;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
        tasks = taskAfterDecode.map((e) => TaskModel.fromJson(e)).toList();
        _calculatePercent();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  _calculatePercent() {
    totalTasks = tasks.length;
    doneTasks = tasks.where((e) => e.isDone == true).length;
    percent = totalTasks == 0 ? 0 : doneTasks / totalTasks;
  }

  void _loadUserName() async {
    setState(() {
      username = PreferencesManager().getString(StorageKey.username);
      userImage = PreferencesManager().getString("user_image");
    });
  }

  _doneTasks(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
    });
    final updateTask = tasks.map((e) => e.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updateTask));
    _calculatePercent();
  }

  _deleteTasks(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((e) => e.id == id);
      _calculatePercent();
    });
    final updateTask = tasks.map((e) => e.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updateTask));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            userImage == null
                                ? AssetImage("assets/images/person.png")
                                : FileImage(File(userImage!)),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "One task at a time.One step\ncloser.",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SvgPicture.asset("assets/images/waving_hand.svg"),
                    ],
                  ),
                  SizedBox(height: 24),
                  AchievedTasksWidget(
                    doneTasks: doneTasks,
                    percent: percent,
                    totalTasks: totalTasks,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    refresh: () {
                      _loadTask();
                    },
                    tasks: tasks,
                    onTap: (value, index) async {
                      _doneTasks(value, index);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 24),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
                : SliverTaskListWidget(
                  tasks: tasks,
                  onTap: (value, index) async {
                    _doneTasks(value, index);
                  },
                  onDelete: (int? id) {
                    _deleteTasks(id);
                  },
                  onEdit: () {
                    _loadTask();
                  },
                ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add New Task"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AddTask();
                },
              ),
            );
            if (result != null && result) {
              _loadTask();
            }
          },
        ),
      ),
    );
  }
}

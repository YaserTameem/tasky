import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_filed.dart';
import 'package:tasky/model/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey();

  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 8),
                      CustomTextFormFiled(
                        title: "Task Name",
                        controller: taskNameController,
                        hintText: "Finish UI design for login screen",
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Task Name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormFiled(
                        title: 'Task Description',
                        controller: taskDescriptionController,
                        hintText:
                            "Finish onboarding UI and hand off to\ndevs by Thursday.",
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "High Priority",
                            style: Theme.of(context).textTheme.titleMedium,

                          ),
                          Switch(
                            value: isHighPriority,
                            onChanged: (value) {
                              setState(() {
                                isHighPriority = value;
                              });
                            },
                            activeTrackColor: Color(0xFF15B86C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                onPressed: () async {
                  if (_key.currentState?.validate() ?? false) {
                    final taskJson = PreferencesManager().getString('tasks');
                    List<dynamic> listTask = [];
                    if (taskJson != null) {
                      listTask = jsonDecode(taskJson);
                    }
                    TaskModel model = TaskModel(
                      id: listTask.length + 1,
                      taskName: taskNameController.text,
                      taskDescription: taskDescriptionController.text,
                      isHighPriority: isHighPriority,
                    );

                    listTask.add(model.toMap());
                    final taskEncode = jsonEncode(listTask);
                   await PreferencesManager().setString('tasks', taskEncode);
                    Navigator.of(context).pop(true);
                  }
                },
                label: Text("Add Task"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

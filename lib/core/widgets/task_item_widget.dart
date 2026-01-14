import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/storage_key.dart';
import 'package:tasky/core/enums/task_item_actions_enum.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/core/widgets/custom_text_form_filed.dart';
import 'package:tasky/model/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChange,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(int id) onDelete;
  final Function onEdit;
  final Function(bool?) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              ThemeController.isDark() ? Colors.transparent : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (value) => onChange(value),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.taskName,
                  style:
                      model.isDone
                          ? Theme.of(context).textTheme.titleLarge
                          : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                  ),
              ],
            ),
          ), //S10,L2
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color:
                  ThemeController.isDark()
                      ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                      : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChange(!model.isDone);
                case TaskItemActionsEnum.delete:
                  await _showAlertDialog(context);
                case TaskItemActionsEnum.edit:
                  final result = await _showBottomSheet(context, model);
                  if (result == true) {
                    onEdit();
                  }
              }
            },
            itemBuilder:
                (context) =>
                    TaskItemActionsEnum.values.map((e) {
                      return PopupMenuItem<TaskItemActionsEnum>(
                        value: e,
                        child: Text(e.name),
                      );
                    }).toList(),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showBottomSheet(context, TaskModel model) {
    final GlobalKey<FormState> key = GlobalKey();
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setState,
          ) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    SizedBox(height: 30),
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
                    Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          final taskJson = PreferencesManager().getString(
                            StorageKey.tasks,
                          );
                          List<TaskModel>? listTask = [];
                          if (taskJson != null) {
                            final decoded = jsonDecode(taskJson) as List;
                            listTask =
                                decoded
                                    .map((e) => TaskModel.fromJson(e))
                                    .toList();
                          }
                          final index = listTask.indexWhere(
                            (element) => element.id == model.id,
                          );
                          if (index != -1) {
                            listTask[index] = TaskModel(
                              id: model.id,
                              taskName: taskNameController.text,
                              taskDescription: taskDescriptionController.text,
                              isHighPriority: isHighPriority,
                              isDone: model.isDone,
                            );
                          }

                          final taskEncode = jsonEncode(
                            listTask.map((e) => e.toMap()).toList(),
                          );
                          await PreferencesManager().setString(
                            StorageKey.tasks,
                            taskEncode,
                          );
                          Navigator.pop(context, true);
                        }
                      },
                      label: Text("Edit Task"),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _showAlertDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this Task!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

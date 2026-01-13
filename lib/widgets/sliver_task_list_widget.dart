import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/task_item_widget.dart';
import 'package:tasky/model/task_model.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete, required this.onEdit,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final Function(int?) onDelete;
  final Function onEdit;


  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 80),
      sliver: SliverList.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            onEdit:()=> onEdit(),
            model: tasks[index],
            onChange: (value) {
              onTap(value, index);
            },
            onDelete: (id) => onDelete(id),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
      ),
    );
  }
}

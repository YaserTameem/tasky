import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/tasks/high_priority_tasks_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.onTap,
    required this.tasks,
    required this.refresh,
  });

  final List<TaskModel> tasks;
  final Function(bool? value, int? index) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              ThemeController.isDark() ? Colors.transparent : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "High Priority Tasks",
                    style: TextStyle(fontSize: 14, color: Color(0xFF15B86C)),
                  ),
                ),
                ...tasks.reversed.where((e) => e.isHighPriority).take(4).map((
                  e,
                ) {
                  return Row(
                    children: [
                      CustomCheckBox(
                        value: e.isDone,
                        onChanged: (value) {
                          final int index = tasks.indexWhere(
                            (element) => e.id == element.id,
                          );
                          onTap(value, index);
                        },
                      ),
                      Expanded(
                        child: Text(
                          e.taskName,
                          style:
                              e.isDone
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HighPriorityTasksScreen(),
                ),
              );
              refresh();
            },
            child: Container(
              margin: EdgeInsets.all(16),
              height: 40,
              width: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      ThemeController.isDark()
                          ? Color(0xFF6E6E6E)
                          : Color(0xFFD1DAD6),
                ),
              ),
              child: SvgPicture.asset(
                "assets/images/arrow_up_right.svg",
                colorFilter: ColorFilter.mode(
                  ThemeController.isDark()
                      ? Color(0xFFC6C6C6)
                      : Color(0xFF3A4640),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

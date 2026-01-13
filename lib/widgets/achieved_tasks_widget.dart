import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tasky/core/theme/theme_controller.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    required this.totalTasks,
    required this.doneTasks,
    required this.percent,
  });

  final int totalTasks;

  final int doneTasks;

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
          ThemeController.isDark()?Colors.transparent:Color(0xFFD1DAD6)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Achieved Tasks",
                style: Theme.of(context).textTheme.titleMedium
              ),
              SizedBox(height: 4),
              Text(
                "$doneTasks Out of $totalTasks Done",
                  style: Theme.of(context).textTheme.titleSmall
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -math.pi / 2,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: percent,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF15B86C)),
                    backgroundColor: Color(0xFF6D6D6D),
                    strokeWidth: 4,
                  ),
                ),
              ),
              Text(
                "${(percent * 100).toInt()}%",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

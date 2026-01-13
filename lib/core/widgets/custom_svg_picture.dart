import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.withColorFilter = true,
  });

  const CustomSvgPicture.withColorFilter({super.key, required this.path})
    : withColorFilter = false;

  final String path;
  final bool withColorFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter:
          withColorFilter
              ? ColorFilter.mode(
                ThemeController.isDark()
                    ? Color(0xFFC6C6C6)
                    : Color(0xFF3A4640),
                BlendMode.srcIn,
              )
              : null,
    );
  }
}

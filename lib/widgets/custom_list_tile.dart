import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custom_svg_picture.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.leadingImage,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final String leadingImage;
  final String title;
  final Widget trailing;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CustomSvgPicture(path: leadingImage),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      trailing: trailing,
    );
  }
}

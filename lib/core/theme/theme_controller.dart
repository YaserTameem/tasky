import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier(
    ThemeMode.dark,
  );

  init() {
    bool result = PreferencesManager().getBool("theme") ?? true;
    notifier.value = result ? ThemeMode.dark : ThemeMode.light;
  }

  static toggle() async {
    if (notifier.value == ThemeMode.dark) {
      notifier.value = ThemeMode.light;
      await PreferencesManager().setBool("theme", false);
    } else {
      notifier.value = ThemeMode.dark;
      await PreferencesManager().setBool("theme", true);
    }
  }

static bool isDark() => notifier.value == ThemeMode.dark;
}

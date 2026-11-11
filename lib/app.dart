import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_labels.dart';
import 'screens/student_profile_screen.dart';
import 'theme/app_theme.dart';

class StudentProfileApp extends StatefulWidget {
  const StudentProfileApp({super.key, this.openUrl, this.preferences});

  final Future<bool> Function(Uri)? openUrl;

  /// Remembers the appearance choice. Without it the choice lasts one session.
  final SharedPreferences? preferences;

  @override
  State<StudentProfileApp> createState() => _StudentProfileAppState();
}

class _StudentProfileAppState extends State<StudentProfileApp> {
  static const _themeKey = 'themeMode';

  // An unknown or missing stored value falls back to System.
  late ThemeMode _themeMode =
      ThemeMode.values.asNameMap()[widget.preferences?.getString(_themeKey)] ??
      ThemeMode.system;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppLabels.appTitle,
    debugShowCheckedModeBanner: false,
    theme: AppStyle.theme(Brightness.light),
    darkTheme: AppStyle.theme(Brightness.dark),
    themeMode: _themeMode,
    themeAnimationDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppStyle.motion,
    home: StudentProfileScreen(
      onThemeChanged: (value) {
        setState(() => _themeMode = value);
        widget.preferences?.setString(_themeKey, value.name);
      },
      openUrl: widget.openUrl,
    ),
  );
}

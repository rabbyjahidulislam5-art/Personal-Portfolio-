import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'l10n/app_labels.dart';
import 'screens/student_profile_screen.dart';
import 'theme/app_theme.dart';

class StudentProfileApp extends StatefulWidget {
  const StudentProfileApp({super.key, this.imagePicker, this.openUrl});

  final ImagePicker? imagePicker;
  final Future<bool> Function(Uri)? openUrl;

  @override
  State<StudentProfileApp> createState() => _StudentProfileAppState();
}

class _StudentProfileAppState extends State<StudentProfileApp> {
  ThemeMode _themeMode = ThemeMode.system;

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
      themeMode: _themeMode,
      onThemeChanged: (value) => setState(() => _themeMode = value),
      imagePicker: widget.imagePicker,
      openUrl: widget.openUrl,
    ),
  );
}

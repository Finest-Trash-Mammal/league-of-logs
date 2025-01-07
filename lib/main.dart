import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  setWindowTitle('League of Logs');
  // setWindowMaxSize(const Size(1024, 768));
  // setWindowMinSize(const Size(800, 600));

  runApp(MyApp(settingsController: settingsController));
}

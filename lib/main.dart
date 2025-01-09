import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'src/core/constants.dart';
import 'src/app.dart';
import 'src/features/settings/presentation/settings_controller.dart';
import 'src/features/settings/domain/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  WidgetsFlutterBinding.ensureInitialized();

  setWindowTitle(appTitle);

  runApp(MyApp(settingsController: settingsController));
}

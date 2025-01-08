import 'package:flutter/material.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
        
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Save Name and Role'),
                  value: controller.saveNameAndRole, 
                  onChanged: (value) {
                    controller.toggleSaveNameAndRole(value);
                  }
                ),
                DropdownButton<ThemeMode>(
                  value: controller.themeMode,
                  onChanged: (themeMode) {
                    if (themeMode != null) {
                      controller.updateThemeMode(themeMode);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

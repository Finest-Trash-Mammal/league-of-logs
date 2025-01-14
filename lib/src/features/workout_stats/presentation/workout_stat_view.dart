import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summoners_lift/src/features/workout_generator/data/workout.dart';
import 'package:summoners_lift/src/features/workout_stats/data/exercise.dart';
import 'package:summoners_lift/src/core/data/database_helper.dart';
import 'package:summoners_lift/src/features/workout_stats/domain/workout_stat_service.dart';
import 'package:summoners_lift/src/features/workout_stats/presentation/workout_stat_linechart.dart';

import '../../../core/utils/constants.dart';
import '../../settings/presentation/settings_view.dart';

class WorkoutStatView extends StatefulWidget {
  static const routeName = '/stats';

  @override
  WorkoutStatViewState createState() => WorkoutStatViewState();
}


class WorkoutStatViewState extends State<WorkoutStatView> {
  late Future<List<Workout>> _workouts;
  late String _playerName;
  final workoutStatService = WorkoutStatService();
  
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('saveNameAndRole') ?? false) {
      _playerName = prefs.getString('savedName') ?? '';
    }

    setState(() {
      _workouts = DatabaseHelper.instance.getAllWorkoutsForPlayer(_playerName);
    });

    
    final workouts = await _workouts;
    final chartSpots = workoutStatService.getChartSpots(workouts);
  }

  @override
  void initState() {
    super.initState();
    _playerName = '';
    _loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts stats for $_playerName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode
              ? darkThemeBackgroundImage
              : lightThemeBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: WorkoutStatLinechart()
              ),
            ),
          ),
        ),
      ),
    );
  }
}
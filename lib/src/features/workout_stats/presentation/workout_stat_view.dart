import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summoners_lift/src/features/workout_generator/data/workout.dart';
import 'package:summoners_lift/src/features/workout_stats/data/exercise.dart';
import 'package:summoners_lift/src/core/data/database_helper.dart';

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
  
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('saveNameAndRole') ?? false) {
      _playerName = prefs.getString('savedName') ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _workouts = DatabaseHelper.instance.getWorkout(_playerName);
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
            constraints: const BoxConstraints(maxWidth: 325),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder(
                      future: _workouts, 
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No workouts found.'));
                        }

                        final workouts = snapshot.data!;

                        List<Exercise> exercises = [];

                        for (var workout in workouts) {
                          Exercise exercise = Exercise.fromJson(workout.exercise);
                          exercises.add(exercise);
                        }

                        final Map<String, int> exerciseTotals = {};

                        for (var exercise in exercises) {
                          if (exerciseTotals.containsKey(exercise.type)) {
                            exerciseTotals[exercise.type] = exerciseTotals[exercise.type]! + 1;
                          } else {
                            exerciseTotals[exercise.type] = 1;
                          }
                        }

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final exerciseType = exerciseTotals.keys.elementAt(index);
                            final totalCount = exerciseTotals[exerciseType]!;

                            return ListTile(
                              title: Text('$exerciseType'),
                              subtitle: Text('Total: $totalCount'),
                            );
                          }
                        );
                      })
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
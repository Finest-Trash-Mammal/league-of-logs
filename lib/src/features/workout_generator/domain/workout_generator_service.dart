import 'dart:convert';

import 'package:summoners_lift/src/core/utils/constants.dart';
import 'package:summoners_lift/src/features/workout_stats/data/exercise.dart';
import 'package:summoners_lift/src/features/workout_generator/data/player_stats.dart';
import 'package:summoners_lift/src/features/workout_generator/data/workout.dart';
import 'package:summoners_lift/src/core/data/database_helper.dart';

class WorkoutGeneratorService {
  static final WorkoutGeneratorService _instance = WorkoutGeneratorService._internal();
  static DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  factory WorkoutGeneratorService() {
    return _instance;
  }

  WorkoutGeneratorService._internal();

  Future<String> generateWorkout({
    required PlayerStats playerStats,
    required String fitnessLevel,
  }) async {
    final killParticipation = (playerStats.kills + playerStats.assists) / playerStats.teamKills * 100;

    final stats = [
      {'key': StatKeys.kills, 'exercise': ExerciseDescriptions.kills, 'value': playerStats.kills},
      {'key': StatKeys.deaths, 'exercise': ExerciseDescriptions.deaths, 'value': playerStats.deaths},
      {'key': StatKeys.assists, 'exercise': ExerciseDescriptions.assists, 'value': playerStats.assists},
      {'key': StatKeys.visionScore, 'exercise': ExerciseDescriptions.visionScore, 'value': playerStats.visionScore},
      {'key': StatKeys.creepScore, 'exercise': ExerciseDescriptions.creepScore, 'value': (playerStats.creepScore / playerStats.gameDuration).round()},
      {'key': StatKeys.killParticipation, 'exercise': ExerciseDescriptions.killParticipation, 'value': killParticipation},
    ];

    final weightings = roleWeighting;
    Map<String, int> adjustedWeighting = {};
    final weighting = weightings[playerStats.role] ?? defaultWeighting;
    weighting.forEach((key, value) {
      adjustedWeighting[key] = adjustWeighting(weighting, key, fitnessLevel).round();
    });

    final roleWorkouts = roleBasedHeadings;
    String workout = roleWorkouts[playerStats.role] ?? noRoleFound;
    final plankDuration = getPlankDuration(playerStats.isMVP, fitnessLevel);

    try {
      workout += playerStats.isMVP ? carriedMVP(plankDuration) : notCarriedMVP(plankDuration);
      
      Exercise plank = Exercise(type: 'Plank', sets: 0, reps: 0, seconds: Duration(seconds: plankDuration));
      List<String> exercises = [];
      exercises.add(plank.toJson());
      
      for (var stat in stats) {
        final key = stat['key'] as String;
      
        final sets = weighting[key]!;
        final adjustedSets = scaleValue(sets, fitnessLevel, false);
      
        final baseReps = ((stat['value']! as num) / (sets as num)).round();
        final adjustedReps = scaleValue(baseReps, fitnessLevel, true);
      
        final setText = sets == 1 ? 'set' : 'sets';
      
        workout += '\nDo $adjustedSets $setText of $adjustedReps ${stat['exercise'] as String}';
        
        Exercise exercise = Exercise(
          type: mapStatToExercise(key), 
          sets: adjustedSets, 
          reps: adjustedReps, 
          seconds: Duration(seconds: 0)
        );
        exercises.add(exercise.toJson());
      }
      
      Workout workoutJson = Workout(name: playerStats.name, exercise: jsonEncode(exercises));
      
      await _saveStatsAndWorkoutToDatabase(workoutJson, playerStats);
    } on Exception catch (e) {
      print(e);
    }

    final String result = workout;
    print(result);
    return result;
  }

  Future<void> _saveStatsAndWorkoutToDatabase(Workout workout, PlayerStats playerStats) async {
    await _databaseHelper.insertWorkout(workout);
    await _databaseHelper.insertPlayerStats(playerStats);
  }

  String mapStatToExercise(String key) {
    return exerciseMapping[key] ?? '';
  }

  double adjustWeighting(Map<String, int> weighting, String key, String fitnessLevel) {
    final adjustmentFactor = {
      FitnessLevels.beginner: key == 'vision' || key == 'killParticipation' ? 0.5 : 1,
      FitnessLevels.intermediate: 1,
      FitnessLevels.advanced: key == 'kills' || key == 'cs' || key == 'deaths' || key == "assists" ? 3 : 1,
    };

    return (weighting[key]?.toDouble() ?? 1) * (adjustmentFactor[fitnessLevel]?.toDouble() ?? 1);
  }

  int scaleValue(int value, String fitnessLevel, bool isReps) {
    final scalingFactors = {
      FitnessLevels.beginner: (int val) => isReps ? (val * 0.75).round() : val.ceil(),
      FitnessLevels.intermediate: (int val) => val + 1,
      FitnessLevels.advanced : (int val) => isReps ? (val * 2).round() : val + 2,
    };
    return scalingFactors[fitnessLevel]?.call(value) ?? value;
  }

  int getPlankDuration(bool isMVP, String fitnessLevel) {
    final plankDurations = {
      FitnessLevels.beginner: isMVP ? 15 : 20,
      FitnessLevels.intermediate: isMVP ? 30 : 40,
      FitnessLevels.advanced: isMVP ? 45 : 60,
    };
    
    return plankDurations[fitnessLevel] ?? 0;
  }
}
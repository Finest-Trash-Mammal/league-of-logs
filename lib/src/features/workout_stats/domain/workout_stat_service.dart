import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:summoners_lift/src/core/data/database_helper.dart';
import 'package:summoners_lift/src/features/workout_generator/data/workout.dart';
import 'package:summoners_lift/src/features/workout_stats/data/exercise.dart';
import 'package:summoners_lift/src/features/workout_stats/data/exercise_dto.dart';

class WorkoutStatService {
  static final WorkoutStatService _instance = WorkoutStatService._internal();
  static DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  factory WorkoutStatService() {
    return _instance;
  }

  WorkoutStatService._internal();

  Future<List<FlSpot>>? getChartSpots(List<Workout> workouts) {
    final List<ExerciseDTO> chartExercises = [];

    for (var workout in workouts) {
      final exerciseList = jsonDecode(workout.exercise);
      for (var exercise in exerciseList) {
        final chartExercise = ExerciseDTO(date: workout.submitDate, exercise: Exercise.fromJson(exercise));
        print('Date: ${chartExercise.date} Exercise Instance: ${jsonEncode(chartExercise.exercise)}');
        chartExercises.add(chartExercise);
      }
    }

    return null;
  }
}
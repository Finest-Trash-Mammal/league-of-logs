import 'package:summoners_lift/src/features/workout_stats/data/exercise.dart';

class ExerciseDTO {
  final DateTime date;
  final Exercise exercise;

  ExerciseDTO({
    required this.date,
    required this.exercise,
  });
}
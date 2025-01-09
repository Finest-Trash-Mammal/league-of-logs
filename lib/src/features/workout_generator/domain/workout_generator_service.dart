import 'package:league_of_logs/src/core/constants.dart';
import 'package:league_of_logs/src/features/workout_generator/data/player_stats_DTO.dart';

class WorkoutGeneratorService {
  String generateWorkout({
    required PlayerStatsDTO playerStats,
    required String fitnessLevel,
  }) {
    final killParticipation = (playerStats.kills + playerStats.assists) / playerStats.teamKills * 100;
    final roleWorkouts = roleBasedHeadings;
    final weightings = roleWeighting;

    String workout = roleWorkouts[playerStats.role] ?? noRoleFound;
    workout += adjustMVPWorkout(playerStats.isMVP, fitnessLevel);
    final weighting = weightings[playerStats.role] ?? defaultWeighting;
    Map<String, int> adjustedWeighting = {};

    weighting.forEach((key, value) {
      adjustedWeighting[key] = adjustWeighting(key, fitnessLevel).round();
    });

    final stats = [
      {'key': 'Kills', 'exercise': 'squats for each kill', 'value': playerStats.kills},
      {'key': 'Deaths', 'exercise': 'lunges for each assist', 'value': playerStats.deaths},
      {'key': 'Assists', 'exercise': 'burpees for each death', 'value': playerStats.assists},
      {'key': 'VisionScore', 'exercise': 'high knees for your vision score', 'value': playerStats.visionScore},
      {'key': 'CreepScore', 'exercise': 'sit-ups for your CS', 'value': (playerStats.creepScore / playerStats.gameDuration).round()},
      {'key': 'KillParticipation', 'exercise': 'jumping jacks for your kill participation', 'value': killParticipation},
    ];

    for (var stat in stats) {
      final key = stat['key'] as String;
      final sets = weighting[key]!;
      final baseReps = ((stat['value']! as num) / (sets as num)).round();
      final adjustedSets = scaleSets(sets, fitnessLevel);
      final adjustedReps = scaleReps(baseReps, fitnessLevel);

      final setText = sets == 1 ? 'set' : 'sets';

      workout += '\nDo $adjustedSets $setText of $adjustedReps ${stat['exercise']}';
    }

    print(workout);
    print(fitnessLevel);
    return workout;
  }

  double adjustWeighting(String key, String fitnessLevel) {
    Map<String, int> baseWeighting = defaultWeighting;

    double adjustmentFactor;
    switch (fitnessLevel) {
      case 'Beginner':
        adjustmentFactor = key == 'vision' || key == 'killParticipation' ? 0.5 : 1;
      case 'Intermediate':
        adjustmentFactor = 1;
      case 'Advanced':
        adjustmentFactor = key == 'kills' || key == 'cs' || key == 'deaths' || key == "assists" ? 3 : 1;
      default:
        adjustmentFactor = 1;
    }

    return baseWeighting[key]! * adjustmentFactor;
  }

  int scaleReps(int reps, String fitnessLevel) {
    switch (fitnessLevel) {
      case 'Beginner':
        return (reps * 0.75).round();
      case 'Intermediate':
        return reps + 1;
      case 'Advanced':
        return (reps * 2).round();
      default:
        return reps;
    }
  }

  int scaleSets(int sets, String fitnessLevel) {
    switch (fitnessLevel) {
      case 'Beginner':
        return sets.ceil();
      case 'Intermediate':
        return sets + 1;
      case 'Advanced':
        return sets + 2;
      default:
        return sets;
    }
  }

  String adjustMVPWorkout(bool isMVP, String fitnessLevel) {
    switch (fitnessLevel) {
      case 'Beginner':
        return isMVP 
        ? carriedMVP(15)
        : notCarriedMVP(20);
      case 'Intermediate':
        return isMVP 
        ? carriedMVP(30)
        : notCarriedMVP(40);
      case 'Advanced':
        return isMVP 
        ? carriedMVP(45)
        : notCarriedMVP(60);
      default:
        return '\nYou carried that game!';
    }
  }
}
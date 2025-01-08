import 'package:league_of_logs/src/workout_generator/player_stats.dart';
import 'package:league_of_logs/src/utils/constants.dart';

class WorkoutGeneratorService {
  String generateWorkout({
    required PlayerStats playerStats,
  }) {
    final killParticipation = (playerStats.kills + playerStats.assists) / playerStats.teamKills * 100;

    final roleWorkouts = roleBasedHeadings;

    final weightings = roleWeighting;

    String workout = roleWorkouts[playerStats.role] ?? noRoleFound;
    final weighting = weightings[playerStats.role] ?? defaultWeighting;

    final stats = [
      {'key': 'Kills', 'exercise': 'squats for each kill', 'value': playerStats.kills},
      {'key': 'Deaths', 'exercise': 'lunges for each assist', 'value': playerStats.deaths},
      {'key': 'Assists', 'exercise': 'burpees for each death', 'value': playerStats.assists},
      {'key': 'VisionScore', 'exercise': 'high knees for your vision score', 'value': playerStats.visionScore},
      {'key': 'CreepScore', 'exercise': 'sit-ups for your CS', 'value': (playerStats.creepScore / playerStats.gameDuration).round()},
      {'key': 'KillParticipation', 'exercise': 'jumping jacks for your kill participation', 'value': killParticipation},
    ];

    if (playerStats.isMVP) {
      workout += '\nYou carried that game, do a plank for 60 seconds!';
    } else {
      workout += '\nYou didn''t carry that game, do a plank until failure!';
    }

    for (var stat in stats) {
      final sets = weighting[stat['key']]!;
      final reps = ((stat['value']! as num) / (sets as num)).round();
      final setText = sets == 1 ? 'set' : 'sets';

      workout += '\nDo $sets $setText of $reps ${stat['exercise']}';
    }

    print(workout);
    return workout;
  }
}
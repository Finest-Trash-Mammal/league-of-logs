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
      {'key': 'CreepScore', 'exercise': 'sit-ups for your CS', 'value': playerStats.creepScore},
      {'key': 'KillParticipation', 'exercise': 'jumping jacks for your kill participation', 'value': killParticipation},
    ];

    for (var stat in stats) {
      workout += '\nDo ${weighting[stat['key']]!} sets of ${((stat['value']! as num) / (weighting[stat['key']]! as num)).round()} ${stat['exercise']}';
    }

    return workout;
  }
}
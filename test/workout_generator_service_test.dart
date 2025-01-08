import 'package:flutter_test/flutter_test.dart';
import 'package:league_of_logs/src/workout_generator/player_stats.dart';
import 'package:league_of_logs/src/workout_generator/workout_generator_service.dart';

void main() {
  group('WorkoutGeneratorService', () {
    final service = WorkoutGeneratorService();

    test('generates workout correctly for single stat', () {
      // Arrange
      final PlayerStats stats = PlayerStats(
        name: 'Fwomp',
        role: 'Support',
        isMVP: false,
        kills: 4,
        deaths: 5,
        assists: 24,
        teamKills: 56,
        creepScore: 31,
        visionScore: 84,
        gameDuration: 38,
      );

      // Act
      final result = service.generateWorkout(playerStats: stats);

      // Assert
      expect(result, 'Lets see just how much weight you can support!\n\nYou didnt carry that game, do a plank until failure!\nDo 1 set of 4 squats for each kill\nDo 2 sets of 3 lunges for each assist\nDo 3 sets of 8 burpees for each death\nDo 3 sets of 28 high knees for your vision score\nDo 1 set of 1 sit-ups for your CS\nDo 2 sets of 25 jumping jacks for your kill participation');
    });
  });
}

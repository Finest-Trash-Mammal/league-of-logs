class Workout {
  final int id;
  final String playerName;
  final String role;
  final bool isMVP;
  final int kills;
  final int deaths;
  final int assists;
  final int teamKills;
  final int creepScore;
  final int visionScore;
  final int gameDuration;
  final String generatedWorkout;

  Workout({
    required this.id,
    required this.playerName,
    required this.role,
    required this.isMVP,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.teamKills,
    required this.creepScore,
    required this.visionScore,
    required this.gameDuration,
    required this.generatedWorkout,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'role': role,
      'isMVP': isMVP ? 1 : 0, 
      'kills': kills,
      'deaths': deaths,
      'assists': assists,
      'teamKills': teamKills,
      'creepScore': creepScore,
      'visionScore': visionScore,
      'gameDuration': gameDuration,
      'generatedWorkout': generatedWorkout,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      playerName: map['playerName'],
      role: map['role'],
      isMVP: map['isMVP'] == 1,
      kills: map['kills'],
      deaths: map['deaths'],
      assists: map['assists'],
      teamKills: map['teamKills'],
      creepScore: map['creepScore'],
      visionScore: map['visionScore'],
      gameDuration: map['gameDuration'],
      generatedWorkout: map['generatedWorkout'],
    );
  }
}

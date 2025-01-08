class PlayerStats {
  final String name;
  final String role;
  final bool isMVP;
  final int kills;
  final int deaths;
  final int assists;
  final int teamKills;
  final int creepScore;
  final int visionScore;
  final int gameDuration;

  PlayerStats({
    required this.name,
    required this.role,
    required this.isMVP,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.teamKills,
    required this.creepScore,
    required this.visionScore,
    required this.gameDuration,
  });

  @override
  String toString() {
    return 'PlayerStats(name: $name, role: $role, isMVP: $isMVP, kills: $kills, deaths: $deaths, assists: $assists, teamKills: $teamKills, creepScore: $creepScore, visionScore: $visionScore, gameDuration: $gameDuration)';
  }
}
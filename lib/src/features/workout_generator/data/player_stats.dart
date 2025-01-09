class PlayerStats {
  final int id;
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
    required this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'isMVP': isMVP ? 1 : 0,
      'kills': kills,
      'deaths': deaths,
      'assists': assists,
      'teamKills': teamKills,
      'creepScore': creepScore,
      'visionScore': visionScore,
      'gameDuration': gameDuration,
    };
  }

  factory PlayerStats.fromMap(Map<String, dynamic> map) {
    return PlayerStats(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      isMVP: map['isMVP'] == 1,
      kills: map['kills'],
      deaths: map['deaths'],
      assists: map['assists'],
      teamKills: map['teamKills'],
      creepScore: map['creepScore'],
      visionScore: map['visionScore'],
      gameDuration: map['gameDuration'],
    );
  }

  @override
  String toString() {
    return 'PlayerStats(name: $name, role: $role, isMVP: $isMVP, kills: $kills, deaths: $deaths, assists: $assists, teamKills: $teamKills, creepScore: $creepScore, visionScore: $visionScore, gameDuration: $gameDuration)';
  }
}
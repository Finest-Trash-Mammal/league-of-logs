// ========================== Theme Constants ==========================
// ignore_for_file: constant_identifier_names

const String darkThemeBackgroundImage = 'assets/images/Rengar_1.jpg';
const String lightThemeBackgroundImage = 'assets/images/Ekko_11.jpg';
const String appTitle = 'Summoners Lift';

// ========================== String Constants ==========================
const Map<String, String> roleBasedHeadings = {
  'ADC': 'Let''s see just how much you can carry!\n',
  'Support': 'Let''s see just how much weight you can support!\n',
  'Middle': 'Let''s see just how agile you can be!\n',
  'Jungle': 'Here comes some real guerrilla warfare training!\n',
  'Top': 'Let''s see if you''re a real brawler!\n',
};
const String noRoleFound = 'Oh no, something went wrong! I don''t know which role you are';
String carriedMVP(seconds) {return '\nYou carried that game, do a plank for $seconds seconds!';} 
String notCarriedMVP(seconds) {return '\nYou didn\'t carry that game, do a plank for $seconds seconds!';} 
const String disclaimer = 'This application is not endorsed by Riot Games and does not reflect the views or opinions of Riot Games or anyone officially involved in producing or managing League of Legends. League of Legends and Riot Games are trademarks or registered trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.';
const exerciseMapping = {
  'Kills': 'squats',
  'Deaths': 'lunges',
  'Assists': 'burpees',
  'VisionScore': 'high knees',
  'CreepScore': 'sit-ups',
  'KillParticipation': 'jumping jacks',
};
class StatKeys {
  static const String kills = 'Kills';
  static const String deaths = 'Deaths';
  static const String assists = 'Assists';
  static const String visionScore = 'VisionScore';
  static const String creepScore = 'CreepScore';
  static const String killParticipation = 'KillParticipation';
}
class ExerciseDescriptions {
  static const String kills = 'squats for each kill';
  static const String deaths = 'lunges for each assist';
  static const String assists = 'burpees for each death';
  static const String visionScore = 'high knees for your vision score';
  static const String creepScore = 'sit-ups for your CS';
  static const String killParticipation = 'jumping jacks for your kill participation';
}
class FitnessLevels {
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';
}
class Roles {
  static const String ADC = 'ADC';
  static const String support = 'Support';
  static const String middle = 'Middle';
  static const String top = 'Top';
  static const String jungle = 'Jungle';
}

// ========================== Number Constants ==========================
const Map<String, Map<String, int>> roleWeighting = {
  'ADC' : {
    'Kills': 3,
    'Deaths': 2,
    'Assists': 1,
    'VisionScore': 1,
    'CreepScore': 1,
    'KillParticipation': 3,
  },
  'Support' : {
    'Kills': 1,
    'Deaths': 2,
    'Assists': 3,
    'VisionScore': 3,
    'CreepScore': 1,
    'KillParticipation': 3,
  },
  'Middle' : {
    'Kills': 2,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 1,
    'CreepScore': 3,
    'KillParticipation': 3,
  },
  'Jungle' : {
    'Kills': 1,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 3,
    'CreepScore': 2,
    'KillParticipation': 1,
  },
  'Top' : {
    'Kills': 3,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 1,
    'CreepScore': 2,
    'KillParticipation': 3,
  },
};
const Map<String, int> defaultWeighting = {
  'Kills': 1,
  'Deaths': 1,
  'Assists': 1,
  'VisionScore': 2,
  'CreepScore': 1,
  'KillParticipation': 3,
};
// ========================== Test String Constants ==========================
// TODO
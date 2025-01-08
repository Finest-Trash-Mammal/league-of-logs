// ========================== Theme Constants ==========================
const String darkThemeBackgroundImage = 'assets/images/Rengar_1.jpg';
const String lightThemeBackgroundImage = 'assets/images/Thresh_14.jpg';

// ========================== String Constants ==========================
const Map<String, String> roleBasedHeadings = {
  'ADC': 'Let''s see just how much you can carry!\n',
  'Support': 'Let''s see just how much weight you can support!\n',
  'Middle': 'Let''s see just how agile you can be!\n',
  'Jungle': 'Here comes some real guerrilla warfare training!\n',
  'Top': 'Let''s see if you''re a real brawler!\n',
};
const String noRoleFound = 'Oh no, something went wrong! I don''t know which role you are';
// ========================== Number Constants ==========================
const Map<String, Map<String, int>> roleWeighting = {
  'ADC' : {
    'Kills': 3,
    'Deaths': 2,
    'Assists': 1,
    'VisionScore': 1,
    'CreepScore': 1,
    'KillParticipation': 2,
  },
  'Support' : {
    'Kills': 1,
    'Deaths': 2,
    'Assists': 3,
    'VisionScore': 3,
    'CreepScore': 1,
    'KillParticipation': 2,
  },
  'Middle' : {
    'Kills': 2,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 1,
    'CreepScore': 3,
    'KillParticipation': 2,
  },
  'Jungle' : {
    'Kills': 1,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 3,
    'CreepScore': 2,
    'KillParticipation': 3,
  },
  'Top' : {
    'Kills': 3,
    'Deaths': 2,
    'Assists': 2,
    'VisionScore': 1,
    'CreepScore': 2,
    'KillParticipation': 2,
  },
};
const Map<String, int> defaultWeighting = {
  'Kills': 2,
  'Deaths': 2,
  'Assists': 2,
  'VisionScore': 2,
  'CreepScore': 2,
  'KillParticipation': 2,
};
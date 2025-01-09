// ========================== Theme Constants ==========================
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
const String testAdvancedFitnessADC = 'Lets see just how much you can carry!\n\nYou carried that game, do a plank for 45 seconds!\nDo 3 sets of 6 squats for each kill\nDo 2 sets of 4 lunges for each assist\nDo 1 set of 10 burpees for each death\nDo 1 set of 19 high knees for your vision score\nDo 1 set of 6 sit-ups for your CS\nDo 2 sets of 31 jumping jacks for your kill participation';
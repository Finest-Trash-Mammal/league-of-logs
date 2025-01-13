import 'dart:convert';

class Exercise {
  final String type;
  final int sets;
  final int reps;
  final Duration seconds;

  Exercise({
    required this.type,
    required this.sets,
    required this.reps,
    required this.seconds,
  });

  String toJson() {
    return jsonEncode({
      'type': type,
      'sets': sets,
      'reps': reps,
      'seconds': seconds.inSeconds,
    });
  }

  factory Exercise.fromJson(Map<String, dynamic> jsonMap) {
    return Exercise(
      type: jsonMap['type'],
      sets: jsonMap['sets'],
      reps: jsonMap['reps'],
      seconds: Duration(seconds: jsonMap['seconds']),
    );
  }

  static List<Exercise> fromJsonList(String jsonStr) {
    List<dynamic> jsonList = jsonDecode(jsonStr) ?? '';
    List<Exercise> exercises = [];
    for (var jsonObj in jsonList) {
      jsonObj = jsonDecode(jsonObj);
      Exercise exercise = Exercise(type: jsonObj['type'], sets: jsonObj['sets'], reps: jsonObj['reps'], seconds: Duration(seconds: jsonObj['seconds']));
      exercises.add(exercise);
    }
    return exercises;
  }
}
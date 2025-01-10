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

  factory Exercise.fromJson(String jsonStr) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return Exercise(
      type: jsonMap['type'],
      sets: jsonMap['sets'],
      reps: jsonMap['reps'],
      seconds: Duration(seconds: jsonMap['seconds']),
    );
  }
}
class Workout {
  final int? id;
  final String name;
  final String exercise;
  final DateTime submitDate;

  Workout({
    this.id,
    required this.name,
    required this.exercise,
    required this.submitDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercise' : exercise,
      'submitDate' : submitDate.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      exercise: map['exercise'],
      submitDate: DateTime.parse(map['submitDate']),
    );
  }
}
class Workout {
  final int? id;
  final String name;
  final String exercise;

  Workout({
    this.id,
    required this.name,
    required this.exercise,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercise' : exercise, 
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      exercise: map['exercise'],
    );
  }
}
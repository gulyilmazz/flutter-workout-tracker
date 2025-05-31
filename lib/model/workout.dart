class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final DateTime timestamp;
  final int restSeconds; // Setler arası dinlenme süresi

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.timestamp,
    this.restSeconds = 60, // Varsayılan 60 saniye
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'timestamp': timestamp.toIso8601String(),
      'restSeconds': restSeconds,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      restSeconds: json['restSeconds'] ?? 60,
    );
  }
}

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final List<Exercise> exercises;
  final Duration duration;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exercises,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'duration': duration.inMinutes,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
      duration: Duration(minutes: json['duration']),
    );
  }
}

class WorkoutTemplate {
  final String id;
  final String name;
  final List<Exercise> exercises;

  WorkoutTemplate({
    required this.id,
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    return WorkoutTemplate(
      id: json['id'],
      name: json['name'],
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_workout_tracker/model/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Exercise> _currentExercises = [];
  List<WorkoutTemplate> _templates = [];
  bool _isWorkoutActive = false;
  DateTime? _workoutStartTime;
  String _currentWorkoutName = '';
  bool _isLoading = false;
  int _streak = 0;
  DateTime? _lastWorkoutDate;
  RecoverySuggestion? _recoverySuggestion;

  List<Workout> get workouts => [..._workouts];
  List<Exercise> get currentExercises => [..._currentExercises];
  List<WorkoutTemplate> get templates => [..._templates];
  bool get isWorkoutActive => _isWorkoutActive;
  String get currentWorkoutName => _currentWorkoutName;
  bool get isLoading => _isLoading;
  int get streak => _streak;
  RecoverySuggestion? get recoverySuggestion => _recoverySuggestion;

  Duration get currentWorkoutDuration {
    if (_workoutStartTime == null) return Duration.zero;
    return DateTime.now().difference(_workoutStartTime!);
  }

  int get totalWorkouts => _workouts.length;
  int get totalExercises =>
      _workouts.expand((workout) => workout.exercises).length;
  Duration get totalWorkoutTime => _workouts
      .map((w) => w.duration)
      .fold(Duration.zero, (prev, duration) => prev + duration);
  List<Workout> get thisWeekWorkouts {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _workouts.where((w) => w.date.isAfter(weekStart)).toList();
  }

  WorkoutProvider() {
    loadWorkouts();
    loadTemplates();
    loadStreak();
  }

  void startWorkout(String name, {WorkoutTemplate? template}) {
    _currentWorkoutName = name;
    _isWorkoutActive = true;
    _workoutStartTime = DateTime.now();
    _currentExercises.clear();
    if (template != null) {
      _currentExercises.addAll(template.exercises);
    }
    updateStreak();
    notifyListeners();
  }

  void addExercise(
    String name,
    int sets,
    int reps,
    double weight, {
    int restSeconds = 60,
  }) {
    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      sets: sets,
      reps: reps,
      weight: weight,
      timestamp: DateTime.now(),
      restSeconds: restSeconds,
    );
    _currentExercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(String exerciseId) {
    _currentExercises.removeWhere((ex) => ex.id == exerciseId);
    notifyListeners();
  }

  void finishWorkout({bool saveAsTemplate = false}) {
    if (!_isWorkoutActive || _currentExercises.isEmpty) return;

    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _currentWorkoutName,
      date: DateTime.now(),
      exercises: [..._currentExercises],
      duration: currentWorkoutDuration,
    );

    _workouts.insert(0, workout);

    if (saveAsTemplate) {
      final template = WorkoutTemplate(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _currentWorkoutName,
        exercises: [..._currentExercises],
      );
      _templates.add(template);
      saveTemplates();
    }

    _recoverySuggestion = RecoverySuggestion(
      title: "Antrenmandan Sonra İyileşme",
      description:
          "Kaslarını onarmak ve enerji depolarını yenilemek için aşağıdaki önerilere göz at!",
      foodItems: [
        "Protein Shake: 1 ölçek whey protein, 1 muz, 1 yemek kaşığı fıstık ezmesi",
        "Yemek: 150g ızgara tavuk, 100g tatlı patates, bir avuç ıspanak",
        "Atıştırmalık: 200g Yunan yoğurdu, 1 avuç yaban mersini, 1 tatlı kaşığı bal",
      ],
      drinkItems: [
        "Su: 500-750 ml",
        "Hindistancevizi suyu: Elektrolit dengesi için",
        "Yeşil Çay: Antioksidan etkisiyle iyileşmeyi destekler",
      ],
    );

    _isWorkoutActive = false;
    _workoutStartTime = null;
    _currentWorkoutName = '';
    _currentExercises.clear();

    saveWorkouts();
    notifyListeners();
  }

  void cancelWorkout() {
    _isWorkoutActive = false;
    _workoutStartTime = null;
    _currentWorkoutName = '';
    _currentExercises.clear();
    notifyListeners();
  }

  void deleteWorkout(String workoutId) {
    _workouts.removeWhere((w) => w.id == workoutId);
    saveWorkouts();
    notifyListeners();
  }

  void addTemplate(String name, List<Exercise> exercises) {
    final template = WorkoutTemplate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      exercises: exercises,
    );
    _templates.add(template);
    saveTemplates();
    notifyListeners();
  }

  void deleteTemplate(String templateId) {
    _templates.removeWhere((t) => t.id == templateId);
    saveTemplates();
    notifyListeners();
  }

  void updateStreak() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastWorkout =
        _lastWorkoutDate != null
            ? DateTime(
              _lastWorkoutDate!.year,
              _lastWorkoutDate!.month,
              _lastWorkoutDate!.day,
            )
            : null;

    if (lastWorkout == null) {
      _streak = 1;
    } else if (todayDate.difference(lastWorkout).inDays == 1) {
      _streak++;
    } else if (todayDate.difference(lastWorkout).inDays > 1) {
      _streak = 1;
    } else {
      _streak = _streak;
    }

    _lastWorkoutDate = today;
    saveStreak();
    notifyListeners();
  }

  Future<void> saveWorkouts() async {
    try {
      _isLoading = true;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = _workouts.map((w) => w.toJson()).toList();
      await prefs.setString('workouts', jsonEncode(workoutsJson));
    } catch (e) {
      print('Error saving workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWorkouts() async {
    try {
      _isLoading = true;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final workoutsString = prefs.getString('workouts');
      if (workoutsString != null) {
        final workoutsJson = jsonDecode(workoutsString) as List;
        _workouts = workoutsJson.map((json) => Workout.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading workouts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = _templates.map((t) => t.toJson()).toList();
      await prefs.setString('templates', jsonEncode(templatesJson));
    } catch (e) {
      print('Error saving templates: $e');
    }
  }

  Future<void> loadTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesString = prefs.getString('templates');
      if (templatesString != null) {
        final templatesJson = jsonDecode(templatesString) as List;
        _templates =
            templatesJson
                .map((json) => WorkoutTemplate.fromJson(json))
                .toList();
      }
    } catch (e) {
      print('Error loading templates: $e');
    }
  }

  Future<void> saveStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('streak', _streak);
      if (_lastWorkoutDate != null) {
        await prefs.setString(
          'lastWorkoutDate',
          _lastWorkoutDate!.toIso8601String(),
        );
      }
    } catch (e) {
      print('Error saving streak: $e');
    }
  }

  Future<void> loadStreak() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _streak = prefs.getInt('streak') ?? 0;
      final lastWorkoutString = prefs.getString('lastWorkoutDate');
      if (lastWorkoutString != null) {
        _lastWorkoutDate = DateTime.parse(lastWorkoutString);
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final lastWorkoutDate = DateTime(
          _lastWorkoutDate!.year,
          _lastWorkoutDate!.month,
          _lastWorkoutDate!.day,
        );
        if (todayDate.difference(lastWorkoutDate).inDays > 1) {
          _streak = 0;
          saveStreak();
        }
      }
    } catch (e) {
      print('Error loading streak: $e');
    }
  }

  void clearRecoverySuggestion() {
    _recoverySuggestion = null;
    notifyListeners();
  }
}

class RecoverySuggestion {
  final String title;
  final String description;
  final List<String> foodItems;
  final List<String> drinkItems;

  RecoverySuggestion({
    required this.title,
    required this.description,
    required this.foodItems,
    required this.drinkItems,
  });
}

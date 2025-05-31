import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_workout_tracker/model/workout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Exercise> _currentExercises = [];
  bool _isWorkoutActive = false;
  DateTime? _workoutStartTime;
  String _currentWorkoutName = '';
  bool _isLoading = false;

  // Getters
  List<Workout> get workouts => [..._workouts];
  List<Exercise> get currentExercises => [..._currentExercises];
  bool get isWorkoutActive => _isWorkoutActive;
  String get currentWorkoutName => _currentWorkoutName;
  bool get isLoading => _isLoading;

  Duration get currentWorkoutDuration {
    if (_workoutStartTime == null) return Duration.zero;
    return DateTime.now().difference(_workoutStartTime!);
  }

  // Statistics
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
  }

  // Workout Management
  void startWorkout(String name) {
    _currentWorkoutName = name;
    _isWorkoutActive = true;
    _workoutStartTime = DateTime.now();
    _currentExercises.clear();
    notifyListeners();
  }

  void addExercise(String name, int sets, int reps, double weight) {
    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      sets: sets,
      reps: reps,
      weight: weight,
      timestamp: DateTime.now(),
    );

    _currentExercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(String exerciseId) {
    _currentExercises.removeWhere((ex) => ex.id == exerciseId);
    notifyListeners();
  }

  void finishWorkout() {
    if (!_isWorkoutActive || _currentExercises.isEmpty) return;

    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _currentWorkoutName,
      date: DateTime.now(),
      exercises: [..._currentExercises],
      duration: currentWorkoutDuration,
    );

    _workouts.insert(0, workout);
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

  // Data Persistence
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
}

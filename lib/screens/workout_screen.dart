import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/model/workout.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/workout_provider.dart';

// Onay ekranı için yeni bir sınıf
class ConfirmationScreen extends StatelessWidget {
  final String? food;
  final String? drink;

  const ConfirmationScreen({super.key, this.food, this.drink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seçim Onayı'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF2D3436)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seçiminiz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 16),
            if (food != null)
              Text(
                'Yiyecek: $food',
                style: TextStyle(fontSize: 18, color: Color(0xFF2D3436)),
              ),
            if (drink != null)
              Text(
                'İçecek: $drink',
                style: TextStyle(fontSize: 18, color: Color(0xFF2D3436)),
              ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tamam',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Timer? _restTimer;
  int _remainingRestTime = 0;
  bool _isResting = false;

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _startRestTimer(int seconds) {
    setState(() {
      _remainingRestTime = seconds;
      _isResting = true;
    });
    _restTimer?.cancel();
    _restTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingRestTime > 0) {
        setState(() {
          _remainingRestTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResting = false;
        });
      }
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
      _remainingRestTime = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Antrenman',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color(0xFF2D3436),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF2D3436)),
        actions: [
          Consumer<WorkoutProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${provider.streak}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.isWorkoutActive) {
            return _buildActiveWorkoutView(workoutProvider);
          } else {
            return _buildStartWorkoutView(workoutProvider);
          }
        },
      ),
    );
  }

  Widget _buildStartWorkoutView(WorkoutProvider workoutProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6C5CE7).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  '${workoutProvider.streak} Gün',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Mevcut Seri',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if ((workoutProvider.streak) > 0) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Devam et! 🔥',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 32),

          Text(
            'Hızlı Başlat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.play_circle_filled_rounded,
                  size: 64,
                  color: Color(0xFF6C5CE7),
                ),
                SizedBox(height: 16),
                Text(
                  'Boş Antrenman Başlat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Egzersizlerini hareket halindeyken ekle',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showQuickStartDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Başlat',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Antrenman Şablonları',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showCreateTemplateDialog(context),
                icon: Icon(Icons.add_rounded, size: 20),
                label: Text('Yeni'),
                style: TextButton.styleFrom(foregroundColor: Color(0xFF6C5CE7)),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (workoutProvider.templates.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.playlist_add_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz şablon yok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sık kullandığın antrenmanları şablon olarak kaydet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            )
          else
            ...workoutProvider.templates
                .map(
                  (template) => _buildTemplateCard(template, workoutProvider),
                )
                .toList(),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    WorkoutTemplate template,
    WorkoutProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.playlist_play_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          template.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF2D3436),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            '${template.exercises.length} egzersiz',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _showTemplatePreview(template),
              icon: Icon(Icons.visibility_rounded, color: Colors.grey[600]),
            ),
            IconButton(
              onPressed: () => _startWorkoutFromTemplate(template, provider),
              icon: Icon(Icons.play_arrow_rounded, color: Color(0xFF6C5CE7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveWorkoutView(WorkoutProvider workoutProvider) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Text(
                  workoutProvider.currentWorkoutName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                StreamBuilder(
                  stream:
                      workoutProvider.isWorkoutActive
                          ? Stream.periodic(Duration(seconds: 1))
                          : null, // Antrenman bitince stream durur
                  builder: (context, snapshot) {
                    final duration = workoutProvider.currentWorkoutDuration;
                    return Text(
                      '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        if (_isResting)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color(0xFF00B894),
            child: Column(
              children: [
                Text(
                  'Dinlenme Süresi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${(_remainingRestTime ~/ 60)}:${(_remainingRestTime % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _startRestTimer(_remainingRestTime + 30),
                      child: Text('+30s'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00B894),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _stopRestTimer,
                      child: Text('Bitir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00B894),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        Expanded(
          child:
              workoutProvider.currentExercises.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Henüz egzersiz eklenmedi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'İlk egzersizini eklemek için + butonuna bas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: workoutProvider.currentExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = workoutProvider.currentExercises[index];
                      return _buildExerciseCard(
                        exercise,
                        index,
                        workoutProvider,
                      );
                    },
                  ),
        ),

        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddExerciseDialog(context),
                    icon: Icon(Icons.add_rounded),
                    label: Text('Egzersiz Ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (workoutProvider.isWorkoutActive) {
                        _showFinishWorkoutDialog(context);
                      }
                    },
                    icon: Icon(Icons.check_rounded),
                    label: Text('Bitir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          workoutProvider.isWorkoutActive
                              ? Color(0xFF00B894)
                              : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(
    Exercise exercise,
    int index,
    WorkoutProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => provider.removeExercise(exercise.id),
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${exercise.sets} set × ${exercise.reps} tekrar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  Text(
                    '${exercise.weight} kg',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C5CE7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startRestTimer(exercise.restSeconds),
                    child: Text('${exercise.restSeconds ~/ 60} dk dinlen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00B894),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startRestTimer(exercise.restSeconds + 30),
                    child: Text('+30s'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00B894),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickStartDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Antrenman Başlat'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Antrenman Adı',
                hintText: 'ör: Bacak Günü, Push Day',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    context.read<WorkoutProvider>().startWorkout(name);
                    Navigator.pop(context);
                  }
                },
                child: Text('Başlat'),
              ),
            ],
          ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final nameController = TextEditingController();
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final restSecondsController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Egzersiz Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Egzersiz Adı',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: setsController,
                        decoration: InputDecoration(
                          labelText: 'Set',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: repsController,
                        decoration: InputDecoration(
                          labelText: 'Tekrar',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Ağırlık (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: restSecondsController,
                  decoration: InputDecoration(
                    labelText: 'Dinlenme Süresi (saniye)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final sets = int.tryParse(setsController.text) ?? 0;
                  final reps = int.tryParse(repsController.text) ?? 0;
                  final weight = double.tryParse(weightController.text) ?? 0.0;
                  final restSeconds =
                      int.tryParse(restSecondsController.text) ?? 60;

                  if (name.isNotEmpty && sets > 0 && reps > 0) {
                    context.read<WorkoutProvider>().addExercise(
                      name,
                      sets,
                      reps,
                      weight,
                      restSeconds: restSeconds,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Ekle'),
              ),
            ],
          ),
    );
  }

  void _showFinishWorkoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF00B894)),
                SizedBox(width: 8),
                Text('Antrenmanı Bitir'),
              ],
            ),
            content: Text(
              'Antrenmanınızı bitirmek istediğinizden emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final provider = context.read<WorkoutProvider>();
                  if (provider.isWorkoutActive) {
                    provider.finishWorkout();
                    _stopRestTimer(); // Timer'ı burada durduruyoruz
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.celebration_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text('Tebrikler! Antrenman tamamlandı 🎉'),
                          ],
                        ),
                        backgroundColor: Color(0xFF00B894),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    _showRecoverySuggestionDialog(context);
                  }
                },
                child: Text('Bitir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00B894),
                ),
              ),
            ],
          ),
    );
  }

  void _showRecoverySuggestionDialog(BuildContext context) {
    final provider = context.read<WorkoutProvider>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.restaurant_rounded, color: Color(0xFF00B894)),
                SizedBox(width: 8),
                Text('İyileşme Seçenekleri'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Ne yemeyi seçiyorsun?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildOptionButton(
                    context,
                    "Protein Shake: 1 ölçek whey protein, 1 muz, 1 yemek kaşığı fıstık ezmesi",
                    () => _handleFoodSelection(
                      context,
                      "Protein Shake: 1 ölçek whey protein, 1 muz, 1 yemek kaşığı fıstık ezmesi",
                    ),
                  ),
                  _buildOptionButton(
                    context,
                    "Yemek: 150g ızgara tavuk, 100g tatlı patates, bir avuç ıspanak",
                    () => _handleFoodSelection(
                      context,
                      "Yemek: 150g ızgara tavuk, 100g tatlı patates, bir avuç ıspanak",
                    ),
                  ),
                  _buildOptionButton(
                    context,
                    "Atıştırmalık: 200g Yunan yoğurdu, 1 avuç yaban mersini, 1 tatlı kaşığı bal",
                    () => _handleFoodSelection(
                      context,
                      "Atıştırmalık: 200g Yunan yoğurdu, 1 avuç yaban mersini, 1 tatlı kaşığı bal",
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Ne içmeyi seçiyorsun?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildOptionButton(
                    context,
                    "Su: 500-750 ml",
                    () => _handleDrinkSelection(context, "Su: 500-750 ml"),
                  ),
                  _buildOptionButton(
                    context,
                    "Hindistancevizi suyu: Elektrolit dengesi için",
                    () => _handleDrinkSelection(
                      context,
                      "Hindistancevizi suyu: Elektrolit dengesi için",
                    ),
                  ),
                  _buildOptionButton(
                    context,
                    "Yeşil Çay: Antioksidan etkisiyle iyileşmeyi destekler",
                    () => _handleDrinkSelection(
                      context,
                      "Yeşil Çay: Antioksidan etkisiyle iyileşmeyi destekler",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  provider.clearRecoverySuggestion();
                  Navigator.pop(context);
                },
                child: Text('Kapat'),
              ),
            ],
          ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String label,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _handleFoodSelection(BuildContext context, String food) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seçtin: $food - Afiyet olsun!'),
        backgroundColor: Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context); // Dialogu kapat
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationScreen(food: food)),
    );
  }

  void _handleDrinkSelection(BuildContext context, String drink) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seçtin: $drink - Şifa olsun!'),
        backgroundColor: Color(0xFF00B894),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context); // Dialogu kapat
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationScreen(drink: drink)),
    );
  }

  void _showCreateTemplateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final workoutProvider = context.read<WorkoutProvider>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Şablon Oluştur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Şablon Adı',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty &&
                      workoutProvider.currentExercises.isNotEmpty) {
                    workoutProvider.addTemplate(name, [
                      ...workoutProvider.currentExercises,
                    ]);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Şablon başarıyla oluşturuldu!'),
                        backgroundColor: Color(0xFF00B894),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Önce bir antrenman oluşturun!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Oluştur'),
              ),
            ],
          ),
    );
  }

  void _showTemplatePreview(WorkoutTemplate template) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('${template.name} Önizleme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  template.exercises
                      .map(
                        (e) => ListTile(
                          title: Text(e.name),
                          subtitle: Text(
                            '${e.sets} set × ${e.reps} tekrar @ ${e.weight}kg',
                          ),
                        ),
                      )
                      .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Kapat'),
              ),
            ],
          ),
    );
  }

  void _startWorkoutFromTemplate(
    WorkoutTemplate template,
    WorkoutProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Antrenmanı Başlat'),
            content: Text(
              'Bu şablon ile yeni bir antrenman başlatmak istiyor musunuz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.startWorkout(template.name, template: template);
                  Navigator.pop(context);
                },
                child: Text('Başlat'),
              ),
            ],
          ),
    );
  }
}

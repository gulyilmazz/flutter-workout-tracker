import 'package:flutter/material.dart';
import 'package:flutter_workout_tracker/model/workout.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/workout_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'İstatistikler',
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
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          if (workoutProvider.workouts.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderStats(workoutProvider),
                SizedBox(height: 24),
                _buildOverallStatsSection(workoutProvider),
                SizedBox(height: 24),
                if ((workoutProvider.streak) > 0)
                  _buildStreakSection(workoutProvider),
                SizedBox(height: 24),
                _buildWeeklyProgressSection(workoutProvider),
                SizedBox(height: 24),
                _buildRecentActivitySection(workoutProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[200]!, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.analytics_rounded,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Henüz İstatistik Yok',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Antrenman yapmaya başlayın ve\nilerlemenizi burada takip edin!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.trending_up_rounded,
                          color: Color(0xFF6C5CE7),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'İlerlemeni Takip Et',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3436),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Antrenman verileriniz burada görünecek',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats(WorkoutProvider workoutProvider) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Genel Performansın',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderStatItem(
                  workoutProvider.totalWorkouts.toString(),
                  'Toplam Antrenman',
                  Icons.fitness_center_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildHeaderStatItem(
                  '${workoutProvider.totalWorkoutTime.inHours}sa ${(workoutProvider.totalWorkoutTime.inMinutes % 60)}dk',
                  'Toplam Süre',
                  Icons.timer_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatItem(String value, String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOverallStatsSection(WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics_rounded, color: Color(0xFF2D3436), size: 24),
            SizedBox(width: 8),
            Text(
              'Genel İstatistikler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Toplam Egzersiz',
                value: workoutProvider.totalExercises.toString(),
                icon: Icons.list_rounded,
                gradient: [Color(0xFF00B894), Color(0xFF00CEC9)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                title: 'Bu Hafta',
                value: workoutProvider.thisWeekWorkouts.length.toString(),
                icon: Icons.calendar_today_rounded,
                gradient: [Color(0xFFE17055), Color(0xFFFF7675)],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Ortalama Süre',
                value:
                    workoutProvider.totalWorkouts > 0
                        ? '${(workoutProvider.totalWorkoutTime.inMinutes / workoutProvider.totalWorkouts).round()} dk'
                        : '0 dk',
                icon: Icons.av_timer_rounded,
                gradient: [Color(0xFFFD79A8), Color(0xFFE84393)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _StatCard(
                title: 'En Uzun',
                value:
                    workoutProvider.workouts.isNotEmpty
                        ? '${workoutProvider.workouts.map((w) => w.duration.inMinutes).reduce((a, b) => a > b ? a : b)} dk'
                        : '0 dk',
                icon: Icons.trending_up_rounded,
                gradient: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakSection(WorkoutProvider workoutProvider) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
          SizedBox(width: 12),
          Text(
            'Mevcut Seri: ${workoutProvider.streak} gün',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressSection(WorkoutProvider workoutProvider) {
    final thisWeekWorkouts = workoutProvider.thisWeekWorkouts;
    final lastWeekStart = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday + 6),
    );
    final lastWeekWorkouts =
        workoutProvider.workouts
            .where(
              (w) =>
                  w.date.isAfter(lastWeekStart) &&
                  w.date.isBefore(
                    DateTime.now().subtract(
                      Duration(days: DateTime.now().weekday - 1),
                    ),
                  ),
            )
            .toList();

    final weeklyProgress = thisWeekWorkouts.length - lastWeekWorkouts.length;
    final isImprovement = weeklyProgress >= 0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF2D3436),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Haftalık İlerleme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Bu Hafta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${thisWeekWorkouts.length}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      Text(
                        'Antrenman',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isImprovement ? Colors.green : Colors.orange)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isImprovement
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isImprovement ? Colors.green : Colors.orange,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Değişim',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isImprovement ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${weeklyProgress >= 0 ? '+' : ''}$weeklyProgress',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      Text(
                        'Geçen haftaya göre',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(WorkoutProvider workoutProvider) {
    final recentWorkouts = workoutProvider.workouts.take(5).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: Color(0xFF2D3436), size: 24),
              SizedBox(width: 8),
              Text(
                'Son Aktiviteler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...recentWorkouts
              .map((workout) => _buildRecentActivityItem(workout))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItem(Workout workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF6C5CE7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: Color(0xFF6C5CE7),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy').format(workout.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            '${workout.duration.inMinutes} dk',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6C5CE7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final List<Color> gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

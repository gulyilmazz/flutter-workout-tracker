import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Stats',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Workouts',
                        value: workoutProvider.totalWorkouts.toString(),
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Total Exercises',
                        value: workoutProvider.totalExercises.toString(),
                        icon: Icons.list,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Total Time',
                        value:
                            '${workoutProvider.totalWorkoutTime.inHours}h ${workoutProvider.totalWorkoutTime.inMinutes % 60}m',
                        icon: Icons.timer,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'This Week',
                        value:
                            workoutProvider.thisWeekWorkouts.length.toString(),
                        icon: Icons.calendar_today,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                if (workoutProvider.workouts.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No workout data available yet.\nStart working out to see your progress!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ...workoutProvider.workouts
                      .take(5)
                      .map(
                        (workout) => Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(workout.name),
                            subtitle: Text(
                              '${workout.exercises.length} exercises • ${workout.duration.inMinutes} min',
                            ),
                            trailing: Text(
                              '${workout.date.day}/${workout.date.month}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'goals_model.dart';

class GoalsResponse {
  final Goals goals;
  final GoalsProgress progress;

  GoalsResponse({required this.goals, required this.progress});

  factory GoalsResponse.fromJson(Map<String, dynamic> j) => GoalsResponse(
    goals: Goals.fromJson(j['goals']),
    progress: GoalsProgress.fromJson(j['progress']),
  );
}

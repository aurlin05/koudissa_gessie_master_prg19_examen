import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum for Task Priority
enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

/// Enum for Task Status
enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

/// Model representing a task in the application
class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String createdBy;
  final DateTime createdAt;
  final List<String> assignedTo;
  final int completionPercentage;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.createdBy,
    required this.createdAt,
    required this.assignedTo,
    this.completionPercentage = 0,
  });

  /// Create a TaskModel from a JSON map
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      priority: TaskPriority.values.firstWhere(
          (e) => e.toString() == 'TaskPriority.${json['priority']}'),
      status: TaskStatus.values.firstWhere(
          (e) => e.toString() == 'TaskStatus.${json['status']}'),
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      assignedTo: List<String>.from(json['assignedTo'] as List),
      completionPercentage: json['completionPercentage'] as int,
    );
  }

  /// Convert the TaskModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'assignedTo': assignedTo,
      'completionPercentage': completionPercentage,
    };
  }

  /// Create a copy of the TaskModel with updated values
  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? createdBy,
    DateTime? createdAt,
    List<String>? assignedTo,
    int? completionPercentage,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      assignedTo: assignedTo ?? this.assignedTo,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}
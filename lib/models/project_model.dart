import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum for Project Status
enum ProjectStatus {
  pending, // En attente
  inProgress, // En cours
  completed, // Terminé
  cancelled, // Annulé
}

/// Enum for Project Priority
enum ProjectPriority {
  low,
  medium,
  high,
  urgent,
}

/// Model representing a project in the application
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final ProjectPriority priority;
  final ProjectStatus status;
  final String createdBy;
  final DateTime createdAt;
  final List<String> members;
  final int completionPercentage;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.priority,
    this.status = ProjectStatus.pending,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    this.completionPercentage = 0,
  });

  /// Create a ProjectModel from a JSON map
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      priority: ProjectPriority.values.firstWhere(
          (e) => e.toString() == 'ProjectPriority.${json['priority']}'),
      status: ProjectStatus.values.firstWhere(
          (e) => e.toString() == 'ProjectStatus.${json['status']}'),
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(json['members'] as List),
      completionPercentage: json['completionPercentage'] as int,
    );
  }

  /// Convert the ProjectModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'members': members,
      'completionPercentage': completionPercentage,
    };
  }

  /// Create a copy of the ProjectModel with updated values
  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    ProjectPriority? priority,
    ProjectStatus? status,
    String? createdBy,
    DateTime? createdAt,
    List<String>? members,
    int? completionPercentage,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}
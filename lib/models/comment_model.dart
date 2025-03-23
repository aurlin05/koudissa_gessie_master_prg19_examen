import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a comment on a task
class CommentModel {
  final String id;
  final String taskId;
  final String userId;
  final String userDisplayName;
  final String? userPhotoUrl;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userDisplayName,
    this.userPhotoUrl,
    required this.content,
    required this.createdAt,
  });

  /// Create a CommentModel from a JSON map
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      userId: json['userId'] as String,
      userDisplayName: json['userDisplayName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      content: json['content'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert the CommentModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'userId': userId,
      'userDisplayName': userDisplayName,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}  

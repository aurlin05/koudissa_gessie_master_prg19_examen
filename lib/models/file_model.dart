import 'package:cloud_firestore/cloud_firestore.dart';

/// Model representing a file in the system
class FileModel {
  final String id;
  final String name;
  final String url;
  final String projectId;
  final String? taskId;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String fileType; // pdf, image, doc, etc.
  final int size; // in bytes

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    required this.projectId,
    this.taskId,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.fileType,
    required this.size,
  });

  /// Create a FileModel from a JSON map
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      projectId: json['projectId'] as String,
      taskId: json['taskId'] as String?,
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: (json['uploadedAt'] as Timestamp).toDate(),
      fileType: json['fileType'] as String,
      size: json['size'] as int,
    );
  }

  /// Convert the FileModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'projectId': projectId,
      'taskId': taskId,
      'uploadedBy': uploadedBy,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'fileType': fileType,
      'size': size,
    };
  }
}
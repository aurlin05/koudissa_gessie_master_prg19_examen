import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  // Upload a file
  Future<String> uploadFile(File file, String folder) async {
    try {
      String fileName = path.basename(file.path);
      String extension = path.extension(file.path);
      String uniqueFileName = '${_uuid.v4()}$extension';
      
      Reference storageRef = _storage.ref().child('$folder/$uniqueFileName');
      UploadTask uploadTask = storageRef.putFile(file);
      
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload a profile image
  Future<String> uploadProfileImage(File file, String userId) async {
    try {
      String extension = path.extension(file.path);
      Reference storageRef = _storage.ref().child('profile_images/$userId$extension');
      
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload a project file
  Future<String> uploadProjectFile(File file, String projectId) async {
    return uploadFile(file, 'project_files/$projectId');
  }

  // Upload a task file
  Future<String> uploadTaskFile(File file, String taskId) async {
    return uploadFile(file, 'task_files/$taskId');
  }

  // Delete a file
  Future<void> deleteFile(String fileUrl) async {
    try {
      Reference reference = _storage.refFromURL(fileUrl);
      await reference.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get file size limit based on user role
  int getFileSizeLimit(String role) {
    switch (role) {
      case 'admin':
        return 100 * 1024 * 1024; // 100 MB
      case 'project_manager':
        return 50 * 1024 * 1024; // 50 MB
      case 'team_member':
        return 20 * 1024 * 1024; // 20 MB
      default:
        return 10 * 1024 * 1024; // 10 MB
    }
  }
}
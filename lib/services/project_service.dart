import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Create a new project
  Future<String> createProject(ProjectModel project) async {
    try {
      String projectId = _uuid.v4();
      ProjectModel newProject = project.copyWith(
        id: projectId,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('projects').doc(projectId).set(newProject.toJson());
      return projectId;
    } catch (e) {
      rethrow;
    }
  }

  // Get all projects
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get projects by status
  Future<List<ProjectModel>> getProjectsByStatus(ProjectStatus status) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where('status', isEqualTo: status.toString().split('.').last)
          .get();
      
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get projects by member
  Future<List<ProjectModel>> getProjectsByMember(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where('members', arrayContains: userId)
          .get();
      
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get project by id
  Future<ProjectModel> getProjectById(String projectId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('projects').doc(projectId).get();
      return ProjectModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update project
  Future<void> updateProject(ProjectModel project) async {
    try {
      return await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Update project status
  Future<void> updateProjectStatus(String projectId, ProjectStatus status) async {
    try {
      return await _firestore.collection('projects').doc(projectId).update({
        'status': status.toString().split('.').last,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Add member to project
  Future<void> addMemberToProject(String projectId, String userId) async {
    try {
      return await _firestore.collection('projects').doc(projectId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Remove member from project
  Future<void> removeMemberFromProject(String projectId, String userId) async {
    try {
      return await _firestore.collection('projects').doc(projectId).update({
        'members': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update project completion percentage
  Future<void> updateProjectCompletion(String projectId, int completionPercentage) async {
    try {
      return await _firestore.collection('projects').doc(projectId).update({
        'completionPercentage': completionPercentage,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete project
  Future<void> deleteProject(String projectId) async {
    try {
      return await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get project statistics
  Future<Map<String, int>> getProjectStatistics() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      
      Map<String, int> stats = {
        'total': snapshot.docs.length,
        'pending': 0,
        'inProgress': 0,
        'completed': 0,
        'cancelled': 0,
      };
      
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] as String;
        stats[status] = (stats[status] ?? 0) + 1;
      }
      
      return stats;
    } catch (e) {
      rethrow;
    }
  }

  // Stream of projects
  Stream<List<ProjectModel>> projectsStream() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
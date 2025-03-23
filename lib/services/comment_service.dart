import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Create a new comment
  Future<String> createComment(CommentModel comment) async {
    try {
      String commentId = _uuid.v4();
      CommentModel newComment = CommentModel(
        id: commentId,
        taskId: comment.taskId,
        userId: comment.userId,
        userDisplayName: comment.userDisplayName,
        userPhotoUrl: comment.userPhotoUrl,
        content: comment.content,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('comments').doc(commentId).set(newComment.toJson());
      return commentId;
    } catch (e) {
      rethrow;
    }
  }

  // Get comments for a task
  Future<List<CommentModel>> getCommentsByTask(String taskId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('comments')
          .where('taskId', isEqualTo: taskId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Delete comment
  Future<void> deleteComment(String commentId) async {
    try {
      return await _firestore.collection('comments').doc(commentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Stream of comments for a task
  Stream<List<CommentModel>> commentsStreamByTask(String taskId) {
    return _firestore
        .collection('comments')
        .where('taskId', isEqualTo: taskId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
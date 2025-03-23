import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user stream
  Stream<User?> get userStream => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUp(String email, String password, String name, String role) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Send email verification
      await result.user!.sendEmailVerification();
      
      // Create user document in Firestore
      UserModel userModel = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
        emailVerified: false,
      );
      
      await _firestore.collection('users').doc(result.user!.uid).set(userModel.toJson());
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last login
      await _firestore.collection('users').doc(result.user!.uid).update({
        'lastLogin': DateTime.now().toIso8601String(),
        'emailVerified': result.user!.emailVerified,
      });
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // Get user details
  Future<UserModel> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      return await _firestore.collection('users').doc(user.uid).update(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Update user photo
  Future<void> updateUserPhoto(String uid, String photoUrl) async {
    try {
      return await _firestore.collection('users').doc(uid).update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is admin
  Future<bool> isUserAdmin(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Get all users (admin function)
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Update user status (active/inactive) - admin function
  Future<void> updateUserStatus(String uid, bool isActive) async {
    try {
      return await _firestore.collection('users').doc(uid).update({
        'isActive': isActive,
      });
    } catch (e) {
      rethrow;
    }
  }
}
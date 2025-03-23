/// Model representing a user in the application
class UserModel {
  final String uid;
  final String email;
  final String name;
  String? photoUrl;
  final String role; // 'admin', 'project_manager', 'team_member'
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool emailVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
    this.emailVerified = false,
  });

  /// Create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      emailVerified: json['emailVerified'] as bool,
    );
  }

  /// Convert the UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'emailVerified': emailVerified,
    };
  }

  /// Create a copy of the UserModel with updated values
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? emailVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
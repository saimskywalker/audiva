/// User model representing authenticated users
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isArtist;
  final String? artistType;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isArtist = false,
    this.artistType,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isArtist: json['isArtist'] as bool? ?? false,
      artistType: json['artistType'] as String?,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isArtist': isArtist,
      'artistType': artistType,
    };
  }

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isArtist,
    String? artistType,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isArtist: isArtist ?? this.isArtist,
      artistType: artistType ?? this.artistType,
    );
  }
}

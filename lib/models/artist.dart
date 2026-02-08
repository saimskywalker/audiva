/// Artist model
class Artist {
  final String id;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final int followers;
  final List<String>? genres;

  Artist({
    required this.id,
    required this.name,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.followers = 0,
    this.genres,
  });

  /// Create Artist from JSON
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      followers: json['followers'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  /// Convert Artist to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'followers': followers,
      'genres': genres,
    };
  }
}

/// Album model
class Album {
  final String id;
  final String title;
  final String artistName;
  final String artistId;
  final String coverUrl;
  final int trackCount;
  final DateTime? releaseDate;
  final List<String>? genres;

  Album({
    required this.id,
    required this.title,
    required this.artistName,
    required this.artistId,
    required this.coverUrl,
    this.trackCount = 0,
    this.releaseDate,
    this.genres,
  });

  /// Create Album from JSON
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      coverUrl: json['coverUrl'] as String,
      trackCount: json['trackCount'] as int? ?? 0,
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'] as String)
          : null,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  /// Convert Album to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistName': artistName,
      'artistId': artistId,
      'coverUrl': coverUrl,
      'trackCount': trackCount,
      'releaseDate': releaseDate?.toIso8601String(),
      'genres': genres,
    };
  }
}

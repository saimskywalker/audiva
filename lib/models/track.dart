/// Music track model
class Track {
  final String id;
  final String title;
  final String artistName;
  final String artistId;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final String? albumName;
  final String? albumId;
  final int likes;
  final int plays;
  final List<String>? genres;

  Track({
    required this.id,
    required this.title,
    required this.artistName,
    required this.artistId,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    this.albumName,
    this.albumId,
    this.likes = 0,
    this.plays = 0,
    this.genres,
  });

  /// Create Track from JSON
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      coverUrl: json['coverUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      duration: Duration(milliseconds: json['durationMs'] as int),
      albumName: json['albumName'] as String?,
      albumId: json['albumId'] as String?,
      likes: json['likes'] as int? ?? 0,
      plays: json['plays'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  /// Convert Track to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistName': artistName,
      'artistId': artistId,
      'coverUrl': coverUrl,
      'audioUrl': audioUrl,
      'durationMs': duration.inMilliseconds,
      'albumName': albumName,
      'albumId': albumId,
      'likes': likes,
      'plays': plays,
      'genres': genres,
    };
  }
}

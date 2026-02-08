/// Video type enum
enum VideoType {
  live,
  archived,
  behindScenes,
}

/// Video model for live streams and archived content
class Video {
  final String id;
  final String title;
  final String artistName;
  final String artistId;
  final String thumbnailUrl;
  final String videoUrl;
  final VideoType type;
  final bool isLive;
  final DateTime? publishedAt;
  final Duration? duration;
  final int views;
  final String? description;

  Video({
    required this.id,
    required this.title,
    required this.artistName,
    required this.artistId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.type,
    this.isLive = false,
    this.publishedAt,
    this.duration,
    this.views = 0,
    this.description,
  });

  /// Create Video from JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      artistName: json['artistName'] as String,
      artistId: json['artistId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      type: VideoType.values.firstWhere(
        (e) => e.toString() == 'VideoType.${json['type']}',
        orElse: () => VideoType.archived,
      ),
      isLive: json['isLive'] as bool? ?? false,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      duration: json['durationMs'] != null
          ? Duration(milliseconds: json['durationMs'] as int)
          : null,
      views: json['views'] as int? ?? 0,
      description: json['description'] as String?,
    );
  }

  /// Convert Video to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistName': artistName,
      'artistId': artistId,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'type': type.toString().split('.').last,
      'isLive': isLive,
      'publishedAt': publishedAt?.toIso8601String(),
      'durationMs': duration?.inMilliseconds,
      'views': views,
      'description': description,
    };
  }
}

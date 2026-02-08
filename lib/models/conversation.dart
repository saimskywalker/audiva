import 'message.dart';

/// Conversation model for chat threads
class Conversation {
  final String id;
  final String artistId;
  final String artistName;
  final String? artistAvatar;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;

  Conversation({
    required this.id,
    required this.artistId,
    required this.artistName,
    this.artistAvatar,
    this.lastMessage,
    this.unreadCount = 0,
    required this.lastActivity,
  });

  /// Create Conversation from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      artistId: json['artistId'] as String,
      artistName: json['artistName'] as String,
      artistAvatar: json['artistAvatar'] as String?,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }

  /// Convert Conversation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artistId': artistId,
      'artistName': artistName,
      'artistAvatar': artistAvatar,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }
}

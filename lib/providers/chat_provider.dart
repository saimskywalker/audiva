import 'package:flutter/foundation.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/mock_data_service.dart';

/// Provider for chat state management
class ChatProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch conversations from service
  Future<void> fetchConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      _conversations = MockDataService.getMockConversations();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get messages for a specific artist/conversation
  List<Message> getMessages(String artistId) {
    return _messages[artistId] ?? [];
  }

  /// Fetch messages for a specific artist
  Future<void> fetchMessages(String artistId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      _messages[artistId] = MockDataService.getMockMessages(artistId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Send a message
  Future<void> sendMessage(String artistId, String text) async {
    if (text.trim().isEmpty) return;

    try {
      // Create new message
      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        senderId: 'user123',
        senderName: 'You',
        timestamp: DateTime.now(),
        isArtist: false,
        isRead: true,
      );

      // Add to messages list
      if (_messages[artistId] == null) {
        _messages[artistId] = [];
      }
      _messages[artistId]!.add(newMessage);

      // Update conversation last message
      final conversationIndex =
          _conversations.indexWhere((c) => c.artistId == artistId);
      if (conversationIndex != -1) {
        final conversation = _conversations[conversationIndex];
        final updatedConversation = Conversation(
          id: conversation.id,
          artistId: conversation.artistId,
          artistName: conversation.artistName,
          artistAvatar: conversation.artistAvatar,
          lastMessage: newMessage,
          unreadCount: 0,
          lastActivity: DateTime.now(),
        );
        _conversations[conversationIndex] = updatedConversation;
      }

      notifyListeners();

      // Simulate artist reply after delay (for demo)
      Future.delayed(const Duration(seconds: 2), () {
        _simulateArtistReply(artistId);
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Simulate an artist reply (mock functionality)
  void _simulateArtistReply(String artistId) {
    final replies = [
      'Thanks for your message!',
      'Glad you enjoyed the music!',
      'Appreciate the support!',
      'See you at the show!',
      'Stay tuned for more!',
    ];

    final replyMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: replies[DateTime.now().millisecond % replies.length],
      senderId: artistId,
      senderName: _getArtistName(artistId),
      senderAvatar: 'https://picsum.photos/seed/$artistId/200',
      timestamp: DateTime.now(),
      isArtist: true,
      isRead: false,
    );

    if (_messages[artistId] != null) {
      _messages[artistId]!.add(replyMessage);

      // Update conversation
      final conversationIndex =
          _conversations.indexWhere((c) => c.artistId == artistId);
      if (conversationIndex != -1) {
        final conversation = _conversations[conversationIndex];
        final updatedConversation = Conversation(
          id: conversation.id,
          artistId: conversation.artistId,
          artistName: conversation.artistName,
          artistAvatar: conversation.artistAvatar,
          lastMessage: replyMessage,
          unreadCount: conversation.unreadCount + 1,
          lastActivity: DateTime.now(),
        );
        _conversations[conversationIndex] = updatedConversation;
      }

      notifyListeners();
    }
  }

  String _getArtistName(String artistId) {
    switch (artistId) {
      case 'artist1':
        return 'Luna Echo';
      case 'artist2':
        return 'The Coastal Crew';
      case 'artist5':
        return 'Sarah Rivers';
      default:
        return 'Artist';
    }
  }

  /// Mark messages as read
  void markAsRead(String artistId) {
    final conversationIndex =
        _conversations.indexWhere((c) => c.artistId == artistId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final updatedConversation = Conversation(
        id: conversation.id,
        artistId: conversation.artistId,
        artistName: conversation.artistName,
        artistAvatar: conversation.artistAvatar,
        lastMessage: conversation.lastMessage,
        unreadCount: 0,
        lastActivity: conversation.lastActivity,
      );
      _conversations[conversationIndex] = updatedConversation;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

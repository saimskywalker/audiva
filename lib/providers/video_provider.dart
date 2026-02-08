import 'package:flutter/foundation.dart';
import '../models/video.dart';
import '../services/mock_data_service.dart';

/// Provider for video state management
class VideoProvider extends ChangeNotifier {
  List<Video> _videos = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtered lists
  List<Video> get liveVideos => _videos.where((v) => v.isLive).toList();
  List<Video> get archivedVideos => _videos.where((v) => !v.isLive).toList();

  /// Fetch videos from service
  Future<void> fetchVideos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      _videos = MockDataService.getMockVideos();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh videos (pull-to-refresh)
  Future<void> refresh() async {
    await fetchVideos();
  }

  /// Get video by ID
  Video? getVideoById(String id) {
    try {
      return _videos.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../providers/video_provider.dart';
import '../../providers/audio_provider.dart';
import '../../models/video.dart';

/// Video player screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final videoProvider = context.read<VideoProvider>();
    final video = videoProvider.getVideoById(widget.videoId);

    if (video == null) {
      return;
    }

    // Pause audio if playing
    final audioProvider = context.read<AudioProvider>();
    if (audioProvider.isPlaying) {
      await audioProvider.togglePlayPause();
    }

    // Initialize video player
    _controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));

    await _controller!.initialize();
    setState(() {
      _isInitialized = true;
    });

    // Auto-play
    _controller!.play();

    // Listen to video completion
    _controller!.addListener(() {
      if (_controller!.value.position == _controller!.value.duration) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    // Restore orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      // Auto-hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller!.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = context.watch<VideoProvider>();
    final video = videoProvider.getVideoById(widget.videoId);

    if (video == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text('Video not found'),
        ),
        body: const Center(
          child: Text('Video not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                video.title,
                style: AppTextStyles.body.copyWith(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      body: Column(
        children: [
          // Video player
          _isInitialized
              ? GestureDetector(
                  onTap: _toggleControls,
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(_controller!),
                        // Controls overlay
                        if (_showControls) _buildControls(video),
                      ],
                    ),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
          // Video info (only in portrait)
          if (!_isFullscreen) _buildVideoInfo(video),
        ],
      ),
    );
  }

  Widget _buildControls(Video video) {
    final isPlaying = _controller!.value.isPlaying;
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar with fullscreen button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: _toggleFullscreen,
                ),
              ],
            ),
          ),
          // Center play/pause button
          Center(
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                color: Colors.white,
                size: 64,
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
            ),
          ),
          // Bottom controls
          Column(
            children: [
              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      Formatters.formatDuration(position),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        value: position.inMilliseconds.toDouble(),
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.white.withOpacity(0.3),
                        onChanged: (value) {
                          _controller!.seekTo(Duration(milliseconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(
                      Formatters.formatDuration(duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(Video video) {
    return Expanded(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                video.title,
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 8),
              // Artist name
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      video.artistName[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    video.artistName,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Stats
              Row(
                children: [
                  if (video.publishedAt != null) ...[
                    Text(
                      Formatters.formatRelativeDate(video.publishedAt!),
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    '${Formatters.formatNumber(video.views)} views',
                    style: AppTextStyles.caption,
                  ),
                  if (video.isLive) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.liveRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (video.description != null) ...[
                const SizedBox(height: 16),
                const Divider(color: AppColors.surfaceLight),
                const SizedBox(height: 16),
                Text(
                  video.description!,
                  style: AppTextStyles.body,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

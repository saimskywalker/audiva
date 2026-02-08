import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/music_feed_provider.dart';
import '../../providers/audio_provider.dart';
import 'widgets/track_card.dart';

/// Music feed screen showing tracks
class MusicFeedScreen extends StatefulWidget {
  const MusicFeedScreen({super.key});

  @override
  State<MusicFeedScreen> createState() => _MusicFeedScreenState();
}

class _MusicFeedScreenState extends State<MusicFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tracks on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicFeedProvider>().fetchTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Music', style: AppTextStyles.headline2),
      ),
      body: Consumer2<MusicFeedProvider, AudioProvider>(
        builder: (context, musicProvider, audioProvider, child) {
          // Loading state
          if (musicProvider.isLoading && musicProvider.tracks.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: 10,
              itemBuilder: (context, index) => _buildShimmerCard(),
            );
          }

          // Error state
          if (musicProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load tracks',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => musicProvider.fetchTracks(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (musicProvider.tracks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'No tracks available',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            );
          }

          // Tracks list
          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: () => musicProvider.refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: musicProvider.tracks.length,
              itemBuilder: (context, index) {
                final track = musicProvider.tracks[index];
                final isCurrentTrack = audioProvider.currentTrack?.id == track.id;
                final isPlaying = isCurrentTrack && audioProvider.isPlaying;

                return TrackCard(
                  track: track,
                  isPlaying: isPlaying,
                  onTap: () {
                    if (isCurrentTrack) {
                      // Toggle play/pause if same track
                      audioProvider.togglePlayPause();
                    } else {
                      // Play new track with queue
                      audioProvider.playTrack(
                        track,
                        newQueue: musicProvider.tracks,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceLight,
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

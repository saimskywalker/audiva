import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/track.dart';

/// Card widget for displaying a track
class TrackCard extends StatelessWidget {
  final Track track;
  final VoidCallback? onTap;
  final bool isPlaying;

  const TrackCard({
    super.key,
    required this.track,
    this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Album art with play indicator
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: track.coverUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceLight,
                      child: const Icon(Icons.music_note, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceLight,
                      child: const Icon(Icons.music_note, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                // Play button overlay
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Track info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? AppColors.primary : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    track.artistName,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        Formatters.formatDuration(track.duration),
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.circle, size: 4, color: AppColors.textTertiary),
                      const SizedBox(width: 8),
                      Text(
                        '${Formatters.formatNumber(track.plays)} plays',
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Like button
            IconButton(
              icon: const Icon(Icons.favorite_border, color: AppColors.textSecondary),
              onPressed: () {
                // TODO: Implement like functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}

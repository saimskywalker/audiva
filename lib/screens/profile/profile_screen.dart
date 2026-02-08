import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';

/// Profile screen showing user information
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Logout', style: AppTextStyles.headline3),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  context.go('/auth/login');
                }
              },
              child: Text(
                'Logout',
                style: AppTextStyles.body.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Profile', style: AppTextStyles.headline2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Avatar
            if (user?.avatarUrl != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: CachedNetworkImageProvider(user!.avatarUrl!),
              )
            else
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primary,
                child: Text(
                  user?.name[0].toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // User name
            Text(
              user?.name ?? 'User',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              user?.email ?? '',
              style: AppTextStyles.caption,
            ),
            // Artist Badge (if artist)
            if (user?.isArtist == true) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Artist Account',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    if (user?.artistType != null) ...[
                      Text(
                        ' • ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatArtistType(user!.artistType!),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(color: AppColors.surfaceLight),

            // Artist-Only Features
            if (user?.isArtist == true) ...[
              _buildMenuItem(
                icon: Icons.cloud_upload,
                title: 'Upload Music',
                subtitle: 'Share your tracks with fans',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Upload feature coming soon!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.video_library,
                title: 'Upload Video',
                subtitle: 'Share behind-the-scenes content',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video upload coming soon!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.bar_chart,
                title: 'Analytics',
                subtitle: 'View your performance stats',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Analytics coming soon!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              const Divider(color: AppColors.surfaceLight),
            ],

            // Menu items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                // TODO: Navigate to edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit Profile coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.favorite_outline,
              title: 'Favorites',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Favorites coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Listening History',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Orders coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const Divider(color: AppColors.surfaceLight),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help coming soon!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About Audiva',
              subtitle: 'Version 1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Audiva',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Audiva. All rights reserved.',
                );
              },
            ),
            const Divider(color: AppColors.surfaceLight),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              titleColor: AppColors.error,
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  String _formatArtistType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}


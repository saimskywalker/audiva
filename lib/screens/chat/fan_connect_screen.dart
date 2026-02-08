import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/chat_provider.dart';
import 'widgets/conversation_card.dart';

/// Fan Connect screen showing artist conversations
class FanConnectScreen extends StatefulWidget {
  const FanConnectScreen({super.key});

  @override
  State<FanConnectScreen> createState() => _FanConnectScreenState();
}

class _FanConnectScreenState extends State<FanConnectScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch conversations on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Fan Connect', style: AppTextStyles.headline2),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          // Loading state
          if (chatProvider.isLoading && chatProvider.conversations.isEmpty) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => _buildShimmerCard(),
            );
          }

          // Error state
          if (chatProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load conversations',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => chatProvider.fetchConversations(),
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
          if (chatProvider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start chatting with your favorite artists!',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            );
          }

          // Conversations list
          return ListView.builder(
            itemCount: chatProvider.conversations.length,
            itemBuilder: (context, index) {
              final conversation = chatProvider.conversations[index];
              return ConversationCard(
                conversation: conversation,
                onTap: () {
                  context.push('/chat/${conversation.artistId}');
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceLight,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surface,
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
                    width: 200,
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


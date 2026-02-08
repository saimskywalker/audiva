import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/music_feed_provider.dart';
import 'providers/video_provider.dart';
import 'providers/merch_provider.dart';
import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkAuthStatus(),
        ),
        ChangeNotifierProvider(
          create: (_) => AudioProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => MusicFeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MerchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: const AudivaApp(),
    );
  }
}

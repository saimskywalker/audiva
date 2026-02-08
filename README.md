# 🎵 Audiva - Music & Entertainment Platform

> A comprehensive Flutter-based mobile app connecting artists and fans through music, videos, merchandise, and direct communication.

[![Flutter](https://img.shields.io/badge/Flutter-3.38.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.8-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)](https://github.com/saimskywalker/audiva)

---

## 📖 About

**Audiva** is a modern music and entertainment platform MVP built with Flutter. It provides a unified space where artists can showcase their work and fans can discover, stream, and engage with their favorite content. The app features a sleek dark theme interface with comprehensive user profiles, role-based authentication, and a complete media playback experience.

**Current Status**: MVP with mock data service. This version demonstrates the full UI/UX flow and architecture, ready for backend integration.

---

## ✨ Features

### 🎵 Music Streaming
- Full-featured audio player with play/pause, seek, shuffle, and repeat
- Real-time playback controls with progress tracking
- Queue management and playlist support
- Album browsing with detailed track listings

### 🎥 Video Hub
- Integrated video player with full-screen support
- Video gallery with thumbnails and metadata
- Seamless switching between audio and video content

### 🛍️ Merch Store
- Browse and shop artist merchandise
- Product details with images and descriptions
- Shopping cart functionality
- Size and variant selection

### 💬 Fan Connect
- Direct messaging between fans and artists
- Real-time chat interface (UI ready)
- Message history and conversation management
- User presence and status indicators

### 👤 User Profiles
- Dual role system: Artist and Fan profiles
- Artist profiles with discography, videos, and merch
- Fan profiles with favorites and activity history
- Profile customization and settings

---

## 🛠️ Tech Stack

### Core Framework
- **Flutter** 3.38.9
- **Dart** 3.10.8
- **Material Design 3** with custom dark theme

### State Management & Navigation
- **Provider** 6.1.2 - State management
- **GoRouter** 17.1.0 - Declarative routing

### Media & Playback
- **just_audio** 0.10.5 - Audio playback engine
- **audio_service** 0.18.13 - Background audio support
- **video_player** 2.8.2 - Video playback

### UI & User Experience
- **cached_network_image** 3.3.1 - Image caching and loading
- **shimmer** 3.0.0 - Loading skeletons
- **cupertino_icons** 1.0.8 - iOS-style icons

### Networking & Storage
- **http** 1.2.0 - API communication (ready for integration)
- **shared_preferences** 2.2.2 - Local data persistence

### Utilities
- **intl** 0.20.2 - Internationalization and formatting
- **url_launcher** 6.2.5 - External link handling

### Development Tools
- **flutter_lints** 6.0.0 - Code quality and style
- **flutter_launcher_icons** 0.14.2 - App icon generation

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point and initialization
├── core/                        # Core application infrastructure
│   ├── theme/                   # App theming (dark mode)
│   └── constants.dart           # App-wide constants
├── models/                      # Data models
│   ├── user.dart                # User and auth models
│   ├── music.dart               # Music, album, artist models
│   ├── video.dart               # Video content models
│   ├── merch.dart               # Merchandise models
│   └── chat.dart                # Messaging models
├── providers/                   # State management
│   ├── auth_provider.dart       # Authentication state
│   ├── music_provider.dart      # Music playback state
│   ├── video_provider.dart      # Video playback state
│   ├── merch_provider.dart      # Shopping state
│   └── chat_provider.dart       # Messaging state
├── services/                    # Business logic
│   └── mock_data_service.dart   # Mock data (ready for API service)
├── screens/                     # UI screens
│   ├── auth/                    # Login, register, onboarding
│   ├── home/                    # Main dashboard
│   ├── music/                   # Music player and library
│   ├── video/                   # Video player and gallery
│   ├── merch/                   # Store and product details
│   ├── chat/                    # Messaging interface
│   └── profile/                 # User profile and settings
└── widgets/                     # Reusable UI components
    ├── music_player_controls.dart
    ├── video_player_widget.dart
    ├── product_card.dart
    └── ...
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** 3.38.9 or higher
- **Dart** 3.10.8 or higher
- iOS Simulator, Android Emulator, or physical device
- Xcode (for iOS development)
- Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:saimskywalker/audiva.git
   cd audiva/mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons** (optional)
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

   Or select a specific device:
   ```bash
   flutter run -d chrome        # Web
   flutter run -d macos         # macOS
   flutter run -d <device-id>   # iOS/Android
   ```

### Default Credentials (Mock Data)

**Artist Account**:
- Email: `artist@audiva.com`
- Password: `password`

**Fan Account**:
- Email: `fan@audiva.com`
- Password: `password`

---

## 🏗️ Architecture

### Design Patterns
- **MVVM** with Provider for state management
- **Repository Pattern** (ready for API service implementation)
- **Dependency Injection** via Provider
- **Separation of Concerns** (models, views, providers, services)

### Navigation
- **Declarative routing** with GoRouter
- **Deep linking support** (configured)
- **Route guards** for authentication
- **Bottom navigation** with persistent state

### Authentication
- **Role-based access** (Artist/Fan)
- **Session management** with SharedPreferences
- **Protected routes** with redirect logic

### Theme
- **Material Design 3** custom dark theme
- **Consistent color palette** with brand colors
- **Responsive typography** scale
- **Reusable component styles**

---

## 🎨 Design Highlights

- **Dark Theme**: Sleek, modern dark interface optimized for media consumption
- **Brand Colors**: Purple accent (#9C27B0) with deep backgrounds (#0F0F0F)
- **Typography**: Roboto font family with clear hierarchy
- **Responsive**: Adapts to various screen sizes and orientations
- **Accessibility**: High contrast ratios and readable text sizes

---

## 🗺️ Roadmap

### Backend Integration
- [ ] Replace mock data service with real API
- [ ] Implement JWT authentication
- [ ] Real-time messaging with WebSockets
- [ ] Cloud storage for media files

### Payment & Commerce
- [ ] Stripe integration for merch purchases
- [ ] Digital content purchases (albums, singles)
- [ ] Artist revenue dashboard

### Enhanced Features
- [ ] Push notifications for new releases and messages
- [ ] Social features (likes, comments, shares)
- [ ] Advanced search and discovery
- [ ] Offline mode with local caching
- [ ] Analytics for artists

### Platform Expansion
- [ ] Desktop apps (Windows, macOS, Linux)
- [ ] Web app optimization
- [ ] Smart TV support

---

## 👨‍💻 Developer

**Created by**: **Saim**

Built with Flutter & Dart as a comprehensive solution for modern music and entertainment platforms.

---

## 📄 License

This project is currently private. License information will be added in future releases.

---

## 🤝 Contributing

This is currently a solo project. Contribution guidelines will be established as the project evolves.

---

## 📧 Contact

For questions or feedback about Audiva, please reach out through GitHub.

---

<div align="center">

**Audiva** - Connecting Artists and Fans Through Music 🎵

Made with ❤️ using Flutter

</div>

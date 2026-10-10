# Tailor — Offline Tailoring Shop Management

An Android-first Flutter application for managing a tailoring shop.
Designed to work fully offline with local SQLite storage.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Material 3) |
| State | flutter_riverpod |
| Database | Drift + SQLite (via drift_flutter) |
| Platform | Android-first, iOS-ready |

## Prerequisites

- **Flutter SDK** ≥ 3.32 (stable channel)
- **Android Studio** or **VS Code** with Flutter extension
- **Android SDK** (API 21+) for Android builds
- **Xcode** (optional, for iOS builds)

## Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# 3. Run on a connected device or emulator
flutter run

# 4. Verify code quality
dart format --set-exit-if-changed lib/
flutter analyze
```

## Project Structure

```
lib/
├── main.dart                     # Entry point
├── app/
│   ├── tailor_app.dart           # MaterialApp root
│   ├── app_shell.dart            # Responsive navigation shell
│   └── more_screen.dart          # "More" tab with secondary features
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Brand colour palette
│   │   ├── app_spacing.dart      # Spacing and sizing tokens
│   │   └── app_theme.dart        # Material 3 theme configuration
│   ├── widgets/
│   │   ├── empty_state.dart      # Reusable empty state component
│   │   ├── section_header.dart   # Section title with action
│   │   ├── status_badge.dart     # Status indicator badge
│   │   └── summary_card.dart     # Metric card widget
│   └── database/
│       ├── app_database.dart     # Drift database definition
│       └── database_provider.dart # Riverpod database provider
└── features/
    ├── dashboard/                # Home dashboard with overview
    ├── orders/                   # Orders list + new order placeholder
    ├── customers/                # Customer list (empty state)
    ├── measurements/             # Measurements (empty state)
    ├── karigars/                 # Karigars (empty state)
    ├── reports/                  # Reports (empty state)
    └── settings/                 # Settings + Backup/Restore (empty state)
```

## Offline-First Design

- **No internet required** at any point
- All data persisted locally in SQLite via Drift
- No Firebase, cloud database, or remote API dependencies
- System fonts used — no Google Fonts download on first launch

## Currency

All monetary amounts are displayed in **PKR** (Pakistani Rupees).

## Current Status

See [PROJECT_STATUS.md](PROJECT_STATUS.md) for completed work and next steps.

# Agent Rules — Tailor App

## Stack

| Layer | Technology | Notes |
|---|---|---|
| Framework | Flutter 3.32+ | Material 3, Material Design components |
| Language | Dart 3.8+ | Null-safe, sound |
| State | flutter_riverpod 3.x | Provider-based reactive state |
| Database | Drift 2.x + drift_flutter | SQLite, code-generated, reactive |
| Platform | Android-first | iOS-compatible structure |

## Architecture

- **Feature-based** folder structure under `lib/features/`
- **Core** shared code under `lib/core/` (theme, widgets, database)
- **Separation**: UI (screens/widgets), data (Drift tables/DAOs), logic (providers/notifiers)
- **No unnecessary abstraction** — simple is better

## Offline Requirements

- **MUST NOT** require internet at any point during normal usage
- **MUST NOT** depend on Firebase, Supabase, or any cloud service
- **MUST NOT** use Google Fonts (bundled or system fonts only)
- All business data in SQLite via Drift — no shared_preferences for structured data
- shared_preferences acceptable only for simple app settings (theme, language)

## Design Rules

### Colour Palette
- Background: `#F7F5F0` (warm ivory)
- Surface: `#FFFFFF` (white cards)
- Text: `#202824` (charcoal)
- Primary: `#176B50` (deep emerald)
- Accent: `#B88B45` (muted gold, used sparingly)
- Border: `#E2E0DB`

### Styling
- Rounded corners: 12–16px
- Subtle single-pixel borders on cards, no heavy shadows
- No gradients or excessive decoration
- Consistent spacing tokens from `AppSpacing`
- Use `StatusBadge` for order/delivery status indicators
- Use `SummaryCard` for dashboard metrics
- Use `EmptyState` for screens without data

### Typography
- System font (`.AppleSystemUIFont` / Roboto on Android)
- Clear hierarchy: headlineLarge → labelSmall
- Text scaling and accessible contrast required

### Accessibility
- Minimum 48dp touch targets
- Sufficient colour contrast (WCAG AA)
- Support text scaling
- Meaningful labels on interactive elements

### Currency
- Format as `PKR X,XXX` — no decimal places
- Use `intl` package `NumberFormat` for formatting

## Navigation

### Phone (width < 600dp)
Bottom NavigationBar: Home, Orders, Customers, More

### Tablet (width ≥ 600dp)
NavigationRail with the same destinations

### More Screen
Links to: Karigars, Reports, Backup & Restore, Settings

## Database

- Drift with `drift_flutter` for cross-platform SQLite
- Generated code via `dart run build_runner build --delete-conflicting-outputs`
- Schema version tracked in `AppDatabase.schemaVersion`
- Migration strategy prepared in `MigrationStrategy`
- Single database instance via Riverpod provider

## Verification Commands

```bash
# Format check
dart format --set-exit-if-changed lib/

# Static analysis
flutter analyze

# Run tests
flutter test

# Generate Drift code
dart run build_runner build --delete-conflicting-outputs

# Run on device
flutter run
```

## Stage Tracking

See [PROJECT_STATUS.md](PROJECT_STATUS.md) for current status and next steps.

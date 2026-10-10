# Project Status

## Current Stage: 2 — Customer CRUD (automated verification complete)

### Completed

- [x] Flutter app source structure with correct pubspec.yaml
- [x] Material 3 theme with tailoring brand palette
- [x] System fonts for guaranteed offline first launch
- [x] Responsive navigation: BottomNavigationBar (phone) + NavigationRail (tablet)
- [x] Dashboard screen with:
  - Shop name and current date
  - Prominent "New Order" action button
  - Summary cards: Active Orders, Due Today, Overdue, Outstanding Balance (PKR)
  - Upcoming deliveries with customer, garment, due date, status badge
  - Quick actions: Add Customer, Measurements
  - Demo data notice banner
- [x] Reusable design system widgets:
  - StatusBadge (Pending, In Progress, Ready, Overdue)
  - SummaryCard (metric with icon)
  - EmptyState (icon + title + subtitle + optional action)
  - SectionHeader (title with optional action)
- [x] Empty state screens for: Orders, Customers, Karigars, Reports, Backup & Restore, Settings
- [x] New Order placeholder screen (clearly labelled)
- [x] Drift database infrastructure with AppSettings table and migration strategy
- [x] Riverpod database provider
- [x] Documentation: README.md, AGENTS.md, PROJECT_STATUS.md

### Stage 2 Implemented

- [x] Drift `Customers` table with a version 1 → 2 migration
- [x] `CustomersDao` create, read, update, delete, and reactive watch methods
- [x] Reactive Riverpod customer providers
- [x] Customer list with name/phone search and sort controls
- [x] Add/edit customer form with validation
- [x] Customer detail and confirmed delete flow
- [x] Dashboard Add Customer quick action
- [x] DAO, migration, persistence, form, search, and sorting tests

### Current Limitations

- Dashboard displays hardcoded demo data (clearly labelled, not persisted)
- Orders, measurements, and payments do not have database tables yet
- New Order flow is a placeholder screen
- Measurements remains an empty-state screen
- Settings and Backup features are empty states
- No Android SDK, Android emulator, or complete Xcode/iOS simulator is available, so mobile launch and manual offline verification remain pending
- The downloaded Flutter SDK works at `/Users/zoraiz/Desktop/develop/flutter`, but its `bin` directory is not yet persisted on the shell `PATH`

### Toolchain

- Flutter 3.47.7 stable
- Dart 3.13.5
- Generated Android and iOS runners retain Flutter's placeholder `com.example.tailor` identifiers; production signing and identifiers are intentionally not configured
- Web runner generated for local Chrome development previews; Android remains the primary production target

---

## Tooling and Verification Report — 10 October 2026

### Completed

- [x] `flutter --version` — Flutter 3.47.7 stable, Dart 3.13.5
- [x] `flutter doctor -v` — Flutter and Chrome healthy; Android SDK absent; Xcode incomplete; CocoaPods absent
- [x] `flutter create --platforms=android,ios --no-pub .` — generated 70 runner files
- [x] Confirmed checksums for all pre-existing Dart, test, configuration, and documentation files were unchanged by scaffolding
- [x] Removed only Flutter's incompatible generated counter-template test
- [x] `flutter pub get` — resolved successfully; lockfile created
- [x] `dart run build_runner build --delete-conflicting-outputs` — succeeded; current build_runner warns that the delete option is removed and ignored
- [x] Generated `app_database.g.dart` and `customers_dao.g.dart` match the declared `AppSettings` and `Customers` tables and customer DAO
- [x] `dart format --set-exit-if-changed lib test` — 31 files checked, zero changes
- [x] `flutter analyze` — no issues found
- [x] `flutter test` — 11 tests passed
- [x] v1-to-v2 migration test creates the actual v1 `AppSettings` schema, retains its data, creates `Customers`, and advances `user_version` to 2
- [x] File-backed persistence test confirms a customer survives database close and reopen
- [x] Automated checks cover create, edit, validation/no insert, name and phone search, name sorting, reactive reads, and deletion
- [x] `flutter devices` and `flutter emulators` checked

### Manual Verification Pending

- [ ] Launch on Android emulator/device after installing or configuring the Android SDK
- [ ] Launch on iOS simulator/device after completing Xcode setup (and CocoaPods if required)
- [ ] Exercise customer create, edit, search, sort, delete, and relaunch persistence with networking disabled

No Android emulator or iOS simulator source is configured, so mobile launch remains pending.

### Chrome Development Preview

- [x] `flutter create --platforms=web --no-pub .` — web runner generated; pre-existing source and test checksums preserved
- [x] Removed Flutter's incompatible generated counter-template test
- [x] `flutter run -d chrome` — compiled, connected to the Chrome debug service, and started successfully
- [x] Relaunched through `flutter run -d web-server --web-port=7357` and opened `http://localhost:7357` in Chrome for a stable local preview URL
- [x] No startup exceptions were reported by the Flutter runtime

`flutter build bundle` was attempted as a device-independent compile check, but Flutter selected the Android native-asset target and stopped with `Android SDK could not be found`. This is an environment blocker, not a passing build.

### Next Step

Configure an Android SDK/emulator (preferred for this Android-first app) or complete Xcode and start an iOS simulator. Finish the three manual checks above. After that, Stage 3 is the measurements module linked to customers.

### Future Stages (Outline)

- **Stage 3**: Measurements module linked to customers
- **Stage 4**: Orders module with status workflow
- **Stage 5**: Karigars module with order assignment
- **Stage 6**: Payments and outstanding balance tracking
- **Stage 7**: Reports and analytics
- **Stage 8**: Backup/restore and settings

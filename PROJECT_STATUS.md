# Project Status

## Current Stage: 7 — UI Polish and Offline Acceptance (automated verification complete; device acceptance pending)

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
  - Live Drift-backed metrics and upcoming deliveries
- [x] Reusable design system widgets:
  - StatusBadge (Pending, In Progress, Ready, Overdue)
  - SummaryCard (metric with icon)
  - EmptyState (icon + title + subtitle + optional action)
  - SectionHeader (title with optional action)
- [x] Empty state screens for: Orders, Customers, Karigars, Reports, Backup & Restore, Settings
- [x] Complete New Order workflow
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

### Stage 3 Implemented

- [x] Schema version 3 migration preserving existing settings and customers
- [x] Customer-linked measurement profiles with restrictive foreign keys
- [x] Immutable measurement revisions created in local database transactions
- [x] Complete revision snapshots prepared for future order references
- [x] Central provisional templates for Shalwar Qameez, Coat, Trouser, Shirt, Waistcoat, and Jacket
- [x] Inches and centimetres stored explicitly with decimal values preserved
- [x] Explicit body versus finished-garment measurement basis
- [x] Regular, slim, and loose fit preferences
- [x] Customer detail measurement list, Add Measurements, and View History actions
- [x] Measurement create/revision form with garment-specific fields, validation, unit suffixes, style instructions, and notes
- [x] Measurement detail view with grouped values and accessible revision history
- [x] Customer selector reachable from the dashboard Measurements quick action
- [x] Customer deletion blocked when measurement history exists; no silent cascade deletion
- [x] DAO, migration, relationship, revision, decimal/unit, and form validation tests

### Stage 4 Implemented

- [x] Schema version 4 migration adds orders, garment lines, and an append-only payment/refund ledger while preserving customers and measurement revisions
- [x] Human-readable unique order numbers and duplicate-submission keys
- [x] Atomic order, garment snapshot, and initial-advance creation transaction
- [x] Multiple garment lines with shared quantity, selected immutable measurement revision, frozen measurement snapshot, style instructions, and charge breakdown
- [x] Integer-paisa business calculations for stitching, cloth, additional charges, totals, net paid, and balance
- [x] Cash and manually recorded bank-transfer payments; bank transfers are clearly labelled unverified
- [x] Excess-payment and excess-refund rejection
- [x] Per-garment status with derived order progress and partial delivery
- [x] Cancellation preserves history, blocks delivered orders, and requires received money to be explicitly refunded first
- [x] Searchable customer selection, multiple-line form, historical revision selection, review confirmation, validation retention, and duplicate-tap guard
- [x] Orders search and Active, Overdue, and Outstanding filters
- [x] Order detail with frozen measurements, full charges, ledger, balance, garment progress, outstanding-balance delivery confirmation, and editable delivery date/notes
- [x] Customer detail New Order action and order history
- [x] Live dashboard metrics with cancelled orders excluded
- [x] Migration, atomicity, snapshot, exact-money, ledger, duplicate-submit, cancellation, partial-delivery, relationship, and form-validation tests

### Stage 5 Implemented

- [x] Schema version 5 migration adds karigars and append-only assignment history while preserving earlier business data
- [x] Karigar create, edit, search, active/inactive filtering, detail, workload, and work-history views
- [x] Safe deactivation blocked while work is active; workers with assignment history cannot be deleted
- [x] Active-karigar selection for individual order garment items
- [x] Optional internal deadlines and work instructions, with warnings when a deadline exceeds customer delivery
- [x] Assignment, reassignment with a required reason, start-work, completion/ready, and alteration-return flows
- [x] Assignment changes update garment progress atomically and preserve historical assignment rows
- [x] Order cancellation closes active assignments without deleting work history
- [x] Dashboard workshop metrics for unassigned garment items and overdue internal deadlines
- [x] Karigar quick access from the dashboard and full management access from More
- [x] DAO coverage for CRUD, lifecycle transitions, reassignment history, inactive-worker enforcement, alteration returns, and order-cancellation cleanup

### Stage 6 Implemented

- [x] Drift-backed shop name, address, phone, and receipt-footer settings
- [x] Offline customer receipts with order, customer, garment, charge, payment, balance, cancellation, and manual-transfer details
- [x] Financially private karigar work slips with frozen measurement snapshots, instructions, notes, worker, quantity, and deadline
- [x] Combined customer/karigar PDFs, including a compact single-page layout for simple one-item orders and automatic pagination for larger orders
- [x] Bundled Roboto fonts, repeated document headers/footers, A4 output, native preview/print, and platform-appropriate PDF export
- [x] Versioned `.tailorbackup` ZIP archives with a manifest, database size and SHA-256 integrity metadata, and an attachment manifest prepared for future files
- [x] Consistent SQLite backup snapshots, strict archive/path/schema validation, database integrity checks, and older compatible-schema migration
- [x] Confirmed destructive restore flow with a safety backup and recoverable same-directory database replacement
- [x] Explicit web limitations: PDF generation/export remains available, while offline raster preview, system printing, backup, and restore are not offered
- [x] Automated document-content, backup/restore, corrupt-backup, schema-migration, and shop-settings tests

### Stage 7 Implemented

- [x] Consistent Material 3 form fields, buttons, dialogs, floating actions, snackbars, cards, and 48dp interactive targets
- [x] Responsive dashboard metric layout, clearer retryable dashboard errors, and configured shop name on the dashboard
- [x] More prominent order balance treatment and understandable status, cancellation, and ledger failure feedback
- [x] Large-text-safe measurement selectors and measurement value rows
- [x] Unsaved-change confirmation on customer, measurement, order, karigar, and shop-settings forms
- [x] Failed shop-setting saves preserve input and show an understandable message
- [x] Bundled Drift WebAssembly and worker assets with an explicit offline web database connection
- [x] TailorDesk naming and brand colours applied to Android, iOS, and web application metadata
- [x] Disposable-database acceptance test covering the complete order lifecycle, snapshot immutability, payments, partial delivery, assignment history, cancellation cleanup, and dashboard totals
- [x] Practical client walkthrough and approval questions in `CLIENT_REVIEW.md`

### Current Limitations

- Reports remains an empty state
- Backup archives are intentionally unencrypted; users must store shared copies securely
- The app currently has no attachment feature, so Stage 6 archives contain an empty attachment manifest
- Web supports PDF generation/export but not offline raster preview or system printing; backup and restore are unavailable on web
- Web business records now use locally bundled SQLite WebAssembly and browser IndexedDB storage; browser testing does not prove Android behavior
- Direct Bluetooth/USB thermal-printer integration is out of scope; native printing uses the platform print dialog
- The Android SDK toolchain now builds a verified debug APK, but no Android device or emulator is connected, so Stage 3–7 mobile runtime and offline verification remain pending
- Xcode is incomplete and CocoaPods is absent, so iOS launch is pending
- The downloaded Flutter SDK works at `/Users/zoraiz/Desktop/develop/flutter`, but its `bin` directory is not yet persisted on the shell `PATH`

### Toolchain

- Flutter 3.47.7 stable
- Dart 3.13.5
- Generated Android and iOS runners retain Flutter's placeholder `com.example.tailor` identifiers; production signing and identifiers are intentionally not configured
- Web runner generated for local Chrome development previews; Android remains the primary production target
- Android SDK 36.0.0, platform android-37.0, and accepted licenses detected

---

## Tooling and Verification Report — 10 October 2026

### Completed

- [x] `flutter --version` — Flutter 3.47.7 stable, Dart 3.13.5
- [x] `flutter doctor -v` — Flutter, Android toolchain, and Chrome healthy; Xcode incomplete; CocoaPods absent
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

- [ ] Resolve the `Medium_Phone_API_37.0` AVD startup/connection issue and launch on Android
- [ ] Launch on iOS simulator/device after completing Xcode setup (and CocoaPods if required)
- [ ] Exercise measurement create, edit/revision, history, and protected customer deletion on a device
- [ ] Restart the device app and confirm customer and measurement persistence
- [ ] Repeat the measurement flow in airplane mode

`flutter emulators` lists `Medium_Phone_API_37.0`, but launching it produced no connected Android device. The app was not run during Stage 3, so no runtime or offline claim is made.

### Chrome Development Preview

- [x] `flutter create --platforms=web --no-pub .` — web runner generated; pre-existing source and test checksums preserved
- [x] Removed Flutter's incompatible generated counter-template test
- [x] `flutter run -d chrome` — compiled, connected to the Chrome debug service, and started successfully
- [x] Relaunched through `flutter run -d web-server --web-port=7357` and opened `http://localhost:7357` in Chrome for a stable local preview URL
- [x] No startup exceptions were reported by the Flutter runtime

Before the Android SDK was configured, `flutter build bundle` failed with `Android SDK could not be found`. That historical failure is not counted as a current Stage 3 build result.

### Next Step

Resolve the Android AVD connection and complete the Stage 3 measurement manual checks together with the Stage 4 order checks documented below.

---

## Stage 3 Verification Report — 10 October 2026

### Foundation Before Stage 3

- [x] `flutter pub get` — passed
- [x] `dart run build_runner build --delete-conflicting-outputs` — generated state current; build_runner 2.16.2 warns that the delete option is removed and ignored
- [x] `flutter analyze` — no issues
- [x] `flutter test` — all existing 11 Stage 1–2 tests passed

### Final Stage 3 Checks

- [x] Drift code generated for `MeasurementProfiles`, `MeasurementRevisions`, and both DAOs
- [x] `dart format --set-exit-if-changed lib test` — 42 files checked, zero changes
- [x] `flutter analyze` — no issues
- [x] `flutter test` — all 19 tests passed
- [x] v2-to-v3 migration test recreated the actual previous customer schema and preserved its customer row
- [x] Tests cover creation/retrieval, immutable revisions, customer relationships, safe deletion, decimals, units, positive values, required fields, and no-insert validation failures

### Provisional Measurement Decisions

- Templates and required/optional flags are centralized in `measurement_templates.dart` and require working-tailor approval before production use.
- Required fields cover the core dimensions in each supplied garment list; collar, cuff, hip on outer garments, and trouser detail/opening fields are currently optional.
- Every revision declares either body measurements or finished-garment measurements. The app does not treat them as interchangeable.
- No ease, seam allowance, sizing formula, or automatic unit/basis conversion is applied.
- Changing garment, unit, or basis while creating a profile requires confirmation and clears entered values. Existing profiles keep those attributes fixed; a separate profile is required to change them.
- Profile rows provide stable identity and created/updated timestamps. Revision rows are immutable complete snapshots suitable for a future order foreign key or snapshot copy.
- Profiles and revision history have no destructive UI in Stage 3. Customers with profiles cannot be deleted.

### Future Stages (Outline)

- Reports and analytics remain outside the completed Stage 7 scope and require a separately approved stage.

---

## Stage 4 Verification Report — 10 October 2026

### Foundation Before Stage 4

- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter pub get` — passed
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/dart run build_runner build --delete-conflicting-outputs` — passed; build_runner 2.16.2 reports that the option has been removed and is ignored
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter analyze` — no issues
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter test` — all existing 19 Stage 1–3 tests passed

### Final Stage 4 Checks

- [x] Drift generation completed with schema version 4 and current generated files
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/dart format --set-exit-if-changed lib test` — 51 files checked, zero changes
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter analyze` — no issues found
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter test` — all 28 tests passed
- [x] v3-to-v4 migration test recreated the previous customer and measurement schema and preserved both records
- [x] Tests cover multiple lines and quantity, exact integer money, frozen snapshots, payments/refunds, excess rejection, duplicate submission, atomic rollback, cancellation, partial delivery/derived status, and invalid-form retention
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter devices` — macOS and Chrome detected; no connected Android or iOS device

### Stage 4 Business Decisions

- All money is stored as integer paisa. The UI accepts whole PKR because the project currency rule displays no decimal places.
- A line total is `(quantity × stitching per piece) + cloth line charge + additional line charge`.
- An order total includes non-cancelled lines only. Net paid is payments minus refunds; balance is total minus net paid.
- Bank transfers are manual ledger records and are never presented as electronically verified.
- Order lines retain both the selected revision foreign key and a complete frozen copy of its values, unit, basis, fit, notes, and instructions.
- Booked financial line data is read-only. Only order notes, delivery date, item progress, and append-only ledger entries can change.
- Cancelling a whole order cancels its active lines, keeps all history, blocks delivered orders, and requires net paid to reach zero through explicit refunds first.

### Manual Verification Pending

- [ ] Launch Stage 4 on an Android emulator or physical Android device
- [ ] Create and progress a multi-line order through delivery
- [ ] Close and reopen the mobile app and confirm order, snapshot, and payment persistence
- [ ] Repeat order creation and payment recording in airplane mode
- [ ] Confirm responsive layouts and touch behavior on phone and tablet-sized devices

No Stage 4 runtime or airplane-mode claim is made. Automated checks pass, but no supported mobile device was connected.

### Next Step

This historical Stage 4 next step was completed in the Stage 5 report below. Android manual checks remain pending.

---

## Stage 5 Verification Report — 10 October 2026

### Foundation Before Stage 5

- [x] Stage 4 order and payment implementation was present with all 28 tests passing
- [x] Partial Stage 5 schema, DAO, providers, list UI, and dashboard-query work was recovered and completed

### Final Stage 5 Checks

- [x] Drift generation completed for schema version 5, `Karigars`, `KarigarAssignments`, and both affected DAOs
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/dart format --set-exit-if-changed lib test` — passed
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter analyze` — no issues found
- [x] `/Users/zoraiz/Desktop/develop/flutter/bin/flutter test` — all 33 tests passed
- [x] Existing v1, v2, and v3 migration tests now verify migration through schema version 5
- [x] New tests cover karigar CRUD, lifecycle transitions, reassignment history, inactive-worker enforcement, alteration returns, and cancellation cleanup

### Stage 5 Business Decisions

- Assignments belong to individual garment lines, not an entire order, so multi-garment orders can be split between workers.
- Only active karigars can receive new work. A karigar with active work cannot be deactivated; any karigar with assignment history cannot be deleted.
- Reassignment closes the previous active row and creates a new row. The prior row and reassignment reason remain available in history.
- Starting work moves the garment to In Progress. Completing work moves it to Ready. Returning completed work for alteration creates a fresh In Progress assignment to the same karigar.
- Internal deadlines are optional and independent of the customer delivery date. Dates after customer delivery are visibly warned but not blocked.
- Cancelling an order also closes its active assignments in the same local database transaction.

### Manual Verification Pending

- [ ] Launch Stage 5 on an Android emulator or physical Android device
- [ ] Create, edit, deactivate, and reactivate a karigar
- [ ] Assign two garments to different karigars, progress both, and verify order status changes
- [ ] Reassign one garment and confirm its original assignment remains in history
- [ ] Return ready work for alteration and confirm it reopens as In Progress
- [ ] Restart in airplane mode and confirm karigars, assignments, deadlines, and history persist
- [ ] Confirm phone and tablet layouts, text scaling, and 48dp touch targets on device

No Stage 5 mobile runtime or airplane-mode claim is made. Automated checks pass, but no supported mobile device was connected.

### Next Step

This historical Stage 5 next step was superseded by the Stage 6 documents-and-backup work below. Stage 3–5 Android manual checks remain pending alongside the Stage 6 device checks.

---

## Stage 6 Verification Report — 10 October 2026

### Final Stage 6 Checks

- [x] `flutter pub get` — resolved the PDF, printing, file-selection, sharing, archive, hashing, and SQLite dependencies
- [x] `dart run build_runner build --delete-conflicting-outputs` — generated Drift state successfully; build_runner reports that the delete option is removed and ignored
- [x] `dart format --set-exit-if-changed lib test tool` — passed with zero formatting changes
- [x] `flutter analyze` — no issues found
- [x] `flutter test` — all 42 tests passed
- [x] `flutter build web` — succeeded, proving conditional native backup imports and the web document flow compile
- [x] Generated and visually inspected four representative A4 PDFs: a receipt, compact combined document, four-page long order, and a second-worker slip
- [x] Poppler inspection confirmed embedded/subset Roboto fonts, expected page counts, repeated long-document headers/footers, and extractable document text
- [x] `flutter build apk --debug -v` — succeeded after installing NDK `28.2.13676358` (r28c), CMake 3.22.1, and complete Android SDK platforms 34–36; produced `build/app/outputs/flutter-apk/app-debug.apk`

### Stage 6 Business and Security Decisions

- Customer receipts are order/payment records, not tax invoices. Cancelled garment lines remain visible and are excluded from totals.
- Manually recorded bank transfers are labelled unverified. Money continues to use the order ledger's integer-paisa calculations and whole-PKR display.
- Work slips deliberately omit all prices, payments, totals, and balances. Each slip uses the order's frozen measurement snapshot, so later customer revisions cannot change issued work.
- Native desktop export uses a save chooser; native mobile export uses the platform share sheet. Native system printing uses the platform print dialog and reports cancellation or errors.
- Web generation and download remain available without relying on an online font. Offline raster preview is disabled because the web printing preview normally requires a separately loaded PDF.js runtime.
- Backups use a versioned ZIP container with a JSON manifest and SHA-256 database checksum. Archives are not encrypted.
- Restore never merges records. It validates before confirmation, creates a safety snapshot, closes the active database, validates/migrates a temporary replacement, and uses recoverable same-directory renames.
- Backups newer than the app schema are rejected. Older compatible schemas are migrated before becoming active.

### Supported Stage 6 Paths

- Android/iOS/macOS/Windows/Linux: PDF generation, native preview/print, and PDF export; backup and restore through native file APIs
- Desktop: explicit save-file destination for exports
- Mobile: platform share sheet for backup and PDF export
- Web: PDF generation/export only; no backup/restore, offline raster preview, or system print action

### Manual Verification Pending

- [x] Complete Android toolchain bootstrap and produce a debug APK
- [ ] Preview, save/share, and print every document type on a physical Android device
- [ ] Verify mobile backup export and restore file access, including cancellation and invalid-file feedback
- [ ] Repeat document generation and backup/restore in airplane mode
- [ ] Confirm phone/tablet layout, text scaling, and native print-dialog behavior
- [ ] Launch on iOS after Xcode and CocoaPods setup is complete

No physical printing, mobile file-access, device restore, or airplane-mode claim is made. Stage 6 implementation and automated verification are complete; the remaining work is device-specific manual verification.

---

## Stage 7 Verification Report — 11 October 2026

### Stage 6 Re-verification

- [x] Confirmed receipt, karigar slip, combined-document, shop-settings, backup, and restore implementations are present
- [x] Stage 6 document/settings/backup tests passed: 9 tests
- [x] Existing receipt samples and backup validation tests remain part of the repository

### UI and Runtime Review

- [x] Launched the app in a configured browser and visually inspected the wide-layout dashboard
- [x] The first browser review exposed a real dashboard database error; root cause was a missing Drift web connection configuration
- [x] Added locally bundled `sqlite3.wasm` and `drift_worker.js`; no runtime network download is required
- [x] Flutter-managed Chrome started successfully and reported local `WasmStorageImplementation.sharedIndexedDb` storage
- [x] `flutter build web` succeeded with the database assets included
- [x] Headless Chrome screenshots confirmed the ivory, charcoal, emerald, navigation-rail, dashboard-action, loading, and retry states render without clipping at a 756×501 viewport
- [ ] A runtime visual traversal of every main screen was not completed because the available browser-control surface stopped exposing Flutter canvas interactions reliably; code-level review covered the remaining screens
- [ ] Android runtime screenshots were not captured because both configured emulators failed to appear as connected Flutter devices

### Workflow and Failure Verification

- [x] Added an isolated in-memory acceptance workflow that creates a customer and measurements, books two garment lines with an advance, revises measurements, assigns and reassigns work, starts and completes work, settles payment, partially delivers, fully delivers, cancels a separate assigned order, and checks dashboard totals
- [x] The acceptance workflow confirms later measurement revisions do not alter booked snapshots, exact integer-paisa totals remain accurate, reassignment history is preserved, and cancellation closes active assignments
- [x] Existing tests continue to cover duplicate order submission, atomic rollback, invalid backup safety, backup/restore round trips, excess payments/refunds, and failed form validation retaining input
- [x] Added a widget test proving unsaved edits require explicit discard confirmation
- [x] Customer, measurement, order, and karigar save actions retain their existing in-flight guards; ledger saves are guarded and now report invalid values and database failures
- [x] Cancelled/failed backup and PDF exports do not report success; invalid backup validation occurs before active data replacement

### Validation Results

- [x] `dart format --set-exit-if-changed lib test tool` — passed
- [x] `flutter analyze` — no issues found
- [x] `flutter test` — all 44 tests passed
- [x] `flutter build web` — succeeded
- [x] `flutter build apk --debug -v` — succeeded (`BUILD SUCCESSFUL`); verified the 165 MB APK exists at `build/app/outputs/flutter-apk/app-debug.apk`, is signed with the Android debug certificate using APK Signature Scheme v2, and has SHA-256 `966ed7c2f516f431a5f13682491a3ad73566919097b9e279382120ca7adcd383`
- [x] `git diff --check` — passed

### Device and Client Acceptance Pending

- [ ] Connect or repair an Android emulator/device and cold-start the app with connectivity disabled
- [ ] Perform the complete customer, measurement, order, payment, assignment, document, backup, restore, restart, and persistence workflow on Android
- [ ] Verify phone and tablet layouts, keyboard avoidance, scroll visibility, and large system text on physical/device-sized screens
- [ ] Test native file pickers, share targets, cancelled exports, and restore failure messages
- [ ] Print receipts and karigar slips on the client’s actual printer and confirm paper sizing and legibility
- [ ] Obtain working-tailor approval for every garment template, required/optional field, unit, body/finished-garment basis, and fit choice
- [ ] Obtain client approval for charge labels, receipt/work-slip wording, booking speed, and backup instructions using `CLIENT_REVIEW.md`

TailorDesk is ready for structured client review, not production deployment. Android offline runtime, persistence, file access, restore, and physical printer evidence remain mandatory.

### Exact Commands

```bash
cd /Users/zoraiz/Desktop/Tailor
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed lib test tool
flutter analyze
flutter test
flutter devices
flutter emulators
flutter run -d <android-device-id>
flutter build apk --debug
flutter build web
```

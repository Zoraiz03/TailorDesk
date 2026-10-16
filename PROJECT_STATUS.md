# TailorDesk project status

## Current stage: private Android preview prepared

Status as of **14 October 2026**: a private, non-production Android preview has been built and verified on the Android emulator. It has not been published and is not production-ready. Physical-phone file handling and physical printing remain pending.

## Licensing-removal audit

- Startup, setup, forms, DAOs, backup/restore and settings contain no activation or entitlement gate. The app opens directly to setup or the dashboard.
- The old licensing feature, issuer, activation tests, secure-storage/cryptography dependencies, native activation channel and business-write policy were removed. A source/config/dependency search found no activation or licensing implementation. `showLicensePage` remains only for third-party open-source notices.
- Drift remains at schema version **7**. Existing migrations were retained, and migration/backup/workflow tests pass. No emulator records were cleared; the existing delivered order survived the update and offline restart.
- Tester and release guidance now says that no activation is required. Licensing must not be reintroduced for this preview phase.

## Acceptance matrix

| Area | Status | Evidence / remaining scope |
|---|---|---|
| Customers | Pass | DAO/widget tests; customer created and reopened on emulator |
| Measurements | Pass | DAO/widget/migration tests; saved profile reused by emulator orders |
| Orders | Pass | Workflow/DAO tests; complete order `ORD-20261014-0001` delivered, and `ORD-20261014-0002` saved by the exact APK offline |
| Payments | Pass | Exact integer-paisa/refund tests; first emulator order settled to balance PKR 0 |
| Karigars | Pass | DAO and full acceptance-workflow tests, including assignment and reassignment history |
| Reports | Pass | Report widget/workflow reconciliation tests; emulator dashboard totals updated |
| Receipts / work slips | Pass with physical-printing pending | English, Urdu and bilingual PDFs generated, rendered and visually checked; mixed-script reversal fixed. Bilingual output stacks languages and may use extra pages. No physical printer claim. |
| Backup / restore | Pass with real-phone picker pending | Corruption, migration, atomic restore and isolated round-trip tests pass. Android emulator does not prove real-phone save/share/file-picker behavior. |
| Onboarding | Pass | Fresh/resumable setup tests; emulator setup completed without activation |
| Offline persistence | Pass | Wi-Fi and mobile data both disabled; exact APK saved an order, was force-stopped/reopened, and retained both orders |

## English / Urdu coverage

- English and Urdu ARB files each contain **438 keys** with exact key parity. Language preference persists and the automated RTL switch test passes.
- Main navigation, setup, customers, measurements, orders, payments, karigars, reports, backup/restore, settings, statuses and document labels are localized.
- Urdu and bilingual A4 PDFs were rendered page-by-page. Order IDs, dates, phone numbers, currency, names and Latin instructions remain readable; Urdu is RTL. Bilingual documents deliberately place the two languages on separate lines where mixed shaping would be unsafe.
- Pending: a broad physical-device Urdu review at small screen sizes and large accessibility text. Native Android picker/provider labels may still be supplied by Android in the device language.

## Verification performed

- `dart run build_runner build --delete-conflicting-outputs` — passed; current build runner warns that the option is obsolete and ignores it.
- `flutter gen-l10n` — passed.
- `dart format --set-exit-if-changed lib test tool` — **97 files, 0 changes** on the final run.
- `flutter analyze --no-pub` — **no issues**.
- `flutter test --no-pub` — **64 tests passed**.
- `git diff --check` — passed.
- PDF QA — English, Urdu and bilingual samples generated; all pages rendered and visually inspected after the mixed-direction fix.
- Emulator — `emulator-5554`, Android 17/API 37. Complete customer → measurement → order → advance/final payment → ready → delivery flow passed for `ORD-20261014-0001`. After the final exact APK install, `ORD-20261014-0002` was saved with connectivity disabled, then retained after force-stop/reopen. Connectivity was restored afterward.

## Private preview artifact

| Item | Verified value |
|---|---|
| File | `dist/TailorDesk-Preview-0.9.0-android.apk` |
| Application ID | `dev.tailordesk.preview` |
| Visible name | `TailorDesk Preview` |
| Version | `0.9.0+1` |
| Size | `73,065,169` bytes |
| APK SHA-256 | `200dfe1d8ee8a4720a73ebcb14db08ed2393899ea26271f441aa94fb296734f1` |
| Signing certificate SHA-256 | `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93` |
| Signature | External non-production RSA-2048 key; APK Signature Scheme v2 verified |
| Debuggable | No manifest flag; installed package flags omit `DEBUGGABLE` |

The copied `dist` APK matches the audited Gradle output byte-for-byte. It was installed with `adb install -r`; its separate package preserved the development installation and its own existing preview records. No keystore, private key, passwords, activation material or licensing code was found in the APK inspection.

## Remaining gates

- Real Android phone: Downloads/file-manager install, launcher appearance, system save/share/file picker, backup export and isolated restore, large text, small screen and OEM behavior.
- Actual printer, driver, connection and paper size if printing will be promised.
- Working-tailor approval of measurement templates and business wording.
- Owner-selected production application ID, version policy, protected production signing key, support terms and release approval.

This preview may be shared privately with named testers using `TESTER_GUIDE.md`. Do not publish it or describe it as production-ready.

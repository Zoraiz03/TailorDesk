# Project Status

## Current Stage: 13 — Physical Android Pilot Blocked (Device Required)

Physical pilot acceptance and production approval remain pending; this is not permission to distribute.

### Stage 13 attempt — 13 October 2026, 21:18 PKT

- Read `AGENTS.md`, this status, `RELEASE_GUIDE.md`, and `PILOT_ACCEPTANCE.md`; preserved all existing work.
- `/Users/zoraiz/Library/Android/sdk/platform-tools/adb devices -l` returned only `emulator-5554`, product/model `sdk_gphone16k_arm64`, device `emu64a16k`. Its `ro.kernel.qemu` value is `1`. **No physical Android phone is available to ADB.** Physical model/OS/OEM/screen details cannot be recorded yet.
- Physical results: **0 passed, 0 failed, all pending/not executed**. No emulator results substituted. Download/file-manager install, launcher appearance, activation Download/Share/import, setup and full shop workflow, native PDF save, external backup, offline force-stop/reopen/new records, separate activated-destination restore, and same-signature in-place update all need the phone.
- Actual printer availability/model/connection/paper size remains unknown; compatibility remains pending until tested on that equipment.
- Added exact USB connection/troubleshooting instructions and an isolated two-installation restore/update plan to `PILOT_ACCEPTANCE.md`. Planned Stage 13 IDs are non-production and must be checked unused before installation. Temporary signing/license credentials only; preserve all existing packages and records.
- No builds, installs, license issuance, new keys, restores, data clearing, connectivity changes or publishing occurred. No application code changed and no physical defect could be observed. Analysis/tests were not rerun for this documentation-only attempt; **71 passing tests is Stage 12 evidence**, not a Stage 13 run. `git diff --check` passed after documentation edits.
- **Resume condition:** connect and authorise a physical Android phone, identify the intended test device, and provide on-phone interaction or mirroring. Stage 13 is not complete.

Remaining launch blockers: physical pilot acceptance including secure storage/file flows/restore/update; actual printer acceptance for any promised printing support; working-tailor workflow/template sign-off; owner confirmation of production identity/version/artwork and commercial/support terms; separately protected production Android signing and licensing credentials. License release sequence remains **10**.

### Feature Matrix

| Feature Module | Status | Verification Evidence |
|---|---|---|
| Customers and history | Implemented and verified | Drift v2 migration, `CustomersDao`, `CustomerFormScreen`, search/sort, relationship integrity |
| Garment measurements and revisions | Implemented and verified | Versioned templates, immutable revisions, frozen field labels/units/conventions, positive decimal validation |
| Orders and frozen snapshots | Implemented and verified | Drift v4 migration, `OrdersDao`, frozen measurement snapshots preserved when profiles update |
| Charges, payments, refunds, balances | Implemented and verified | Integer-paisa calculations, append-only payment ledger, excess payment/refund guards |
| Karigar assignments & history | Implemented and verified | Drift v5 migration, `KarigarsDao`, reassignment reason history, deactivation guard |
| Progress, alterations, delivery, cancellation | Implemented and verified | Derived order progress, partial delivery, delivered-order cancellation block, refund requirement |
| Dashboard and live reports | Implemented and verified | Live Drift metrics, 4-tab `ReportsScreen` (Due/Overdue, Balances, Collections, Workload) |
| First-use setup and shop settings | Implemented and verified | Resumable 4-step setup, schema-5 upgrade bypass, shop details/default unit persisted locally |
| Garment catalog and pricing | Implemented and verified | 8 seeded garments, custom templates, enable/reorder, integer-paisa defaults used only for new-line prefills |
| Customer receipts and karigar slips | Implemented and verified | `OrderDocumentService`, bundled Roboto fonts, financial privacy on karigar work slips |
| PDF export and system printing | Implemented and verified | PDF generation, in-app preview, native print dialog, platform share sheet |
| Backup and restore | Implemented and verified | `BackupService`, atomic `VACUUM INTO`, SHA-256 integrity, safety pre-restore backup, rollback |
| Offline activation | Implemented and verified | Strict Ed25519 signed licenses, random secure-store installation identity, release entitlement, read-only recovery |
| Private license issuer | Implemented and verified | Explicit key generation, issue/inspect/renew/replace-device commands, external JSONL ledger |
| Release and update preparation | Implemented and verified | Chrome activation export fixed; external Android signing enforced; isolated same-key APK upgrade preserved activation and records |

### Completed

- [x] All Stage 1–7 foundations and features
- [x] Stage 8 reports reconciled: the required Coat and Jacket templates remain supported; Kurta and Sherwani are retained as additional stable catalog entries
- [x] Resumable first-use setup for shop details, default unit, enabled garments, and optional default prices
- [x] Existing schema-5 installations migrate without record loss and are not forced through setup
- [x] Editable, versioned measurement templates with stable field IDs, explicit body/finished-garment convention, required flags, ordering, and field archiving
- [x] Historical measurement revisions and booked items freeze their field labels, values, units, conventions, and prices
- [x] Stage 9 tables and settings are included automatically in whole-database backup/restore
- [x] Live Reports module with 4 reactive tabs:
  - Orders Due & Overdue (overdue days badge, due today, upcoming deliveries)
  - Outstanding Customer Balances (total outstanding, per-customer breakdown)
  - Payment Collections and Refunds (time filters: Today, 7d, 30d, All Time, Custom; gross payments, refunds, net collections without profit labeling, cash vs bank transfer breakdown, full transaction ledger)
  - Karigar Workload & Pending Work (active workers, unassigned garment lines with quick assign, overdue internal deadlines, per-worker workload cards)
- [x] Dashboard quick-navigation: summary cards directly link to corresponding reports tabs
- [x] 17-step end-to-end shop acceptance test covering customer creation, dual garment measurements, multi-line order booking, advance payment, 2-worker assignment, reassignment with reason, partial delivery with outstanding balance, completion, final payment settlement, receipt/karigar slip generation, measurement revision snapshot immutability, cancellation/refund rules, reports verification, and backup/restore round-trip into an isolated database
- [x] Android emulator runtime verification on `emulator-5554` (API 37)
- [x] Stage 8 Android cold start was observed with Wi-Fi and mobile data disabled; this verifies the observed workflow, not an audit proving zero network requests
- [x] Stage 10 offline activation using an emulator-only signed license, with activation retained across force-stop/relaunch
- [x] Central database write policy blocks business mutations and restore without activation while preserving read-only access and business backup export
- [x] Installation identity and signed activation are stored outside Drift; ordinary business backups cannot copy or replace them
- [x] Owner-only Ed25519 issuer and operating guide cover deliberate key generation, issuance, inspection, renewal, replacement devices, key rotation, custody, and offline limitations
- [x] Stage 11 release guide, production build gates, owner-assisted update checklist, Chrome development activation workflow, APK inspection, and isolated two-version upgrade verification
- [x] Stage 12 original vector branding, adaptive launcher assets, About screen, Android activation-request save action, guarded single-file release configuration, and customer/pilot documentation

### Current Limitations

- Direct Bluetooth/USB thermal-printer integration is out of scope; native printing uses the platform print dialog
- Backup archives are intentionally unencrypted; users must store external copies securely
- Web supports PDF generation/export but not offline raster preview or system printing; backup and restore are unavailable on web
- Provisional garment measurement templates and charge labels require working-tailor sign-off before retail deployment
- Offline licenses cannot remotely revoke an old device or reliably prevent cloning by a privileged attacker
- Production Android and license-signing credentials remain owner-controlled; release signing is configured to require an external keystore and no production secret was generated
- Proposed `com.zoraiz.tailordesk`, `1.0.0`, code `1`, TailorDesk name/artwork, and future license release-sequence policy require owner approval; sequence remains `10`

### Toolchain

- Flutter 3.47.7 stable
- Dart 3.13.5
- Android SDK 36.0.0, platform android-37.0, AVD `Pixel_8` (API 37)
- 71 automated tests passing (0 failures, Stage 12)
- `flutter analyze` clean (0 warnings, 0 errors)
- `dart format` clean (0 changes needed)
- Debug Android and generated iOS runners retain Flutter's placeholder `com.example.tailor`; Android release tasks reject that placeholder and require the owner's permanent ID
- Web runner generated for local Chrome development previews; Android remains the primary production target
- Android SDK 36.0.0, platform android-37.0, and accepted licenses detected

---

## Stage 12 Verification Report — 13 October 2026

### Completed preparation

- Original emerald/ivory spool-and-thread SVG in `assets/branding/tailordesk.svg`; repeatable generator and `preview.png` cover 16/24/32/48/64px and circle, rounded-square, squircle approximation, teardrop masks. Preview inspected: thread and spool remain recognisable, no clipping; 16px naturally loses detail.
- Android legacy density PNGs, adaptive foreground/background (API 26+), and monochrome layer (API 33+) configured. Web/iOS starter icon derivatives also replaced; no iPhone distribution is promised.
- TailorDesk name and brand mark on activation, first-use setup and new **More → About TailorDesk**. About reports actual Android package version/code and unchanged license release sequence **10**. Customer receipt headings remain the shop's name/details; document code was not changed in this stage.
- Android activation Download now uses `ACTION_CREATE_DOCUMENT` through a native channel; previously the desktop save-location API did not provide an Android save workflow. Same canonical request bytes; saved/cancelled/error outcomes covered by mocked-channel widget tests. Copy/Share behavior and licensing rules are preserved.
- `config/production-release.example.json` holds proposed identity/version with confirmation false and empty credentials. `tool/build_customer_release.dart` accepts a single external JSON config; validates acknowledgement of release sequence 10, explicit identity/version, external signing properties, and production-public-key-only documents before invoking release build. Existing Gradle fail-closed signing/trust rules remain. Tests confirm unapproved or credential-less configs cannot start a build.
- Created `CUSTOMER_INSTALLATION_GUIDE.md`, `CUSTOMER_UPDATE_GUIDE.md`, blank owner-only `CUSTOMER_DELIVERY_CHECKLIST.md`, `BUSINESS_POLICY_DRAFT.md`, and `PILOT_ACCEPTANCE.md`. Updated release/licensing/client-review links. No customer details invented or stored in the business database.

### Actual verification

- `dart format --set-exit-if-changed lib test tool`: 99 files, no changes required on final run.
- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: **71 passed**, including 7 new branding/export/release-config checks. Initial new-test harness issues were corrected before the final passing run.
- `git diff --check`: passed. Existing unrelated work preserved.
- Android release build succeeded using existing temporary Stage 11 signing credentials and test licensing trust, not production credentials. Package `dev.tailordesk.stage11test`; version `12.0.0-test`, code `12001`; label **TailorDesk TEST — NOT FOR DISTRIBUTION**.
- Installed with `adb install -r` over isolated test code `11002`, same certificate. First-install timestamp unchanged; installed APK SHA-256 matches the audited build: `741f825eb40492356de01a754738c84525099777b3779ad63442f91e6926555f`.
- Certificate SHA-256: `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93`. Manifest has no debuggable flag (false); installed flags omit DEBUGGABLE; Android backup remains disabled. Five legacy densities, adaptive v26/v33 resources, emerald background, vector foreground and bundled in-app PNG verified. Arm64 AOT contains configured test public map; development key ID/privateKey marker absent. No issuer, keystore or license file bundled.
- Local artifact: `/private/tmp/tailordesk-stage12-NON-PRODUCTION/TailorDesk-12.0.0-test-12001-DO-NOT-DISTRIBUTE.apk`. It is **not for customer delivery**.
- Original `com.example.tailor` remains `0.1.0 (1)` with unchanged last-update time; it was not installed over, cleared, restored or uninstalled. No business migrations or licensing entitlement rules were changed.
- Only the headless `Pixel_8` emulator was connected; no interactive emulator surface or physical phone was available. Installed name/icon resources and static previews were checked, **not live launcher rendering**. Native save-chooser interaction and post-update records/activation UI were not re-executed in Stage 12; Stage 11's earlier upgrade evidence is retained below, not relabelled as new evidence.

### Owner decisions and remaining release gates

- [ ] Confirm proposed production application ID **`com.zoraiz.tailordesk`**, initial customer version **`1.0.0`**, initial production version code **`1`**, working name and original artwork. Development package identity remains unchanged.
- [ ] Keep actual license sequence **10** unless deliberately defining a future entitlement boundary; do not reset it to match version code.
- [ ] Owner creates/protects separate production Android signing keystore and Ed25519 license signing key outside the repository; supply signing properties and explicit production public keys, verify provenance/fingerprints, exclude development roots. No production credentials were generated.
- [ ] Decide prices, support contact/hours, response commitments, refunds, replacement-device charges, included installations and maintenance/custom-work scope. Policy remains a draft.
- [ ] Execute `PILOT_ACCEPTANCE.md` on real isolated Android hardware: fresh activation, native request export/import/cancel, setup, restarts/offline, all shop workflows, PDFs, external backup and non-live restore, same-signature update preserving activation/records, small screens/keyboards/large text, launcher masks/themed icon, actual printer/connection/paper.
- [ ] Preserve application ID/signing identity for updates; never instruct normal uninstall or clearing data. Confirm entitlement and export external backup first.

**Stage 12 stops here.** No publishing, distribution, customer license issuance, production key generation, live restore or business-data clearing occurred.

---

## Stage 11 Verification Report — 13 October 2026 (historical; Stage 12 supersedes artwork/version notes)

### Activation workflow

- [x] Root cause fixed: Chrome clipboard and Web Share calls no longer wait for an asynchronous secure-storage read before invoking the browser API, preserving Chrome's transient user-activation window.
- [x] Copy failures and unsupported Share behavior now produce visible, actionable messages instead of an unhandled failure.
- [x] Added **Download activation request**, which uses a direct browser download of the same canonical bytes accepted by `ActivationRequest.decode` and the private issuer.
- [x] Actual Chrome/macOS run on fixed origin `http://localhost:7357`: **Copy request** placed the 101-byte canonical JSON on the macOS clipboard; `pbpaste` returned the JSON rather than the previous Terminal command.
- [x] **Share request** invoked Chrome/macOS Web Share handling. Dismissing it created no fallback download; Share and Download are now intentionally separate actions.
- [x] Chrome downloaded `tailordesk-activation-request.json`; SHA-256 `a1a4fc73eab4b79096b65cd2af60fcb727c6aa4667425251deff4c7c6a16d5c0`; the issuer parsed that downloaded file and created a temporary test license successfully.
- [x] Development build trusted only the existing `dev-2026-01` public key. A development-only license was issued outside the repository, imported through Chrome, and remained valid after the local server was stopped, restarted on port `7357`, and the page was reloaded. No private material was printed or bundled.

### Identity and release controls

- Current visible name is `TailorDesk`; Android and web icons are Flutter starter artwork; version is `0.1.0+1`; license release sequence remains `10`.
- Debug Android and iOS identities remain `com.example.tailor`. Android release configuration now requires an explicit non-`com.example.*` application ID; no final production ID was guessed.
- Changing the application ID creates a separate installation with separate database, settings, installation identity, and activation. The permanent ID must be selected before customer deployment and preserved for every update.
- Release signing loads an owner-selected properties file and keystore only from absolute paths outside the repository. Release configuration has no debug-signing fallback and fails when signing values are missing.
- Release builds require explicit license public keys and an explicit `production` or opt-in `test` trust mode. Production mode rejects the reserved `dev-*` and `stage11-test*` key IDs; development mode is rejected for release tasks.
- Android app signing and Ed25519 license signing remain separate. `android/release-signing.properties.example` contains placeholders only.

### Non-production release and upgrade verification

All items below used temporary credentials under `/private/tmp/tailordesk-stage11-nonproduction` and package `dev.tailordesk.stage11test`. They are **NON-PRODUCTION — DO NOT DISTRIBUTE**. The existing `com.example.tailor` installation was never cleared, replaced, or uninstalled.

- [x] Built release APK `11.0.1-test` / version code `11001` and `11.0.2-test` / version code `11002` with the same temporary Android signing key.
- [x] Both APKs report application label `TailorDesk TEST — NOT FOR DISTRIBUTION`, package `dev.tailordesk.stage11test`, minimum SDK 24, target SDK 36, and the same signing certificate SHA-256 `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93`.
- [x] APK Signature Scheme v2 verification passed for both upgrade-test artifacts. APK SHA-256 values used for the installed upgrade: v11001 `9716d9ddec30425733f869b94e220e0df510c287626f5489df9e8ca4fa47fb10`; v11002 `907db5863353e25f1724beb862d3d71068efe6c2591cb7871a0540543f5e365b`.
- [x] `android:debuggable` is false and `android:allowBackup` is false. Assets contain the two declared Roboto fonts and Flutter manifests; no `.jks`, keystore, private issuer JSON, ledger, activation request, or license file is bundled.
- [x] AOT inspection found exactly the configured Stage 11 test public-key map. The existing `dev-2026-01` ID/public key and private-key markers were absent.
- [x] Installed v11001, imported a signed test license entitled through release 10, completed setup with shop marker `Stage11UpgradeShop.`, and added customer marker `UpgradeMarkerCustomer / 03001234567`.
- [x] `adb install -r` installed v11002 over v11001. After force-stop/relaunch, activation `STAGE11-NONPRODUCTION-001`, installation ID `inst_Vbf57-ek4IAv2vUVPwYTNP1z_2dWGxbR`, shop settings, and customer marker were unchanged.
- [x] The original `com.example.tailor` package remained installed at version `0.1.0+1` and reopened its preserved `Stitch & Style Studio` dashboard after the isolated test.
- [x] After final production-trust hardening, the release-mode v11002 test APK was rebuilt and re-inspected: SHA-256 `6ebbb6213993631f14f6122007f4c7346eddb23ff4acfefa037ec417c24500f9`, same package/label/certificate, `debuggable=false`, only the configured test public-key map present, and no signing/private-license artifacts bundled.
- [x] Negative build check: a release invoked in `production` trust mode with `dev-2026-01` failed during Gradle configuration with `Production builds must not contain development or Stage 11 test license key IDs.`

### Required checks

- [x] `dart format --set-exit-if-changed lib test tool` — 93 files, no changes
- [x] `flutter analyze` — no issues
- [x] `flutter test` — 64 tests passed
- [x] `git diff --check` — passed
- [x] Android release-mode test build — two signed APKs succeeded; current `build/app/outputs/flutter-apk/app-release.apk` is the non-production v11002 test build, not a distributable artifact

### Unresolved owner values and physical-device checks

- [ ] Approve or replace the `TailorDesk` product/device name.
- [ ] Supply approved launcher/store artwork; current Android/web icons are Flutter starter icons.
- [ ] Choose an owner-controlled permanent Android application ID and align/refactor the code namespace if desired. Choose the iOS bundle ID separately before iOS release.
- [ ] Choose first customer-facing version name/version code and decide when a post-10 license release sequence becomes a paid entitlement boundary.
- [ ] Create and protect the production Android keystore and production Ed25519 license key outside the repository; approve production key IDs and certificate fingerprints.
- [ ] Repeat install/update, secure-storage, file picker, backup export/restore, OEM backup behavior, large-text/layout, and activation checks on the customer's physical Android device.
- [ ] Export and restore a real pre-update business backup on controlled client hardware, then reconcile representative customer, measurement, order, payment, karigar, report, and document records.
- [ ] Physical printer/paper compatibility and the prior working-tailor catalog/wording approvals remain pending.

Stage 11 stops here. No APK was published, no customer license was issued, no production private key or Android keystore was generated, and no existing business data was cleared.

---

## Stage 9 Verification Report — 12 October 2026

### Stage 8 Reconciliation

- Garments use stable string identifiers, not persisted Dart enum indexes. Required defaults are Shalwar Qameez, Coat, Trouser/Pant, Shirt, Waistcoat, and Jacket. Kurta and Sherwani are preserved as additional entries.
- Backups are **not encrypted**. SHA-256 detects accidental corruption or tampering but provides no confidentiality. The UI and client documentation state this explicitly; no encryption was added.
- Automated database/workflow tests, Android runtime checks, and physical printer checks are reported separately below. No claim of zero network requests is made.

### Implementation

- Drift schema version 6 adds garment catalog entries, immutable measurement-template versions, template fields, revision field-definition snapshots, and booked-order field-definition snapshots.
- Fresh databases start a four-step setup and save progress after each step. Existing schema-5 installations receive seeded configuration and `setup_completed=true` without changing customers, measurements, orders, or settings.
- Settings now edit shop details and the default measurement unit, and link to catalog/template management.
- Garments can be enabled/disabled, reordered, assigned an integer-paisa default stitching price, or added as custom templates. Disabled garments remain readable historically and are excluded from new measurement profiles/order lines.
- Template revision archives omitted fields in the new version. Old versions and frozen snapshots remain unchanged; no measurement conversion, relabeling, allowance, or formula is applied.
- Default prices prefill new order lines only and remain editable before booking. Later default changes do not update booked prices or balances.

### Automated Verification

- [x] `dart run build_runner build --delete-conflicting-outputs` — succeeded (the installed build runner reports that the option is obsolete and ignored)
- [x] `dart format --set-exit-if-changed lib test` — 84 files, no changes required
- [x] `flutter analyze` — no issues found
- [x] `flutter test` — 55 tests passed
- [x] `git diff --check` — passed
- [x] Fresh setup incomplete state, saved step recovery after database reopen, and completion
- [x] Actual schema-5 structure migrated to schema 6 with customer/shop data retained and setup bypassed
- [x] Garment seed coverage, enabling/disabling, and reordering
- [x] Custom template creation, immutable version increment, stable IDs, and archived fields
- [x] Historical revision/order field labels and booked price preserved after template/default-price changes
- [x] Backup/restore round trip includes custom catalog entries, template versions, fields, and prices; older supported schema backup migration remains covered

### Android Runtime Verification

- [x] Built, installed, and launched on `emulator-5554` (Android 17 / API 37)
- [x] Existing installation opened directly to the dashboard after schema migration; it was not forced through setup
- [x] Visually inspected the phone Settings screen and Garments & Templates screen; the ivory/charcoal/emerald theme, controls, scrolling, Coat, Jacket, ordering, enable switches, default-price actions, and custom-garment action rendered correctly
- [ ] Fresh first-use setup was not opened on the emulator because clearing the existing app data would violate the data-preservation requirement; setup is covered by automated persistence tests
- [ ] Interrupted setup was not manually force-stopped/resumed on Android
- [ ] Native backup picker/share/restore was not exercised during this Stage 9 runtime pass
- [ ] No physical printer test was performed; receipt/work-slip printer compatibility remains pending on client hardware
- [ ] No packet capture or network-request audit was performed

### Remaining Client Decisions

- A working tailor must approve every seeded field, required/optional choice, garment name, and body/finished-garment convention.
- The client must choose which garments are enabled, their display order, and default stitching prices.
- Receipt/work-slip wording, charge labels, physical printer/paper compatibility, backup custody, and restore practice still require client approval.

The historical Stage 9 report ends here; the completed Stage 10 report follows.

---

## Stage 10 Verification Report — 12 October 2026

### Implementation and policy

- Release sequence `10` is explicit. A signed `maximumReleaseSequence >= 10` grants perpetual use of this release; maintenance expiry is displayed but never disables an entitled release.
- Licenses are strict, size-limited, versioned JSON envelopes containing exact canonical payload bytes plus an Ed25519 signature. Validation covers field sets/types, canonical serialization, signature/key ID, product, installation identity, license type, and release entitlement.
- The application contains only build-supplied trusted public keys. It has no master code, release-build bypass, production key generator, licensing server, recurring check, or automatic updater.
- A cryptographically random installation ID and the signed license are stored in platform secure storage under a dedicated namespace, separately from Drift. Storage failure does not trigger identity regeneration.
- Missing, invalid, or incompatible activation never deletes business data. Existing shops may open read-only and export a backup; all DAO/settings/catalog mutations and business-data restore pass through the central database write policy.
- Android OS backup/device-transfer rules exclude app-private database, file, root, and preference domains. TailorDesk's explicit business backup remains the supported transfer route and excludes activation state.
- Settings displays the signed shop, license ID, activation state, maintenance date, and release entitlement, and accepts a renewed license. Editing the operational shop display name does not alter signed identity.
- `tool/license_issuer.dart` provides `generate-keys`, `issue`, `inspect`, `renew`, and `replace-device`. Private key and issuance ledger paths must be owner-selected locations outside the repository; key generation refuses overwrite and does not print secret material.

### Automated verification

- [x] `flutter pub get` — succeeded
- [x] `dart run build_runner build --delete-conflicting-outputs` — succeeded (installed build runner reports the option obsolete and ignored)
- [x] `dart format --set-exit-if-changed lib test tool` — passed
- [x] `flutter analyze` — no issues found
- [x] `flutter test` — 63 tests passed
- [x] `git diff --check` — passed
- [x] Valid activation and restart using persistent test storage
- [x] Tampered payload/signature, wrong installation/product/key, malformed/oversized input, unsupported format, and under-entitled release rejection
- [x] Invalid or lower-entitlement import preserves the current valid license
- [x] Expired maintenance retains access to an entitled release; boundary and future-release entitlement behavior covered
- [x] Existing records remain readable without activation while customer, measurement, settings, and restore writes are blocked
- [x] Business backup restore does not transfer or overwrite activation state
- [x] Secure-store access failure does not generate a replacement installation identity
- [x] Issuer commands were exercised with temporary keys and files under `/private/tmp`; issue, inspect, renewal, and replacement-device output verified

### Android and artifact verification

- [x] Debug APK built and installed on `emulator-5554` (Android 17 / API 37) without clearing its existing business data
- [x] Activation screen, installation code, recovery copy, and `.tailorlicense` selection were inspected; Android octet-stream handling was added after runtime inspection found the custom extension initially disabled
- [x] A temporary emulator license activated the existing installation and opened its preserved `Stitch & Style Studio` dashboard
- [x] Activation survived a full force-stop and relaunch
- [x] With Wi-Fi and mobile data explicitly disabled, a fresh force-stop/relaunch opened the licensed dashboard; network services were restored afterward
- [x] APK SHA-256: `394aea521d56c1fbcb7a7d24c75c847a7670d2e3e3f26223c4fabf545fcee25e`
- [x] The debug kernel artifact contained no issuer CLI, temporary license IDs/paths, master-code/bypass markers, or owner private-key path. Cryptography-library implementation symbols are expected; no private signing material was supplied to the build.
- [ ] Clear-data/reinstall behavior was not performed because it would destroy the existing emulator state; it is documented and identity persistence/failure behavior is covered automatically
- [ ] Android OS cloud-backup/device-transfer execution was not exercised; manifest/rule resources and explicit backup separation were inspected and tested at application level
- [ ] No packet capture was performed. The implementation has no licensing network client, but this report does not claim a whole-app zero-network audit
- [ ] Physical-device secure storage, OEM backup behavior, and client device-replacement operations remain pending

### Owner and client actions before production

- Generate and back up a production signing key deliberately outside the repository; embed only its public key at release build time.
- Configure production application ID and Android release signing, then repeat activation and replacement-device checks on client hardware.
- Establish license-ID/customer-ID conventions, an owner-controlled issuance ledger, authorization rules for replacement devices, and secure delivery/custody procedures.
- Review `OWNER_LICENSING_GUIDE.md`. Offline replacement does not revoke an old installation, and sufficiently privileged copying cannot be made unbreakable without an online service.

Stage 10 stops here. No production key, customer license, publishing, online licensing service, or automatic update mechanism was created.

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

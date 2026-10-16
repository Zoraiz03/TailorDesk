# TailorDesk release guide

TailorDesk currently has no activation or licensing gate. Do not add license keys, activation requests, entitlement checks, or read-only restrictions to preview builds.

## Private preview identity

| Item | Value |
|---|---|
| Application ID | `dev.tailordesk.preview` |
| Visible name | `TailorDesk Preview` |
| Version | `0.9.0+1` |
| Distribution | Private testing only; not production-ready |

Changing an application ID creates a separate Android app and local database. Keep the ID and signing key unchanged for in-place preview updates.

## Signing and build

Release builds require a signing-properties file and keystore outside this repository. Never commit or print passwords. Do not share an APK signed with Android's debug certificate.

```bash
ORG_GRADLE_PROJECT_tailordeskApplicationId=dev.tailordesk.preview \
ORG_GRADLE_PROJECT_tailordeskAppLabel='TailorDesk Preview' \
ORG_GRADLE_PROJECT_tailordeskSigningProperties=/absolute/external/release-signing.properties \
ORG_GRADLE_PROJECT_tailordeskNonProductionRelease=true \
flutter build apk --release --build-name=0.9.0 --build-number=1
```

Gradle fails closed when a release application ID or external signing configuration is missing. A non-production build must use a label containing `Preview`.

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed lib test tool
flutter analyze
flutter test
git diff --check
```

Audit the APK with Android SDK `aapt` and `apksigner`; record package ID, label, version, certificate SHA-256, file size, and APK SHA-256. Confirm `android:debuggable` is absent/false. Install and test the exact copied artifact, not a later rebuild.

The audited 14 October 2026 preview artifact is `dist/TailorDesk-Preview-0.9.0-android.apk`: 73,065,169 bytes; APK SHA-256 `200dfe1d8ee8a4720a73ebcb14db08ed2393899ea26271f441aa94fb296734f1`; signing-certificate SHA-256 `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93`. It uses APK Signature Scheme v2 and is not debuggable.

Before every update, export a backup, verify the same application ID and signing certificate, install the higher version code without uninstalling, and confirm existing records remain. Physical printing and real-phone file pickers require evidence on the actual equipment; emulator success does not pass those checks.

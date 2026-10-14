# TailorDesk Release Guide

This is the Stage 11–12 owner runbook. It does not authorize publishing and it never requires a production private key inside the repository. Commands assume the repository is `/Users/zoraiz/Desktop/Tailor`.

## 1. Development activation in Chrome

The development Ed25519 key pair already exists outside the repository at `~/Documents/TailorDesk-dev-licensing/`. The public key is safe to pass to a development build; `dev.private.json` must only be read by the issuer command.

Use a fixed web port so Chrome returns to the same origin and therefore the same browser activation storage after a restart:

```bash
cd /Users/zoraiz/Desktop/Tailor
flutter run -d chrome --web-port=7357 \
  --dart-define=TAILORDESK_LICENSE_TRUST_MODE=development \
  --dart-define='TAILORDESK_LICENSE_PUBLIC_KEYS={"dev-2026-01":"xCct1HqZTpg3TSYoJ0I_MRgiV67qKBklTPhPxBS6YVQ"}'
```

On the activation screen:

1. Select **Download activation request**. Chrome downloads `tailordesk-activation-request.json` directly; this path does not need clipboard or Web Share permission.
2. Keep **Copy request** as a convenience only. Chrome may deny clipboard writes outside a secure origin or a valid user gesture; TailorDesk now reports that denial. `localhost` is treated as a secure development origin.
3. **Share request** uses the Web Share API only. Chrome on the Stage 11 macOS test host invoked native share handling; dismissing the sheet did not create a file. Browsers without generated-file sharing receive a clear unsupported message instead of silently changing Share into Download.

Issue a development-only license. Pick a new output/license ID if that filename already exists; the issuer intentionally refuses overwrite.

```bash
cd /Users/zoraiz/Desktop/Tailor
DEV_LICENSE_ROOT="$HOME/Documents/TailorDesk-dev-licensing"
dart run tool/license_issuer.dart issue \
  --request "$HOME/Downloads/tailordesk-activation-request.json" \
  --private-key "$DEV_LICENSE_ROOT/dev.private.json" \
  --key-id dev-2026-01 \
  --license-id DEV-LOCAL-001 \
  --shop-id DEV-SHOP \
  --shop-name 'TailorDesk Development' \
  --maintenance-through 2027-12-31 \
  --max-release 10 \
  --output "$DEV_LICENSE_ROOT/DEV-LOCAL-001.tailorlicense" \
  --ledger "$DEV_LICENSE_ROOT/dev-issuance-ledger.jsonl"
```

Return to TailorDesk, select **Import license file**, and choose that `.tailorlicense` file. Confirm the dashboard opens. Stop the Flutter process, run the same `flutter run` command again with port `7357`, and confirm TailorDesk opens activated with the same installation code. Changing the port changes the browser origin and creates a different web installation.

Never pass `dev.private.json` to Flutter, copy it into this repository, or include the development public key in a production build. There is no activation bypass.

## 2. Release identity: owner decisions required

Current values are:

| Item | Current value | Production decision |
|---|---|---|
| User-visible name | `TailorDesk` | Owner must approve the final store/device name. |
| Android icon | Original emerald spool/thread; adaptive foreground/background and themed layer | Owner approval and physical launcher checks pending. See `assets/branding/preview.png`. |
| Android debug application ID/namespace | `com.example.tailor` | Placeholder. A permanent owner-controlled application ID is mandatory for release. |
| iOS bundle ID | `com.example.tailor` | Placeholder; decide before any iOS release. |
| Version name | `0.1.0` development default | Proposed first customer version: `1.0.0`, pending approval. |
| Version code | `1` development default | Proposed first production code: `1`, pending approval. Must increase for every subsequent Android update. |
| License release sequence | `10` | Remains `10` until the owner deliberately declares a newer commercial entitlement boundary. It is separate from Android version code. |

Android treats a different application ID as a different app. Changing it after installation does not update the old app: it installs beside it with separate database, settings, installation ID, and activation. Choose the permanent ID before the first customer install and preserve it forever. The Kotlin/Android namespace may be refactored separately; it does not define update compatibility, but aligning it with the final ID is recommended.

Proposed production application ID: **`com.zoraiz.tailordesk`**, not yet owner-confirmed. Development remains `com.example.tailor`; the proposed production identity is not applied to existing installations. A first production version code of `1` belongs to the new production ID, not the isolated test package's higher version codes.

### One configuration file for customer builds

`config/production-release.example.json` records the proposals with `ownerConfirmed: false` and no credentials. Copy it outside the repository and edit only that copy after owner approval:

```bash
cd /Users/zoraiz/Desktop/Tailor
mkdir -p "$HOME/Documents/TailorDesk-release"
cp -n config/production-release.example.json "$HOME/Documents/TailorDesk-release/release.json"
# Open that file in your editor. Confirm identity and version, set ownerConfirmed
# to true, set signingProperties to the absolute external .properties path,
# and list ONLY production *.public.json paths in productionPublicKeyFiles.
dart run tool/build_customer_release.dart "$HOME/Documents/TailorDesk-release/release.json"
```

Do not distribute until the pilot and delivery checklist pass. Missing confirmation, identity/version, release-sequence acknowledgement, external signing properties, or explicit production public-key files block this wrapper. Gradle independently blocks missing signing, placeholder identity, development trust mode, and known development/test key IDs. There is no debug-signing fallback. Public key labels cannot prove provenance: the owner must verify every production public key against the separately protected production issuer key. Never rename a development key to make it pass a guard.

This supplies the application ID and Android version flags without editing the manifest, Kotlin namespace, or `pubspec.yaml`. `licenseReleaseSequence` must match the current source value **10**; it is an acknowledgement, not an override. Keep 10 for this preparation stage. A future entitlement boundary requires a deliberate source change, owner review, and matching config. Preserve the production package ID and signing key forever; increment versionCode for each update.

### Android customer handoff

On Android, **Download activation request** opens the system document save chooser. Select Downloads (or another accessible folder) and Save; send that JSON unchanged to the owner. Cancellation does not export a request. Sharing is an alternative, not a guaranteed file save. Android request export uses the same canonical request bytes as the browser and issuer.

Use [customer installation](CUSTOMER_INSTALLATION_GUIDE.md), [customer updates](CUSTOMER_UPDATE_GUIDE.md), the blank [owner delivery checklist](CUSTOMER_DELIVERY_CHECKLIST.md), [business policy draft](BUSINESS_POLICY_DRAFT.md), and [physical pilot acceptance](PILOT_ACCEPTANCE.md). The policy is not final commercial/legal advice; unresolved terms require owner decisions. Keep owner sales/licensing records separate from the tailoring database.

## 3. Create and protect Android signing credentials

Android application signing and Ed25519 license signing are unrelated. Use separate keys, separate files, and preferably separate backup media. Do not reuse either key or password for the other purpose.

The owner creates the production Android keystore once, outside the repository. Example (replace the path and alias deliberately):

```bash
mkdir -p /Volumes/OwnerVault/TailorDesk/android-signing
keytool -genkeypair -v \
  -keystore /Volumes/OwnerVault/TailorDesk/android-signing/tailordesk-upload.jks \
  -alias tailordesk-upload \
  -keyalg RSA -keysize 4096 -validity 10000
chmod 600 /Volumes/OwnerVault/TailorDesk/android-signing/tailordesk-upload.jks
```

Copy `android/release-signing.properties.example` to the same external directory, fill its four values, and restrict it:

```bash
cp android/release-signing.properties.example \
  /Volumes/OwnerVault/TailorDesk/android-signing/release-signing.properties
chmod 600 /Volumes/OwnerVault/TailorDesk/android-signing/release-signing.properties
```

Keep at least two encrypted, access-controlled offline backups of the keystore and passwords. Losing the Android signing identity prevents future APKs from updating installed copies. A leaked key can let an attacker sign malicious updates. Do not email the keystore, commit it, put it in an APK, or store its passwords in shell history.

Release Gradle configuration has no debug-signing fallback. It rejects a signing-properties file or keystore inside this repository, rejects `com.example.*`, rejects missing license trust roots, and rejects development trust mode.

## 4. Production release build

Use the reviewed external JSON configuration from section 2. It references owner-controlled **production public** license-key JSON files, never the private license-key file.

```bash
cd /Users/zoraiz/Desktop/Tailor
dart run tool/build_customer_release.dart "$HOME/Documents/TailorDesk-release/release.json"
```

The proposed `com.zoraiz.tailordesk`, version `1.0.0`, and code `1` are not approved production values yet. Confirm them in the single config only after owner review. A production build must contain only explicitly selected production public license keys. Do not mix in `dev-2026-01` or any Stage 11 test key.

## 5. Owner-assisted customer update checklist

Complete this in order before sending a newer APK:

1. Record the new APK's license release sequence and the customer's currently signed `maximumReleaseSequence`.
2. If the customer entitlement is lower, use the private issuer to create and import a renewed license on the existing app **before** installing the APK. Confirm it is active after restart.
3. In **More → Backup & Restore**, export a current business backup and copy it off the device. The backup is unencrypted; protect it accordingly.
4. Confirm the update uses exactly the same permanent application ID and Android signing certificate as the installed app.
5. Install the higher-version APK over the old version. Never uninstall and never clear app data to update.
6. Open TailorDesk and verify activation, installation code, shop settings, customer count, order/payment records, measurements, karigar data, and a representative recent record.
7. Keep the pre-update APK and verified business backup under owner control until acceptance is complete. Do not attempt a database downgrade after a newer schema has opened it.

## 6. Repeatable verification and APK audit

Repository checks:

```bash
cd /Users/zoraiz/Desktop/Tailor
dart format --set-exit-if-changed lib test tool
flutter analyze
flutter test
git diff --check
```

Inspect a built APK with the installed Android SDK (adjust build-tools path if needed):

```bash
APK=build/app/outputs/flutter-apk/app-release.apk
BUILD_TOOLS="$HOME/Library/Android/sdk/build-tools/36.0.0"
"$BUILD_TOOLS/aapt" dump badging "$APK" | head -n 3
"$BUILD_TOOLS/apksigner" verify --verbose --print-certs "$APK"
unzip -l "$APK" | less
unzip -p "$APK" lib/arm64-v8a/libapp.so | strings | \
  grep -E 'dev-2026-01|TAILORDESK_LICENSE|privateKey' || true
```

Also inspect the merged manifest or `aapt dump xmltree` output and confirm `android:debuggable` is absent/false. Public Ed25519 verification keys are expected in the compiled artifact; private license-key material and Android keystores are never expected.

Every Stage 11 verification APK and key must be labelled **NON-PRODUCTION — DO NOT DISTRIBUTE**, use an isolated test application ID, and be destroyed or retained only as controlled test evidence. Stage 11 does not publish an APK or issue a customer license.

### Stage 12 branding verification build — NON-PRODUCTION

The following reuses the already-created temporary Stage 11 Android signing key and public test license key. It does not generate credentials. If those temporary files are unavailable, stop and deliberately prepare a new isolated test identity; never substitute production keys or the existing development package. The public key below is test verification material, not a private key.

```bash
cd /Users/zoraiz/Desktop/Tailor
ORG_GRADLE_PROJECT_tailordeskApplicationId=dev.tailordesk.stage11test \
ORG_GRADLE_PROJECT_tailordeskSigningProperties=/private/tmp/tailordesk-stage11-nonproduction/android-test-signing.properties \
ORG_GRADLE_PROJECT_tailordeskNonProductionRelease=true \
flutter build apk --release --no-pub --build-name=12.0.0-test --build-number=12001 \
  --dart-define=TAILORDESK_LICENSE_TRUST_MODE=test \
  --dart-define='TAILORDESK_LICENSE_PUBLIC_KEYS={"stage11-test-license":"Psb1wbt3xYsTLdZJC7YK3DW0R0L1dmWPYjCkW7nfLxA"}'
shasum -a 256 build/app/outputs/flutter-apk/app-release.apk
# First verify package/certificate using the audit commands above.
# emulator-5554 must be the isolated test emulator, not a customer phone.
"$HOME/Library/Android/sdk/platform-tools/adb" -s emulator-5554 install -r \
  build/app/outputs/flutter-apk/app-release.apk
```

This updates only `dev.tailordesk.stage11test`, never `com.example.tailor`. Do not uninstall or clear either package. Do not run this version over a higher-code test installation. The displayed test name is intentionally `TailorDesk TEST — NOT FOR DISTRIBUTION`.

Stage 12 local evidence: `12.0.0-test (12001)` installed successfully over `11002`; package/certificate matched, `debuggable` absent/false, adaptive v26/v33 layers and five density PNGs present, only test licensing public map present in inspected arm64 AOT. APK SHA-256 `741f825eb40492356de01a754738c84525099777b3779ad63442f91e6926555f`; certificate SHA-256 `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93`. A controlled local copy is `/private/tmp/tailordesk-stage12-NON-PRODUCTION/TailorDesk-12.0.0-test-12001-DO-NOT-DISTRIBUTE.apk`; do not deliver it to customers.

Only a headless emulator was available in Stage 12. Installed APK hash/name/icon resources were inspected, but live launcher rendering, native Save chooser interaction, and post-update business/activation UI were not re-executed. Prior Stage 11 data/activation upgrade evidence remains historical evidence, not a new physical pilot pass. Complete `PILOT_ACCEPTANCE.md` before customer delivery.

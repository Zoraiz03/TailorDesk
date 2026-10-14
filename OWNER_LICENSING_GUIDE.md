# TailorDesk Owner Licensing Guide

Stage 10 uses offline Ed25519 signatures. The private issuer is an owner-only command-line tool; customer applications contain trusted public keys only. No licensing server or recurring internet check is involved.

The implementation follows the maintained Dart `cryptography` package's Ed25519 API (RFC 8032): <https://pub.dev/documentation/cryptography/latest/cryptography/Ed25519-class.html>.

## Security responsibilities

- Run the issuer only on an owner-controlled computer.
- Generate the production key explicitly. TailorDesk never generates it during an app build or application startup.
- Keep the private key and issuance ledger outside the source repository, application bundle, ordinary TailorDesk backup, cloud source-control folder, and customer-accessible storage.
- Keep at least two encrypted offline backups of the private key and ledger in separately controlled locations.
- Restrict the private-key file to the owner account. The generator applies mode `0600` on macOS/Linux.
- Never send the private key to a customer. A customer receives only a `.tailorlicense` file.
- Losing the private key prevents issuing renewals with that key. Leaking it allows unauthorized licenses until a future application release removes that public key.

Examples below use `/Volumes/OwnerVault/TailorDesk`. Replace it with an owner-selected location outside `/Users/zoraiz/Desktop/Tailor`.

Stage 12 customer Android builds should use the single external release config and guarded command in [RELEASE_GUIDE.md](RELEASE_GUIDE.md). The proposed production identity is not confirmed. On Android, **Download activation request** opens the native Save chooser; save and send the unchanged JSON. Do not send the issuer private key to a customer.

## 1. Generate a production signing key

Do this once, deliberately:

```bash
cd /Users/zoraiz/Desktop/Tailor
dart run tool/license_issuer.dart generate-keys \
  --key-id owner-2026-01 \
  --private-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.private.json \
  --public-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.public.json
```

The command refuses to overwrite files and refuses to place the private key inside the repository. It never prints private key material.

## 2. Configure trusted public keys in the app build

Read `publicKey` from the public JSON file and supply a JSON map using the compile-time `TAILORDESK_LICENSE_PUBLIC_KEYS` define. Multiple key IDs may be present during rotation.

```bash
flutter build apk --release \
  --dart-define=TAILORDESK_LICENSE_TRUST_MODE=production \
  --dart-define='TAILORDESK_LICENSE_PUBLIC_KEYS={"owner-2026-01":"PUBLIC_KEY_BASE64URL"}'
```

The value is public verification material, not a secret. Keep the private JSON out of the build command and repository. Production builds must use `production` trust mode and contain production public keys only. Development builds use `development`; Stage 11 verification APKs use `test`. Release Gradle configuration rejects development trust mode. When rotating keys, ship an app release that trusts both old and new production public keys before issuing licenses with the new key. A later release may remove a compromised or retired public key subject to the perpetual-release commitments already sold.

## 3. Receive an activation request

The customer opens TailorDesk and downloads `tailordesk-activation-request.json`, then sends it through the agreed business channel. Copy remains available where clipboard permission works, and Share remains available where the platform can share generated files. The request contains only:

- format version;
- product ID;
- random installation ID.

It contains no IMEI, phone number, hardware serial, business database, or private key.

## 4. Issue an initial license

```bash
dart run tool/license_issuer.dart issue \
  --request /path/to/customer-request.json \
  --private-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.private.json \
  --key-id owner-2026-01 \
  --license-id LIC-2026-0001 \
  --shop-id CUSTOMER-0042 \
  --shop-name 'Example Tailors' \
  --maintenance-through 2027-10-12 \
  --max-release 10 \
  --output /path/to/LIC-2026-0001.tailorlicense \
  --ledger /Volumes/OwnerVault/TailorDesk/issuance-ledger.jsonl
```

Send only the generated `.tailorlicense` file. The application validates it offline against its installation ID and compiled public key.

## 5. Inspect and verify a license

```bash
dart run tool/license_issuer.dart inspect \
  --license /path/to/LIC-2026-0001.tailorlicense \
  --public-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.public.json
```

This verifies the signature and prints the non-secret signed claims.

## 6. Renew maintenance or release entitlement

Renewal creates a replacement signed license. It cannot reduce the existing maintenance date or release sequence.

```bash
dart run tool/license_issuer.dart renew \
  --license /path/to/LIC-2026-0001.tailorlicense \
  --public-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.public.json \
  --request /path/to/current-installation-request.json \
  --private-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.private.json \
  --key-id owner-2026-01 \
  --new-license-id LIC-2026-0001-R1 \
  --maintenance-through 2028-10-12 \
  --max-release 12 \
  --output /path/to/LIC-2026-0001-R1.tailorlicense \
  --ledger /Volumes/OwnerVault/TailorDesk/issuance-ledger.jsonl
```

Maintenance expiry does not disable a release already covered by `maximumReleaseSequence`. TailorDesk does not use the phone's current date to disable perpetual use.

## 7. Issue a replacement-device license

Obtain an activation request from the replacement installation, then run:

```bash
dart run tool/license_issuer.dart replace-device \
  --license /path/to/current-license.tailorlicense \
  --public-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.public.json \
  --request /path/to/replacement-device-request.json \
  --private-key /Volumes/OwnerVault/TailorDesk/owner-2026-01.private.json \
  --key-id owner-2026-01 \
  --new-license-id LIC-2026-0001-DEVICE2 \
  --output /path/to/LIC-2026-0001-DEVICE2.tailorlicense \
  --ledger /Volumes/OwnerVault/TailorDesk/issuance-ledger.jsonl
```

An offline replacement does **not** revoke or disable the old device. Record the reason and authorization in the owner ledger/business records. Strong revocation would require an online service or a later manually installed revocation mechanism and is outside Stage 10.

## Installation identity and backups

- The installation ID is cryptographically random and stored with the activation license in platform secure storage, separately from Drift and exported business backups.
- Normal application updates retain platform storage and activation.
- Clearing application data removes the Android identity and activation. Reinstallation commonly removes them on Android; iOS Keychain restoration/reinstallation behavior can differ by platform policy and device configuration. A new activation request and replacement license may therefore be required.
- Android Auto Backup and device transfer are disabled for TailorDesk app-private files, databases, and preferences. This prevents Android restore from cloning activation state. The customer must use TailorDesk's explicit business backup instead. Android's rule formats are documented at <https://developer.android.com/identity/data/autobackup>.
- A TailorDesk business backup contains the Drift business database only. It excludes installation identity and signed activation. Restore requires the destination installation to be activated and preserves its secure-store license.
- Offline binding discourages accidental copying but is not unbreakable. A sufficiently privileged attacker may clone or modify an offline application/device. No remote revocation or concurrent-device detection is possible without a server.

## Release and update policy

- Stage 10 application release sequence is `10`.
- A license is valid when its signed `maximumReleaseSequence` is at least the running release sequence.
- A future-release license remains valid on older supported application releases.
- TailorDesk does not automatically update itself in Stage 10.
- Any future updater must verify release entitlement **before** installing application files or opening/migrating the business database with a newer schema.
- If a database was opened by a newer unsupported release, do not attempt a downgrade. Reinstall the entitled newer release or recover through owner support and a verified backup.

## Issuance ledger

The JSON-lines ledger records issuance, renewal, and replacement events. It is owner-side operational evidence, not a revocation server. Back it up with the private key, protect it from customer access, and never package it with the application.

# TailorDesk Preview tester guide

This APK is a private Android preview, not a public or production release. It installs as **TailorDesk Preview** separately from development and future customer builds.

## Install

1. Receive `TailorDesk-Preview-0.9.0-android.apk` from the owner and confirm its SHA-256 checksum.
2. Open it from Android Downloads or the file manager.
3. If prompted, allow installs from that one source, return, and tap **Install**. You may turn the permission off afterward.
4. Stop and report any security warning or signature/update error; do not disable phone protection.
5. Open **TailorDesk Preview**. No activation is required.

For this preview, the APK SHA-256 is `200dfe1d8ee8a4720a73ebcb14db08ed2393899ea26271f441aa94fb296734f1`. Its signing-certificate SHA-256 is `f55c4f551142d67ebfa6ab9835be2309676e7b93923716bce076ccee1d4c8f93`.

## Short test workflow

1. Complete shop setup and switch once between English and Urdu.
2. Add a customer and a garment measurement profile.
3. Create an order with a delivery date and advance payment.
4. Add a karigar, assign the garment, progress it to ready, record the remaining payment, and deliver it.
5. Check Dashboard and Reports totals. Generate the customer receipt and karigar work slip; the work slip must not show financial details.
6. Force-stop the app, disable connectivity, reopen it, and confirm the records remain available. Create one more sample record offline.

Physical printing and real-phone save/share/file-picker behavior are separate checks. A successful emulator PDF does not prove that a printer or phone file picker works.

## Export a backup

Open **More → Backup & Restore → Create and export backup**. Complete the Android share/save action and verify the `.tailorbackup` file arrived outside the phone. A cancelled share does not create a backup copy. The archive is not encrypted, so protect it.

Do not test Restore against real shop records. Restore replaces local records rather than merging them.

## Report a bug

Include:

- phone model;
- Android version;
- TailorDesk version from **More → About TailorDesk**;
- exact steps to reproduce;
- expected result and actual result;
- a screenshot, avoiding real customer information;
- whether connectivity was disabled and whether the app had been restarted.

This preview stores business records in local device storage. It has no automatic cloud synchronisation. Export backups regularly and keep a verified copy outside the phone.

# TailorDesk physical Android pilot acceptance

Status: **NOT YET EXECUTED ON A PHYSICAL PHONE**. The Stage 11 emulator upgrade is separate evidence and does not pass any physical-device item below. Use an isolated pilot installation and invented sample records. Never clear, uninstall, or restore over live shop data for testing.

## Stage 13 attempt — 13 October 2026, 21:18 PKT

**BLOCKED: no physical Android device available to ADB.** Device discovery returned only:

```text
emulator-5554  device  product:sdk_gphone16k_arm64  model:sdk_gphone16k_arm64  device:emu64a16k
```

Read-only `getprop ro.kernel.qemu` returned `1`, confirming this is an emulator. No physical model, Android/OEM version, screen size, or printer details could be recorded. Physical pilot checks: **0 passed, 0 failed, all pending** (not executed). No app defect was observed through physical testing because none could run. Stage 12's 71 passing automated tests remain prior evidence, not a physical pilot result.

### Connect the phone to this Mac

1. Use an Android phone whose owner agrees to an isolated sample-data pilot. Keep existing apps and records; do not reset the phone.
2. On the phone, open **Settings → About phone → Build number** (often inside **Software information**). Tap Build number seven times and enter the phone unlock code yourself if prompted.
3. Open **Settings → System → Developer options** (some phones put Developer options directly in Settings). Enable **USB debugging**.
4. Connect the unlocked phone to this Mac with a data-capable USB cable. Approve the phone's **Allow USB debugging?** prompt only for this trusted Mac. No bootloader/OEM unlocking, rooting, or disabling Play Protect is needed.
5. In Terminal, run:

   ```bash
   /Users/zoraiz/Library/Android/sdk/platform-tools/adb devices -l
   ```

   A physical serial must appear with status `device`, in addition to or instead of `emulator-5554`. If `unauthorized`, unlock the phone and approve its prompt. If absent/offline, reconnect, try another data cable/USB port, and recheck USB debugging; macOS needs no additional ADB USB driver. Do not clear app data to troubleshoot a connection.
6. Tell the tester which physical serial/model to use. All subsequent ADB commands must target that serial explicitly. Keep the phone connected by USB for offline tests. For interactive observation, open Android Studio **View → Tool Windows → Running Devices**, select the physical phone, and enable mirroring if offered; otherwise perform the on-phone steps with the tester and record evidence.
7. After the pilot, turn USB debugging off if it is no longer needed. Do not leave an untrusted computer authorised.

Connection references: [Android hardware-device setup](https://developer.android.com/studio/run/device) and [developer options](https://developer.android.com/studio/debug/dev-options). Menu names vary by manufacturer.

### Resume safely — plan, not executed evidence

- Before installation, inventory the selected phone's existing packages. Use a fresh isolated non-production ID such as `dev.tailordesk.stage13pilot` for the baseline/update pair and a different unused ID such as `dev.tailordesk.stage13restore` for the restore destination. These are planned test IDs, not approved production identities. If either already exists, preserve it and choose another unused test ID.
- Build release-mode test APKs using temporary Android signing credentials and temporary license keys stored outside the repository; trust mode `test` with explicit non-production opt-in. Label app/APK **TEST — NOT FOR DISTRIBUTION**. Record actual APK hashes, certificate fingerprint, versions, and public-key IDs. Do not bundle private keys or issue a license before receiving the actual installation request. No credentials or APKs were generated in this blocked attempt.
- Copy the audited baseline APK to the selected phone's user-accessible Downloads folder, then open it in **Files/Downloads** and complete the Android installer flow. Do not use `adb install` or `flutter run` as evidence for this customer installation check. Allow installation only from the chosen source if prompted; investigate security warnings instead of disabling protections. Verify icon/name before opening.
- Exercise both Download and Share request, record cancellation and actual saved/sent file results, issue a **test-only** license with the private issuer, and import it. Complete the full workflow in the table below using invented shop/customer data. Record actual totals and record identifiers, not just screenshots of empty screens.
- For PDFs, test both receipt and karigar slip. Use the native print dialog's **Save as PDF** destination if available, complete its document save chooser, and reopen the file from Files. Record the actual export/share route separately. A share sheet opening alone does not prove a PDF was saved.
- Export a backup to a user-accessible folder and copy it outside the phone; verify both files exist. Record names/checksums. Do not mark a cancelled share as successful export.
- Note connectivity settings, disable Wi-Fi and mobile data (airplane mode may leave Wi-Fi enabled), force-stop only the isolated pilot app, and reopen. Compare installation/license IDs, settings, record counts and representative records; create another sample offline. Restore the user's original connectivity settings afterward.
- **Restore proof requires different identities:** activate the separate destination with its own request/license. Record source ID/license A and destination ID/license B; they must differ. Restore only the source's sample backup into that disposable destination. Confirm recovered customers/measurements/orders/payments/settings, while installation ID/license remain B, not A. Reopen offline to verify. Do not overwrite any live shop database.
- For update, use the baseline package ID, signing key and test trust roots with a higher version code. Keep license release sequence **10** unless a separately planned entitlement test requires otherwise. Export a backup first; install the update from Files over the baseline without uninstalling or clearing storage. Compare recorded IDs/license/settings/records after force-stop/reopen.
- Printer model, connection, service/driver and paper size are **unknown/pending**. Test only actual available equipment; PDF generation or Save as PDF does not establish physical printer compatibility.

## Physical test record

Record: tester ______ date ______ phone/model ______ Android/OEM version ______ screen size ______ APK version/code ______ package ID ______ license release sequence ______ APK checksum ______ signing fingerprint ______ test license ID ______.

For each row record Pass / Fail / Pending, evidence and any defect reference. **Every row below is currently Pending — physical phone unavailable; printer availability also unconfirmed.** Blank evidence cells are not passes. Do not mark a row passed without observation.

| Check | Procedure and expected result | Result / evidence |
|---|---|---|
| Fresh install / icon | Install on a fresh isolated phone/package. Confirm TailorDesk name, emerald spool icon, small launcher size, common device mask and themed icon if available. | |
| Activation export/import | Save exact JSON through Download; verify cancellation; send request, import matching license, reject a wrong-installation sample without changing valid activation. | |
| Setup / branding | Complete shop details/unit/garments/prices. Interrupt once and resume. Confirm TailorDesk on setup/activation/About and shop identity on receipt. | |
| Restart / offline | Record installation ID, force-close/reopen and restart phone. Enable airplane mode; confirm activation and existing records, and create a sample record offline. | |
| Customers / measurements | Add and edit a sample customer; add required measurements, unit and body/finished-garment basis; revise measurements and verify history. | |
| Booking / payments | Book multiple garments with advance, verify PKR totals, record balance payment and confirm ledger/report totals. Later measurement edits must not change the booked snapshot. | |
| Karigar / delivery | Add workers, assign/reassign with reason, mark progress/ready, partially deliver and finish delivery. Confirm history. | |
| PDF | Generate customer receipt and karigar slip offline. Verify shop heading, amount/balance and frozen measurements; slip must omit financial details. Export and reopen PDF. | |
| Native backup export | Export sample database, verify file arrives outside phone, cancel once and check feedback. Record backup name/checksum/location. | |
| Isolated restore | On an explicitly disposable, activated installation, add a distinguishable sample after backup, restore the sample backup, verify replacement rather than merge and preserved destination activation. Verify safety-backup location and invalid-archive rejection. Never use live data. | |
| App update | On pilot data, record ID/license/settings/counts/recent order. Renew entitlement first if needed, export backup, install higher-code same-ID/same-certificate APK over existing app. Recheck records and secure-store activation after restart. | |
| Small screen / keyboard | Use smallest supported phone and large system text. Inspect activation, setup, customer/measurement/order forms and dialogs. Verify controls visible while typing, scrolling, keyboard dismissal, validation and touch targets. | |
| Actual physical print | Record exact printer, connection, service/driver, paper and settings. Print receipt and work slip; check clipping, legibility, amounts, shop heading and worker privacy. Test cancellation. PDF-only success does not pass this row. | |

Printer evidence: model ______ connection ______ service/version ______ paper ______ samples/photos ______.

Backup/restore authorisation for isolated data: ______. Live shop data present? If yes, **stop restore testing** and prepare a separate installation.

Outstanding defects and owner ______. Retest evidence ______. Shop/tailor template and workflow sign-off ______. Pilot accepted by ______ date ______, or blocked because ______.

Physical-device release approval remains pending until the required rows and any agreed equipment checks pass. Use [CLIENT_REVIEW.md](CLIENT_REVIEW.md) for detailed template, report and terminology approval, and [CUSTOMER_DELIVERY_CHECKLIST.md](CUSTOMER_DELIVERY_CHECKLIST.md) for the separate owner delivery record.

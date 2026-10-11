# TailorDesk Client Review

TailorDesk is an offline-first shop application. This review should be completed on an Android phone or tablet before production use. Use sample customers and orders, not live business records.

## Practical walkthrough

1. Open **Settings** from **More** and enter the shop name, address, phone, and receipt footer.
2. Add a customer and confirm that name, phone, address, and notes are easy to enter and find again.
3. Add a measurement profile. Confirm the garment, body/finished-garment basis, unit, required fields, fit, and instructions.
4. Create a multi-garment order, add an advance, and review the total before saving.
5. Add two karigars from **More → Karigars**, assign one garment to each, then start and complete their work.
6. Reassign one sample garment and confirm the earlier worker and reason remain in its history.
7. Record the remaining payment, deliver one garment, confirm partial delivery is visible, then deliver the rest.
8. Open the order’s print action. Review the customer receipt, each karigar work slip, and a combined document. Confirm work slips contain no prices.
9. Open **More → Backup & Restore**, export a backup to a safe location, then restore that sample backup. Restore replaces local data; it does not merge records.
10. Repeat the core workflow in airplane mode, close the application completely, reopen it, and confirm the records and documents remain available.

## Questions for the client

- Are the garment measurement fields, required fields, units, body/finished-garment distinction, and fit choices correct for the shop?
- Which optional measurements should become required, and are any fields missing or unnecessary?
- Do **Stitching**, **Cloth**, and **Additional charge** match the labels and calculations used by the shop?
- Are the customer receipt and karigar work slip readable, complete, and practical for the printers and paper sizes the shop uses?
- Is the booking workflow fast enough for a busy counter? Which step causes the most delay?
- Are assignment, reassignment, alteration, ready, partial-delivery, and cancellation terms familiar to staff?
- Is the backup process understandable, including that archives are not encrypted and restore replaces rather than merges data?
- Where will the shop keep external backups, and who is responsible for testing a restore regularly?

## Items requiring explicit approval

- Garment templates and their required/optional measurement fields remain provisional until reviewed by a working tailor.
- Receipt and work-slip wording, shop charge labels, and the receipt footer require client approval.
- Physical printer compatibility and mobile file-picker/share behavior require testing on the client’s actual Android device and printer.

## Run and build commands

From `/Users/zoraiz/Desktop/Tailor`:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --set-exit-if-changed lib test tool
flutter analyze
flutter test
flutter run -d <android-device-id>
flutter build apk --debug
flutter build web
```

The app is ready for structured client review, but it is not yet declared production-ready. Android offline persistence, native backup/restore, and physical printing still require device evidence.

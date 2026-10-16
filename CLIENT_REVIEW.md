# TailorDesk Client Review

TailorDesk is an offline-first shop application. This review should be completed on an Android phone or tablet before production use. Use sample customers and orders, not live business records.

## Practical walkthrough

1. On a fresh preview installation, confirm the app opens directly without activation. Complete setup with shop name, optional phone/address, default unit, enabled garments, and optional prices; force-close midway once and confirm setup resumes at the saved step.
2. Open **More → Settings**, confirm the same shop details and unit can be changed, then open **Garments & measurement templates**.
3. Confirm Shalwar Qameez, Coat, Trouser/Pant, Shirt, Waistcoat, and Jacket are present. Kurta and Sherwani are retained as optional additional entries. Disable one garment, reorder another, set a default price, and create one custom template.
4. Add a customer and measurement profile. Confirm disabled garments are unavailable for new profiles, while body/finished-garment basis, unit, required fields, fit, and instructions are clear.
5. Revise the custom template: rename a label, change required/optional status, and archive a field. Confirm an older saved measurement still shows its original labels and convention.
6. Create a multi-garment order. Confirm the default stitching price is prefilled but editable, then add an advance and review the total before saving. Change the catalog default afterward and confirm the booked order total does not change.
7. Add two karigars from **More → Karigars**, assign one garment to each, then start and complete their work.
8. Reassign one sample garment and confirm the earlier worker and reason remain in its history.
9. Record the remaining payment, deliver one garment, confirm partial delivery is visible, then deliver the rest.
10. Open the order’s print action. Review the customer receipt, each karigar work slip, and a combined document. Confirm work slips contain no prices.
11. Open **More → Backup & Restore**, export a backup to a safe location, then restore that sample backup. Confirm custom garments, template versions, prices, and settings return. Restore replaces local data; it does not merge records, and the archive is not encrypted.
12. Open **More → Reports** (or tap any summary card on the **Dashboard**):
    - **Orders Due & Overdue**: inspect overdue warning badges, due today, and upcoming deadlines; tap any card to open the order.
    - **Customer Balances**: verify total shop receivables and per-customer balances; tap a customer to open their ledger and contact info.
    - **Collections & Refunds**: filter by Today, 7 Days, 30 Days, All Time, or Custom range; inspect gross collections, customer refunds, Net Collections (cash flow, not profit), cash vs bank split, and the chronological transaction ledger.
    - **Karigar Workload**: check active worker load, unassigned garment lines with one-tap quick assign, and internal deadline alerts.
13. Repeat the core workflow in airplane mode, close the application completely, reopen it, and confirm the records, reports, and documents remain available offline. This is an operational offline check, not proof that the app makes zero network requests.
14. Force-stop and reopen the app with connectivity disabled. Confirm existing records remain and create another sample record offline.

## Questions for the client

- Are the garment measurement fields, required fields, units, body/finished-garment distinction, and fit choices correct for the shop?
- Which optional measurements should become required, and are any fields missing or unnecessary?
- Which garments should be enabled by default, in what order, and at what default stitching price?
- Are staff comfortable choosing and maintaining stable field IDs for custom templates, or should only an administrator edit templates?
- Do **Stitching**, **Cloth**, and **Additional charge** match the labels and calculations used by the shop?
- Are the customer receipt and karigar work slip readable, complete, and practical for the printers and paper sizes the shop uses?
- Is the booking workflow fast enough for a busy counter? Which step causes the most delay?
- Are assignment, reassignment, alteration, ready, partial-delivery, and cancellation terms familiar to staff?
- Do the 4 live reports (Due & Overdue, Customer Balances, Collections & Refunds, Karigar Workload) meet daily shop operations and evening cash-counter reconciliation needs?
- Is the backup process understandable, including that archives are not encrypted and restore replaces rather than merges data?
- Where will the shop keep external backups, and who is responsible for testing a restore regularly?

## Items requiring explicit approval

- Garment templates and their required/optional measurement fields remain provisional until reviewed by a working tailor.
- Enabled garments, display order, default stitching prices, and each template's body/finished-garment convention require shop approval.
- Receipt and work-slip wording, shop charge labels, and the receipt footer require client approval.
- Reports metrics, period filters, and financial terms (Net Collections cash-flow reporting without profit labeling) require client sign-off.
- Physical printer compatibility and mobile file-picker/share behavior require testing on the client’s actual Android device and printer.
- Production application identity, Android signing-key custody, support terms, and update process require owner approval.

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

The private preview is prepared for structured client review but is not production-ready. Use [PILOT_ACCEPTANCE.md](PILOT_ACCEPTANCE.md) to record physical-device evidence and [CUSTOMER_DELIVERY_CHECKLIST.md](CUSTOMER_DELIVERY_CHECKLIST.md) for each owner handoff. Native backup/restore, device replacement, and physical printing require client-hardware evidence. Emulator evidence is not physical-device acceptance.

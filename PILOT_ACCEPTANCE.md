# TailorDesk private Android pilot acceptance

Status: **emulator verification complete; physical-phone acceptance pending**. Use invented sample records. Never clear, uninstall, or restore over a shop's live data.

TailorDesk Preview starts directly into first-use setup or the dashboard. There is no activation or license step.

| Check | Emulator | Physical phone / equipment |
|---|---|---|
| Install separate preview package and launch | Pass: exact signed APK, package `dev.tailordesk.preview`, no activation | Pending |
| Setup, customer, measurements, order, payment, karigar, delivery | Pass: complete sample flow; karigar path also covered by automated acceptance workflow | Pending |
| Reports and local persistence after force-stop/reopen offline | Pass: Wi-Fi/data off; two orders retained, including one saved by exact APK | Pending |
| Receipt and karigar-slip PDF generation | Pass: automated generation plus rendered English/Urdu/bilingual visual QA | Pending physical print/save/share |
| Backup creation and restore logic | Automated evidence | File picker/share/restore pending |
| English/Urdu UI and RTL | Pass for key parity, switch/RTL tests and rendered PDFs; broad device layout review pending | Pending on small/large-text devices |
| Actual physical printing | Not testable on emulator | Pending actual printer, driver and paper |

For a physical pilot, record phone model, Android/OEM version, screen size, APK checksum, signing fingerprint, package ID, version, and evidence for each row. Confirm install from the tester's file manager, small-screen/keyboard behavior, large text, PDF save/share, backup export and isolated restore, and actual printing if it will be promised. A share sheet opening is not evidence that a file was saved.

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TailorDesk';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get language => 'Language';

  @override
  String get languageSelectorLabel => 'App language: English or Urdu';

  @override
  String get provisionalUrduNotice =>
      'Urdu wording is provisional until reviewed by an Urdu-speaking tailor.';

  @override
  String get home => 'Home';

  @override
  String get orders => 'Orders';

  @override
  String get customers => 'Customers';

  @override
  String get more => 'More';

  @override
  String get karigars => 'Karigars';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get aboutTailorDesk => 'About TailorDesk';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving…';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get retry => 'Try Again';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get notes => 'Notes';

  @override
  String get address => 'Address';

  @override
  String get phone => 'Phone';

  @override
  String get name => 'Name';

  @override
  String get status => 'Status';

  @override
  String get date => 'Date';

  @override
  String get amount => 'Amount';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notAvailable => 'Not available';

  @override
  String get loading => 'Loading…';

  @override
  String customerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers',
      one: '1 customer',
      zero: 'No customers',
    );
    return '$_temp0';
  }

  @override
  String orderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
      zero: 'No orders',
    );
    return '$_temp0';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String stepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get validating => 'Validating…';

  @override
  String get setupTitle => 'Set up TailorDesk';

  @override
  String get yourShop => 'Your shop';

  @override
  String get measurements => 'Measurements';

  @override
  String get garments => 'Garments';

  @override
  String get garmentShalwarQameez => 'Shalwar Qameez';

  @override
  String get garmentCoat => 'Coat';

  @override
  String get garmentTrouser => 'Trouser/Pant';

  @override
  String get garmentShirt => 'Shirt';

  @override
  String get garmentWaistcoat => 'Waistcoat';

  @override
  String get garmentJacket => 'Jacket';

  @override
  String get garmentKurta => 'Kurta';

  @override
  String get garmentSherwani => 'Sherwani';

  @override
  String get measurementKameezLength => 'Kameez length';

  @override
  String get measurementLength => 'Length';

  @override
  String get measurementShoulder => 'Shoulder';

  @override
  String get measurementSleeve => 'Sleeve';

  @override
  String get measurementCollar => 'Collar';

  @override
  String get measurementChest => 'Chest';

  @override
  String get measurementWaist => 'Waist';

  @override
  String get measurementHip => 'Hip';

  @override
  String get measurementShalwarLength => 'Shalwar length';

  @override
  String get measurementAnkleOpening => 'Ankle opening';

  @override
  String get measurementOutseam => 'Outseam';

  @override
  String get measurementInseam => 'Inseam';

  @override
  String get measurementThigh => 'Thigh';

  @override
  String get measurementKnee => 'Knee';

  @override
  String get measurementCuff => 'Cuff';

  @override
  String get defaultPrices => 'Default prices';

  @override
  String get shopNameRequired => 'Shop name *';

  @override
  String get enterShopName => 'Enter the shop name';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get addressOptional => 'Address (optional)';

  @override
  String get measurementUnitPrompt =>
      'Choose the unit preselected for new measurement profiles.';

  @override
  String get inches => 'Inches';

  @override
  String get centimetres => 'Centimetres';

  @override
  String get enableGarmentsPrompt =>
      'Choose the garments your shop offers. You can change this later.';

  @override
  String get pricePerPiece => 'Price per piece';

  @override
  String get finishSetup => 'Finish setup';

  @override
  String get couldNotLoadSetup => 'Could not load setup.';

  @override
  String get shopDetails => 'Shop details';

  @override
  String get shopDetailsHelp =>
      'These details appear on receipts and work documents.';

  @override
  String get couldNotLoadSettings => 'Could not load settings';

  @override
  String get settingsUnchanged =>
      'Your saved shop details have not been changed.';

  @override
  String get defaultMeasurementUnit => 'Default measurement unit';

  @override
  String get receiptFooter => 'Receipt footer';

  @override
  String get receiptFooterHint => 'Thank you for your business.';

  @override
  String get saveShopDetails => 'Save shop details';

  @override
  String get shopDetailsSaved => 'Shop details saved.';

  @override
  String get shopDetailsSaveFailed => 'Could not save shop details. Try again.';

  @override
  String get garmentsTemplates => 'Garments & measurement templates';

  @override
  String get garmentsTemplatesSubtitle =>
      'Availability, order, prices, bilingual labels, and fields';

  @override
  String get documentLanguage => 'Document language';

  @override
  String get documentLanguageHelp =>
      'Receipt and work-slip language is independent from the app language.';

  @override
  String get documentEnglish => 'English';

  @override
  String get documentUrdu => 'Urdu';

  @override
  String get documentBilingual => 'Bilingual';

  @override
  String get presentationPreferences => 'Language & documents';

  @override
  String get preferenceSaved => 'Preference saved.';

  @override
  String get customer => 'Customer';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get customerName => 'Customer name *';

  @override
  String get phoneNumber => 'Phone number *';

  @override
  String get enterName => 'Enter a name';

  @override
  String get enterPhone => 'Enter a phone number';

  @override
  String get invalidPhone => 'Enter a valid phone number';

  @override
  String get customerSaved => 'Customer saved.';

  @override
  String get customerSaveFailed => 'Could not save customer. Try again.';

  @override
  String get searchCustomers => 'Search customers';

  @override
  String get noCustomers => 'No customers yet';

  @override
  String get noCustomersHelp =>
      'Add your first customer to begin measurements and orders.';

  @override
  String get noMatchingCustomers => 'No matching customers';

  @override
  String get customerDetails => 'Customer details';

  @override
  String get customerHistory => 'Customer history';

  @override
  String get deleteCustomer => 'Delete customer';

  @override
  String get deleteCustomerConfirm =>
      'Delete this customer? This cannot be undone.';

  @override
  String get customerDeleteBlocked =>
      'This customer has measurements or orders and cannot be deleted.';

  @override
  String get addMeasurement => 'Add measurement';

  @override
  String get editMeasurement => 'Add revision';

  @override
  String get measurementProfile => 'Measurement profile';

  @override
  String get profileName => 'Profile name *';

  @override
  String get garment => 'Garment';

  @override
  String get unit => 'Unit';

  @override
  String get measurementBasis => 'Measurement basis';

  @override
  String get bodyMeasurements => 'Body measurements';

  @override
  String get finishedGarmentMeasurements => 'Finished-garment measurements';

  @override
  String get fit => 'Fit';

  @override
  String get regularFit => 'Regular';

  @override
  String get slimFit => 'Slim';

  @override
  String get looseFit => 'Loose';

  @override
  String get styleInstructions => 'Style instructions';

  @override
  String get saveMeasurements => 'Save measurements';

  @override
  String get measurementSaved => 'Measurements saved.';

  @override
  String get measurementSaveFailed => 'Could not save measurements. Try again.';

  @override
  String measurementRequired(String label) {
    return 'Enter $label';
  }

  @override
  String measurementPositive(String label) {
    return '$label must be greater than zero';
  }

  @override
  String revisionNumber(int number) {
    return 'Revision $number';
  }

  @override
  String get revisionHistory => 'Revision history';

  @override
  String get noMeasurements => 'No measurements yet';

  @override
  String get noMeasurementsHelp =>
      'Create a garment measurement profile for this customer.';

  @override
  String get builtInLabel => 'Built-in';

  @override
  String get customLabel => 'Custom';

  @override
  String get englishLabel => 'English label';

  @override
  String get urduLabel => 'Urdu label (optional)';

  @override
  String get availableLabelFallback =>
      'If one language is empty, TailorDesk uses the available label.';

  @override
  String get customGarment => 'Custom garment';

  @override
  String get reviseTemplate => 'Revise Template';

  @override
  String get garmentName => 'Garment name *';

  @override
  String get garmentNameUrdu => 'Urdu garment name (optional)';

  @override
  String get measurementConvention => 'Measurement convention';

  @override
  String get noFormulaNotice =>
      'No allowances, conversions, or tailoring formulas are applied. Default fields await tailor approval.';

  @override
  String get fields => 'Fields';

  @override
  String get stableFieldId => 'Stable field ID';

  @override
  String get stableFieldIdHint => 'e.g. sleeve_length';

  @override
  String get displayLabel => 'English display label';

  @override
  String get displayLabelUrdu => 'Urdu display label (optional)';

  @override
  String get addField => 'Add field';

  @override
  String get createTemplate => 'Create template';

  @override
  String get saveNewVersion => 'Save new version';

  @override
  String get disabledGarmentsHelp =>
      'Disabled garments are hidden from new measurement profiles. Existing measurements and orders remain unchanged.';

  @override
  String templateVersion(int version, String basis) {
    return 'Template v$version · $basis';
  }

  @override
  String get setDefaultPrice => 'Set default price';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get archiveField => 'Archive field in the new version';

  @override
  String get newOrder => 'New Order';

  @override
  String get order => 'Order';

  @override
  String get orderDetails => 'Order details';

  @override
  String get selectCustomer => 'Select customer *';

  @override
  String get addGarment => 'Add garment';

  @override
  String get quantity => 'Quantity';

  @override
  String get stitchingPrice => 'Stitching price';

  @override
  String get clothCharge => 'Cloth charge';

  @override
  String get additionalCharge => 'Additional charge';

  @override
  String get additionalChargeDescription => 'Additional charge description';

  @override
  String get bookingDate => 'Booking date';

  @override
  String get deliveryDate => 'Delivery date';

  @override
  String get advancePayment => 'Advance payment';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get cash => 'Cash';

  @override
  String get manualBankTransfer => 'Manual bank transfer';

  @override
  String get saveOrder => 'Save order';

  @override
  String get orderSaved => 'Order saved.';

  @override
  String get orderSaveFailed => 'Could not save order. Try again.';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get noOrdersHelp =>
      'Create an order after adding a customer and measurements.';

  @override
  String get orderTotal => 'Order total';

  @override
  String get netPaid => 'Net paid';

  @override
  String get balance => 'Balance';

  @override
  String get paymentStatus => 'Payment status';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get partiallyPaid => 'Partially paid';

  @override
  String get paid => 'Paid';

  @override
  String get recordPayment => 'Record payment';

  @override
  String get recordRefund => 'Record refund';

  @override
  String get refund => 'Refund';

  @override
  String get payment => 'Payment';

  @override
  String get paymentRecorded => 'Payment recorded.';

  @override
  String get refundRecorded => 'Refund recorded.';

  @override
  String get booked => 'Booked';

  @override
  String get assigned => 'Assigned';

  @override
  String get inProgress => 'In progress';

  @override
  String get ready => 'Ready';

  @override
  String get partiallyDelivered => 'Partially delivered';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get markDelivered => 'Mark delivered';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get orderNotes => 'Order notes';

  @override
  String get paymentsRefunds => 'Payments & refunds';

  @override
  String get addKarigar => 'Add Karigar';

  @override
  String get editKarigar => 'Edit Karigar';

  @override
  String get workerName => 'Worker name *';

  @override
  String get skills => 'Skills';

  @override
  String get assignKarigar => 'Assign karigar';

  @override
  String get reassignKarigar => 'Reassign karigar';

  @override
  String get workInstructions => 'Work instructions';

  @override
  String get internalDeadline => 'Internal deadline';

  @override
  String get startWork => 'Start work';

  @override
  String get completeWork => 'Complete work';

  @override
  String get returnForAlteration => 'Return for alteration';

  @override
  String get assignmentHistory => 'Assignment history';

  @override
  String get noKarigars => 'No karigars yet';

  @override
  String get noKarigarsHelp => 'Add workers before assigning garment work.';

  @override
  String get dueOverdue => 'Due & Overdue';

  @override
  String get outstandingBalances => 'Outstanding Balances';

  @override
  String get collections => 'Collections';

  @override
  String get workload => 'Workload';

  @override
  String get today => 'Today';

  @override
  String get last7Days => '7 days';

  @override
  String get last30Days => '30 days';

  @override
  String get allTime => 'All time';

  @override
  String get customRange => 'Custom';

  @override
  String get grossPayments => 'Gross payments';

  @override
  String get refunds => 'Refunds';

  @override
  String get netCollections => 'Net collections';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get overdue => 'Overdue';

  @override
  String get dueToday => 'Due today';

  @override
  String daysOverdue(int count) {
    return '${count}d overdue';
  }

  @override
  String dueInDays(int count) {
    return 'In ${count}d';
  }

  @override
  String get upcoming => 'Upcoming';

  @override
  String get createBackup => 'Create and export backup';

  @override
  String get restoreBackup => 'Restore backup';

  @override
  String get backupDescription =>
      'Creates a versioned local archive with a consistent SQLite snapshot and SHA-256 checksum. The archive is not encrypted.';

  @override
  String get backupCreated =>
      'Backup created. Complete the share or save action to keep a copy outside this device.';

  @override
  String get backupCancelled => 'Backup export was cancelled.';

  @override
  String get backupFailed => 'Could not create the backup.';

  @override
  String get restoreWarning =>
      'Restore replaces all current business records. It does not merge records.';

  @override
  String get chooseBackup => 'Choose backup file';

  @override
  String get confirmRestore => 'Confirm restore';

  @override
  String get restoreComplete => 'Backup restored successfully.';

  @override
  String get restoreFailed => 'Could not restore this backup.';

  @override
  String get customerReceipt => 'Customer receipt';

  @override
  String get karigarSlip => 'Karigar work slip';

  @override
  String get combinedDocument => 'Combined document';

  @override
  String get print => 'Print';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get pdfExportComplete => 'PDF export completed.';

  @override
  String get pdfExportCancelled => 'PDF export was cancelled.';

  @override
  String get printingCancelled => 'Printing was cancelled.';

  @override
  String get printJobSent => 'Print job sent to the system.';

  @override
  String get orderReceiptHeading => 'ORDER RECEIPT';

  @override
  String get workSlipHeading => 'KARIGAR WORK SLIP';

  @override
  String get generated => 'Generated';

  @override
  String get manualTransferNotice =>
      'Manual bank transfers are recorded but not electronically verified.';

  @override
  String get financialPrivacyNotice =>
      'Karigar work slips do not include prices, payments, totals, or balances.';

  @override
  String versionLabel(String version) {
    return 'App version: $version';
  }

  @override
  String get offlineTagline => 'Your tailoring shop, organised offline.';

  @override
  String get aboutData =>
      'Your shop details appear on customer receipts. Business records are stored on this device. Export backups outside the phone regularly. There is no automatic cloud synchronisation.';

  @override
  String get openSourceNotices => 'Open-source notices';

  @override
  String get confirmDiscardTitle => 'Discard changes?';

  @override
  String get confirmDiscardBody => 'Your unsaved changes will be lost.';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get discard => 'Discard';

  @override
  String get tryAgain => 'Try again';

  @override
  String get couldNotLoad => 'Could not load this information.';

  @override
  String get savedDataUnchanged => 'Your saved data has not been changed.';

  @override
  String get notFound => 'Not found';

  @override
  String get overview => 'Overview';

  @override
  String get activeOrders => 'Active orders';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get workshop => 'Workshop';

  @override
  String get unassignedItems => 'Unassigned items';

  @override
  String get karigarOverdue => 'Karigar overdue';

  @override
  String get upcomingDeliveries => 'Upcoming deliveries';

  @override
  String get noUpcomingDeliveries => 'No upcoming deliveries';

  @override
  String get activeOrdersAppearHere => 'Active orders will appear here.';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get searchOrders => 'Search order, customer, or phone';

  @override
  String get all => 'All';

  @override
  String get sortCustomers => 'Sort customers';

  @override
  String get recentlyUpdated => 'Recently updated';

  @override
  String get nameAZ => 'Name A–Z';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get differentSearch => 'Try a different name or phone number.';

  @override
  String get appPreferencesSubtitle => 'App preferences and configuration';

  @override
  String get backupSubtitle => 'Export and import your data';

  @override
  String get reportsSubtitle => 'Business analytics and summaries';

  @override
  String get karigarsSubtitle => 'Manage tailors and workers';

  @override
  String get aboutSubtitle => 'App version and offline information';

  @override
  String get addCustomerFirst => 'Add a customer first';

  @override
  String get measurementCustomerHelp =>
      'Measurement profiles are always linked to a customer.';

  @override
  String get addCustomerAction => 'Add customer';

  @override
  String changePrompt(String item) {
    return 'Change $item?';
  }

  @override
  String get keepValues => 'Keep Values';

  @override
  String get clearAndChange => 'Clear and change';

  @override
  String get measurementContext => 'Measurement context';

  @override
  String get measurementContextHelp =>
      'Choose whether these are body or finished-garment measurements. Values are never converted, and the app does not add allowances.';

  @override
  String get clearMeasurementsWarning =>
      'Entered measurement values will be cleared. Values are never converted or reinterpreted automatically.';

  @override
  String get profileNameHint => 'For example, Everyday or Wedding';

  @override
  String get enterProfileName => 'Enter a profile name';

  @override
  String get styleHint => 'Collar, cuff, pocket, or finishing preferences';

  @override
  String get enterNumber => 'Enter a number';

  @override
  String get createNewRevision => 'Create new revision';

  @override
  String get revisionLoadFailed => 'Could not load revision history.';

  @override
  String get profileNotFound => 'Measurement profile not found';

  @override
  String get profileNotFoundHelp =>
      'This measurement profile is no longer available.';

  @override
  String stylePrefix(String value) {
    return 'Style: $value';
  }

  @override
  String notesPrefix(String value) {
    return 'Notes: $value';
  }

  @override
  String get customerNotFound => 'Customer not found';

  @override
  String get customerNotFoundHelp => 'This customer may have been deleted.';

  @override
  String get orderHistoryLoadFailed => 'Could not load order history.';

  @override
  String get noCustomerOrders => 'No orders for this customer yet.';

  @override
  String get viewHistory => 'View history';

  @override
  String get editCustomerAction => 'Edit customer';

  @override
  String get deleteBlockedOk => 'OK';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get orderNotFoundHelp => 'This order is not available.';

  @override
  String get printExportDocuments => 'Print or export documents';

  @override
  String get editOrderDetails => 'Edit delivery date and notes';

  @override
  String progressLabel(String value) {
    return 'Progress: $value';
  }

  @override
  String paymentLabel(String value) {
    return 'Payment: $value';
  }

  @override
  String get addPaymentRefund => 'Add payment or refund';

  @override
  String get garmentStatus => 'Garment status';

  @override
  String get balanceOutstandingTitle => 'Balance still outstanding';

  @override
  String get keepCurrentStatus => 'Keep current status';

  @override
  String get updateFailed => 'Could not save the change. Try again.';

  @override
  String get cancelOrderQuestion => 'Cancel order?';

  @override
  String get keepOrder => 'Keep order';

  @override
  String get noWorkSlips => 'No karigar work slips available';

  @override
  String get assignGarmentFirst => 'Assign a garment to a karigar first.';

  @override
  String combinedPageFor(String name) {
    return 'Combined page — $name';
  }

  @override
  String get enterPositiveAmount => 'Enter an amount greater than zero.';

  @override
  String get paymentExceedsBalance =>
      'Payment exceeds the outstanding balance.';

  @override
  String get refundExceedsPaid => 'Refund exceeds the net amount paid.';

  @override
  String get ledgerEntry => 'Payment ledger entry';

  @override
  String get method => 'Method';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get orderNotesOptional => 'Order notes (optional)';

  @override
  String get reviewOrder => 'Review order';

  @override
  String get goBack => 'Go back';

  @override
  String get addGarmentLine => 'Add at least one garment line.';

  @override
  String get advanceLimit => 'Enter an advance up to the order total.';

  @override
  String get orderAlreadySaved => 'This order was already saved.';

  @override
  String get couldNotLoadCustomers => 'Could not load customers.';

  @override
  String get couldNotLoadMeasurements => 'Could not load measurements.';

  @override
  String get createMeasurementsFirst => 'Create measurements first';

  @override
  String get removeGarment => 'Remove garment';

  @override
  String get advancePkr => 'Advance (PKR)';

  @override
  String get advanceMethod => 'Advance method';

  @override
  String get describeAdditionalCharge => 'Describe the additional charge.';

  @override
  String get addLine => 'Add line';

  @override
  String get receiptSubtitle => 'Charges, payments, and balance';

  @override
  String get activeOnly => 'Active only';

  @override
  String get searchKarigars => 'Search karigars…';

  @override
  String get garmentSkills => 'Garment skills';

  @override
  String get garmentSkillsHint => 'Shirt, trouser, waistcoat';

  @override
  String get deactivateBlocked =>
      'Finish or reassign active work before deactivating.';

  @override
  String get deactivateKarigarQuestion => 'Deactivate karigar?';

  @override
  String get reactivateKarigarQuestion => 'Reactivate karigar?';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get assignmentHistoryPreserved =>
      'Assignment history must be preserved. Deactivate this karigar instead.';

  @override
  String get deleteKarigarQuestion => 'Delete karigar?';

  @override
  String get karigarNotFound => 'Karigar not found';

  @override
  String get karigarNotFoundHelp => 'This karigar may have been deleted.';

  @override
  String get assignmentActions => 'Assignment actions';

  @override
  String get previewWorkSlip => 'Preview work slip';

  @override
  String get viewOrder => 'View order';

  @override
  String get noAssignments => 'No assignments yet';

  @override
  String get assignmentsAppearHere =>
      'Assigned garment items will appear here.';

  @override
  String get noActiveAssignment => 'No active karigar assignment.';

  @override
  String get alterationReason => 'Alteration reason *';

  @override
  String get reassignmentReason => 'Reassignment reason *';

  @override
  String get enterReassignmentReason => 'Enter a reason for reassignment.';

  @override
  String get inactiveKarigar => 'This karigar is inactive.';

  @override
  String get replaceLocalDataQuestion => 'Replace all local data?';

  @override
  String get replaceLocalData => 'Replace local data';

  @override
  String get reportsAnalytics => 'Reports & analytics';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get noDueOrders => 'No overdue or pending orders are due right now.';

  @override
  String get totalOutstanding => 'Total outstanding';

  @override
  String get customersWithDue => 'Customers with due';

  @override
  String customerBalancesCount(int count) {
    return 'Customer balances ($count)';
  }

  @override
  String get noOutstandingBalances => 'No outstanding balances';

  @override
  String get accountsPaidUp => 'All customer accounts are completely paid up!';

  @override
  String get grossCollections => 'Gross collections';

  @override
  String get totalRefunds => 'Total refunds';

  @override
  String get transactions => 'Transactions';

  @override
  String get cashCollected => 'Cash collected';

  @override
  String get bankTransferManual => 'Bank transfer (manual)';

  @override
  String ledgerEntriesCount(int count) {
    return 'Ledger entries ($count)';
  }

  @override
  String get noTransactions => 'No transactions in this period';

  @override
  String get activeWorkers => 'Active workers';

  @override
  String get activeWorkItems => 'Active work items';

  @override
  String activeItemsCount(int count) {
    return '$count active items';
  }

  @override
  String get completed => 'Completed';

  @override
  String get currentActiveWork => 'Current active work:';

  @override
  String get workHistory => 'Work history';

  @override
  String get overdueDeadlines => 'Overdue deadlines';

  @override
  String get assign => 'Assign';

  @override
  String workerWorkloadsCount(int count) {
    return 'Worker workloads ($count)';
  }

  @override
  String get noKarigarsRegistered => 'No karigars registered';

  @override
  String get pdfDocument => 'PDF document';

  @override
  String get printFailed => 'Could not print this document.';

  @override
  String get pdfExportFailed => 'Could not export this PDF.';

  @override
  String get documentGenerationFailed => 'Could not generate this document.';

  @override
  String get documentPreviewFailed => 'Could not preview this PDF.';

  @override
  String get webPdfHelp =>
      'The PDF was generated locally. Export it to view it in your browser.';

  @override
  String pageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get promised => 'Promised';

  @override
  String get frozenMeasurements => 'Frozen measurements';

  @override
  String get workNotes => 'Work notes';

  @override
  String get measurementNotes => 'Measurement notes';

  @override
  String get profile => 'Profile';

  @override
  String get paymentStatusDocument => 'Payment status';

  @override
  String get cancelledExcluded => 'Cancelled — excluded from charges';

  @override
  String get total => 'Total';

  @override
  String get page => 'Page';

  @override
  String get nameHint => 'For example, Ahmed Khan';

  @override
  String get phoneHint => 'For example, 0300 1234567';

  @override
  String get notesHint => 'Preferences or other useful details';

  @override
  String instructionsPrefix(String value) {
    return 'Instructions: $value';
  }

  @override
  String assignmentHistoryCount(int count) {
    return 'Assignment history ($count)';
  }

  @override
  String skillsPrefix(String value) {
    return 'Skills: $value';
  }

  @override
  String get brandMarkLabel => 'TailorDesk spool and thread';
}

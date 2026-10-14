import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TailorDesk'**
  String get appTitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get urdu;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'App language: English or Urdu'**
  String get languageSelectorLabel;

  /// No description provided for @provisionalUrduNotice.
  ///
  /// In en, this message translates to:
  /// **'Urdu wording is provisional until reviewed by an Urdu-speaking tailor.'**
  String get provisionalUrduNotice;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @karigars.
  ///
  /// In en, this message translates to:
  /// **'Karigars'**
  String get karigars;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @aboutTailorDesk.
  ///
  /// In en, this message translates to:
  /// **'About TailorDesk'**
  String get aboutTailorDesk;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'Read-only'**
  String get readOnly;

  /// No description provided for @readOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'A valid license is required to change business records.'**
  String get readOnlyMessage;

  /// No description provided for @customerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No customers} =1{1 customer} other{{count} customers}}'**
  String customerCount(int count);

  /// No description provided for @orderCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No orders} =1{1 order} other{{count} orders}}'**
  String orderCount(int count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @releaseNumber.
  ///
  /// In en, this message translates to:
  /// **'Release {number}'**
  String releaseNumber(int number);

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOf(int step, int total);

  /// No description provided for @activateTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate TailorDesk'**
  String get activateTitle;

  /// No description provided for @activatedTitle.
  ///
  /// In en, this message translates to:
  /// **'TailorDesk is activated'**
  String get activatedTitle;

  /// No description provided for @activationRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'A purchased license is required to create or change shop records. Activation works entirely offline.'**
  String get activationRequiredBody;

  /// No description provided for @renewLicenseBody.
  ///
  /// In en, this message translates to:
  /// **'Import a renewed license to extend maintenance or release entitlement.'**
  String get renewLicenseBody;

  /// No description provided for @installationCode.
  ///
  /// In en, this message translates to:
  /// **'Installation code'**
  String get installationCode;

  /// No description provided for @copyRequest.
  ///
  /// In en, this message translates to:
  /// **'Copy request'**
  String get copyRequest;

  /// No description provided for @shareRequest.
  ///
  /// In en, this message translates to:
  /// **'Share request'**
  String get shareRequest;

  /// No description provided for @downloadRequest.
  ///
  /// In en, this message translates to:
  /// **'Download activation request'**
  String get downloadRequest;

  /// No description provided for @importLicense.
  ///
  /// In en, this message translates to:
  /// **'Import license file'**
  String get importLicense;

  /// No description provided for @validating.
  ///
  /// In en, this message translates to:
  /// **'Validating…'**
  String get validating;

  /// No description provided for @activationCopied.
  ///
  /// In en, this message translates to:
  /// **'Activation request JSON copied.'**
  String get activationCopied;

  /// No description provided for @copyBlocked.
  ///
  /// In en, this message translates to:
  /// **'Copy was blocked by this browser. Use Download activation request instead.'**
  String get copyBlocked;

  /// No description provided for @shareUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Sharing files is not supported here. Use Download activation request instead.'**
  String get shareUnsupported;

  /// No description provided for @downloadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Download was cancelled.'**
  String get downloadCancelled;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Downloaded tailordesk-activation-request.json with the exact issuer JSON.'**
  String get downloadComplete;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The activation request could not be downloaded on this platform.'**
  String get downloadFailed;

  /// No description provided for @licenseActivated.
  ///
  /// In en, this message translates to:
  /// **'License activated.'**
  String get licenseActivated;

  /// No description provided for @licenseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'License unavailable'**
  String get licenseUnavailable;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @activationRequired.
  ///
  /// In en, this message translates to:
  /// **'Activation required'**
  String get activationRequired;

  /// No description provided for @licenseId.
  ///
  /// In en, this message translates to:
  /// **'License ID: {id}'**
  String licenseId(String id);

  /// No description provided for @maintenanceThrough.
  ///
  /// In en, this message translates to:
  /// **'Maintenance through: {date}'**
  String maintenanceThrough(String date);

  /// No description provided for @entitledRelease.
  ///
  /// In en, this message translates to:
  /// **'Entitled through release {maximum} · current {current}'**
  String entitledRelease(int maximum, int current);

  /// No description provided for @importRenewedLicense.
  ///
  /// In en, this message translates to:
  /// **'Import renewed license'**
  String get importRenewedLicense;

  /// No description provided for @openActivation.
  ///
  /// In en, this message translates to:
  /// **'Open activation'**
  String get openActivation;

  /// No description provided for @releaseMaintenanceNote.
  ///
  /// In en, this message translates to:
  /// **'Release {release} · Maintenance expiry does not disable an already entitled release.'**
  String releaseMaintenanceNote(int release);

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up TailorDesk'**
  String get setupTitle;

  /// No description provided for @yourShop.
  ///
  /// In en, this message translates to:
  /// **'Your shop'**
  String get yourShop;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @garments.
  ///
  /// In en, this message translates to:
  /// **'Garments'**
  String get garments;

  /// No description provided for @garmentShalwarQameez.
  ///
  /// In en, this message translates to:
  /// **'Shalwar Qameez'**
  String get garmentShalwarQameez;

  /// No description provided for @garmentCoat.
  ///
  /// In en, this message translates to:
  /// **'Coat'**
  String get garmentCoat;

  /// No description provided for @garmentTrouser.
  ///
  /// In en, this message translates to:
  /// **'Trouser/Pant'**
  String get garmentTrouser;

  /// No description provided for @garmentShirt.
  ///
  /// In en, this message translates to:
  /// **'Shirt'**
  String get garmentShirt;

  /// No description provided for @garmentWaistcoat.
  ///
  /// In en, this message translates to:
  /// **'Waistcoat'**
  String get garmentWaistcoat;

  /// No description provided for @garmentJacket.
  ///
  /// In en, this message translates to:
  /// **'Jacket'**
  String get garmentJacket;

  /// No description provided for @garmentKurta.
  ///
  /// In en, this message translates to:
  /// **'Kurta'**
  String get garmentKurta;

  /// No description provided for @garmentSherwani.
  ///
  /// In en, this message translates to:
  /// **'Sherwani'**
  String get garmentSherwani;

  /// No description provided for @measurementKameezLength.
  ///
  /// In en, this message translates to:
  /// **'Kameez length'**
  String get measurementKameezLength;

  /// No description provided for @measurementLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get measurementLength;

  /// No description provided for @measurementShoulder.
  ///
  /// In en, this message translates to:
  /// **'Shoulder'**
  String get measurementShoulder;

  /// No description provided for @measurementSleeve.
  ///
  /// In en, this message translates to:
  /// **'Sleeve'**
  String get measurementSleeve;

  /// No description provided for @measurementCollar.
  ///
  /// In en, this message translates to:
  /// **'Collar'**
  String get measurementCollar;

  /// No description provided for @measurementChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get measurementChest;

  /// No description provided for @measurementWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get measurementWaist;

  /// No description provided for @measurementHip.
  ///
  /// In en, this message translates to:
  /// **'Hip'**
  String get measurementHip;

  /// No description provided for @measurementShalwarLength.
  ///
  /// In en, this message translates to:
  /// **'Shalwar length'**
  String get measurementShalwarLength;

  /// No description provided for @measurementAnkleOpening.
  ///
  /// In en, this message translates to:
  /// **'Ankle opening'**
  String get measurementAnkleOpening;

  /// No description provided for @measurementOutseam.
  ///
  /// In en, this message translates to:
  /// **'Outseam'**
  String get measurementOutseam;

  /// No description provided for @measurementInseam.
  ///
  /// In en, this message translates to:
  /// **'Inseam'**
  String get measurementInseam;

  /// No description provided for @measurementThigh.
  ///
  /// In en, this message translates to:
  /// **'Thigh'**
  String get measurementThigh;

  /// No description provided for @measurementKnee.
  ///
  /// In en, this message translates to:
  /// **'Knee'**
  String get measurementKnee;

  /// No description provided for @measurementCuff.
  ///
  /// In en, this message translates to:
  /// **'Cuff'**
  String get measurementCuff;

  /// No description provided for @defaultPrices.
  ///
  /// In en, this message translates to:
  /// **'Default prices'**
  String get defaultPrices;

  /// No description provided for @shopNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop name *'**
  String get shopNameRequired;

  /// No description provided for @enterShopName.
  ///
  /// In en, this message translates to:
  /// **'Enter the shop name'**
  String get enterShopName;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @addressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get addressOptional;

  /// No description provided for @measurementUnitPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose the unit preselected for new measurement profiles.'**
  String get measurementUnitPrompt;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;

  /// No description provided for @centimetres.
  ///
  /// In en, this message translates to:
  /// **'Centimetres'**
  String get centimetres;

  /// No description provided for @enableGarmentsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose the garments your shop offers. You can change this later.'**
  String get enableGarmentsPrompt;

  /// No description provided for @pricePerPiece.
  ///
  /// In en, this message translates to:
  /// **'Price per piece'**
  String get pricePerPiece;

  /// No description provided for @finishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get finishSetup;

  /// No description provided for @couldNotLoadSetup.
  ///
  /// In en, this message translates to:
  /// **'Could not load setup.'**
  String get couldNotLoadSetup;

  /// No description provided for @shopDetails.
  ///
  /// In en, this message translates to:
  /// **'Shop details'**
  String get shopDetails;

  /// No description provided for @shopDetailsHelp.
  ///
  /// In en, this message translates to:
  /// **'These details appear on receipts and work documents.'**
  String get shopDetailsHelp;

  /// No description provided for @couldNotLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Could not load settings'**
  String get couldNotLoadSettings;

  /// No description provided for @settingsUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Your saved shop details have not been changed.'**
  String get settingsUnchanged;

  /// No description provided for @defaultMeasurementUnit.
  ///
  /// In en, this message translates to:
  /// **'Default measurement unit'**
  String get defaultMeasurementUnit;

  /// No description provided for @receiptFooter.
  ///
  /// In en, this message translates to:
  /// **'Receipt footer'**
  String get receiptFooter;

  /// No description provided for @receiptFooterHint.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business.'**
  String get receiptFooterHint;

  /// No description provided for @saveShopDetails.
  ///
  /// In en, this message translates to:
  /// **'Save shop details'**
  String get saveShopDetails;

  /// No description provided for @shopDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Shop details saved.'**
  String get shopDetailsSaved;

  /// No description provided for @shopDetailsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save shop details. Try again.'**
  String get shopDetailsSaveFailed;

  /// No description provided for @garmentsTemplates.
  ///
  /// In en, this message translates to:
  /// **'Garments & measurement templates'**
  String get garmentsTemplates;

  /// No description provided for @garmentsTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Availability, order, prices, bilingual labels, and fields'**
  String get garmentsTemplatesSubtitle;

  /// No description provided for @documentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Document language'**
  String get documentLanguage;

  /// No description provided for @documentLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Receipt and work-slip language is independent from the app language.'**
  String get documentLanguageHelp;

  /// No description provided for @documentEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get documentEnglish;

  /// No description provided for @documentUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get documentUrdu;

  /// No description provided for @documentBilingual.
  ///
  /// In en, this message translates to:
  /// **'Bilingual'**
  String get documentBilingual;

  /// No description provided for @presentationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Language & documents'**
  String get presentationPreferences;

  /// No description provided for @preferenceSaved.
  ///
  /// In en, this message translates to:
  /// **'Preference saved.'**
  String get preferenceSaved;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name *'**
  String get customerName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number *'**
  String get phoneNumber;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get enterPhone;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @customerSaved.
  ///
  /// In en, this message translates to:
  /// **'Customer saved.'**
  String get customerSaved;

  /// No description provided for @customerSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save customer. Try again.'**
  String get customerSaveFailed;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers'**
  String get searchCustomers;

  /// No description provided for @noCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomers;

  /// No description provided for @noCustomersHelp.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer to begin measurements and orders.'**
  String get noCustomersHelp;

  /// No description provided for @noMatchingCustomers.
  ///
  /// In en, this message translates to:
  /// **'No matching customers'**
  String get noMatchingCustomers;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer details'**
  String get customerDetails;

  /// No description provided for @customerHistory.
  ///
  /// In en, this message translates to:
  /// **'Customer history'**
  String get customerHistory;

  /// No description provided for @deleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete customer'**
  String get deleteCustomer;

  /// No description provided for @deleteCustomerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this customer? This cannot be undone.'**
  String get deleteCustomerConfirm;

  /// No description provided for @customerDeleteBlocked.
  ///
  /// In en, this message translates to:
  /// **'This customer has measurements or orders and cannot be deleted.'**
  String get customerDeleteBlocked;

  /// No description provided for @addMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get addMeasurement;

  /// No description provided for @editMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Add revision'**
  String get editMeasurement;

  /// No description provided for @measurementProfile.
  ///
  /// In en, this message translates to:
  /// **'Measurement profile'**
  String get measurementProfile;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Profile name *'**
  String get profileName;

  /// No description provided for @garment.
  ///
  /// In en, this message translates to:
  /// **'Garment'**
  String get garment;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @measurementBasis.
  ///
  /// In en, this message translates to:
  /// **'Measurement basis'**
  String get measurementBasis;

  /// No description provided for @bodyMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get bodyMeasurements;

  /// No description provided for @finishedGarmentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Finished-garment measurements'**
  String get finishedGarmentMeasurements;

  /// No description provided for @fit.
  ///
  /// In en, this message translates to:
  /// **'Fit'**
  String get fit;

  /// No description provided for @regularFit.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regularFit;

  /// No description provided for @slimFit.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get slimFit;

  /// No description provided for @looseFit.
  ///
  /// In en, this message translates to:
  /// **'Loose'**
  String get looseFit;

  /// No description provided for @styleInstructions.
  ///
  /// In en, this message translates to:
  /// **'Style instructions'**
  String get styleInstructions;

  /// No description provided for @saveMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Save measurements'**
  String get saveMeasurements;

  /// No description provided for @measurementSaved.
  ///
  /// In en, this message translates to:
  /// **'Measurements saved.'**
  String get measurementSaved;

  /// No description provided for @measurementSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save measurements. Try again.'**
  String get measurementSaveFailed;

  /// No description provided for @measurementRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter {label}'**
  String measurementRequired(String label);

  /// No description provided for @measurementPositive.
  ///
  /// In en, this message translates to:
  /// **'{label} must be greater than zero'**
  String measurementPositive(String label);

  /// No description provided for @revisionNumber.
  ///
  /// In en, this message translates to:
  /// **'Revision {number}'**
  String revisionNumber(int number);

  /// No description provided for @revisionHistory.
  ///
  /// In en, this message translates to:
  /// **'Revision history'**
  String get revisionHistory;

  /// No description provided for @noMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get noMeasurements;

  /// No description provided for @noMeasurementsHelp.
  ///
  /// In en, this message translates to:
  /// **'Create a garment measurement profile for this customer.'**
  String get noMeasurementsHelp;

  /// No description provided for @builtInLabel.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get builtInLabel;

  /// No description provided for @customLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English label'**
  String get englishLabel;

  /// No description provided for @urduLabel.
  ///
  /// In en, this message translates to:
  /// **'Urdu label (optional)'**
  String get urduLabel;

  /// No description provided for @availableLabelFallback.
  ///
  /// In en, this message translates to:
  /// **'If one language is empty, TailorDesk uses the available label.'**
  String get availableLabelFallback;

  /// No description provided for @customGarment.
  ///
  /// In en, this message translates to:
  /// **'Custom garment'**
  String get customGarment;

  /// No description provided for @reviseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Revise Template'**
  String get reviseTemplate;

  /// No description provided for @garmentName.
  ///
  /// In en, this message translates to:
  /// **'Garment name *'**
  String get garmentName;

  /// No description provided for @garmentNameUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu garment name (optional)'**
  String get garmentNameUrdu;

  /// No description provided for @measurementConvention.
  ///
  /// In en, this message translates to:
  /// **'Measurement convention'**
  String get measurementConvention;

  /// No description provided for @noFormulaNotice.
  ///
  /// In en, this message translates to:
  /// **'No allowances, conversions, or tailoring formulas are applied. Default fields await tailor approval.'**
  String get noFormulaNotice;

  /// No description provided for @fields.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get fields;

  /// No description provided for @stableFieldId.
  ///
  /// In en, this message translates to:
  /// **'Stable field ID'**
  String get stableFieldId;

  /// No description provided for @stableFieldIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. sleeve_length'**
  String get stableFieldIdHint;

  /// No description provided for @displayLabel.
  ///
  /// In en, this message translates to:
  /// **'English display label'**
  String get displayLabel;

  /// No description provided for @displayLabelUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu display label (optional)'**
  String get displayLabelUrdu;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get addField;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create template'**
  String get createTemplate;

  /// No description provided for @saveNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Save new version'**
  String get saveNewVersion;

  /// No description provided for @disabledGarmentsHelp.
  ///
  /// In en, this message translates to:
  /// **'Disabled garments are hidden from new measurement profiles. Existing measurements and orders remain unchanged.'**
  String get disabledGarmentsHelp;

  /// No description provided for @templateVersion.
  ///
  /// In en, this message translates to:
  /// **'Template v{version} · {basis}'**
  String templateVersion(int version, String basis);

  /// No description provided for @setDefaultPrice.
  ///
  /// In en, this message translates to:
  /// **'Set default price'**
  String get setDefaultPrice;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @archiveField.
  ///
  /// In en, this message translates to:
  /// **'Archive field in the new version'**
  String get archiveField;

  /// No description provided for @newOrder.
  ///
  /// In en, this message translates to:
  /// **'New Order'**
  String get newOrder;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetails;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer *'**
  String get selectCustomer;

  /// No description provided for @addGarment.
  ///
  /// In en, this message translates to:
  /// **'Add garment'**
  String get addGarment;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @stitchingPrice.
  ///
  /// In en, this message translates to:
  /// **'Stitching price'**
  String get stitchingPrice;

  /// No description provided for @clothCharge.
  ///
  /// In en, this message translates to:
  /// **'Cloth charge'**
  String get clothCharge;

  /// No description provided for @additionalCharge.
  ///
  /// In en, this message translates to:
  /// **'Additional charge'**
  String get additionalCharge;

  /// No description provided for @additionalChargeDescription.
  ///
  /// In en, this message translates to:
  /// **'Additional charge description'**
  String get additionalChargeDescription;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Booking date'**
  String get bookingDate;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get deliveryDate;

  /// No description provided for @advancePayment.
  ///
  /// In en, this message translates to:
  /// **'Advance payment'**
  String get advancePayment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @manualBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Manual bank transfer'**
  String get manualBankTransfer;

  /// No description provided for @saveOrder.
  ///
  /// In en, this message translates to:
  /// **'Save order'**
  String get saveOrder;

  /// No description provided for @orderSaved.
  ///
  /// In en, this message translates to:
  /// **'Order saved.'**
  String get orderSaved;

  /// No description provided for @orderSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save order. Try again.'**
  String get orderSaveFailed;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @noOrdersHelp.
  ///
  /// In en, this message translates to:
  /// **'Create an order after adding a customer and measurements.'**
  String get noOrdersHelp;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get orderTotal;

  /// No description provided for @netPaid.
  ///
  /// In en, this message translates to:
  /// **'Net paid'**
  String get netPaid;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get paymentStatus;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @partiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially paid'**
  String get partiallyPaid;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get recordPayment;

  /// No description provided for @recordRefund.
  ///
  /// In en, this message translates to:
  /// **'Record refund'**
  String get recordRefund;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get paymentRecorded;

  /// No description provided for @refundRecorded.
  ///
  /// In en, this message translates to:
  /// **'Refund recorded.'**
  String get refundRecorded;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @partiallyDelivered.
  ///
  /// In en, this message translates to:
  /// **'Partially delivered'**
  String get partiallyDelivered;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @markDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark delivered'**
  String get markDelivered;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order notes'**
  String get orderNotes;

  /// No description provided for @paymentsRefunds.
  ///
  /// In en, this message translates to:
  /// **'Payments & refunds'**
  String get paymentsRefunds;

  /// No description provided for @addKarigar.
  ///
  /// In en, this message translates to:
  /// **'Add Karigar'**
  String get addKarigar;

  /// No description provided for @editKarigar.
  ///
  /// In en, this message translates to:
  /// **'Edit Karigar'**
  String get editKarigar;

  /// No description provided for @workerName.
  ///
  /// In en, this message translates to:
  /// **'Worker name *'**
  String get workerName;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @assignKarigar.
  ///
  /// In en, this message translates to:
  /// **'Assign karigar'**
  String get assignKarigar;

  /// No description provided for @reassignKarigar.
  ///
  /// In en, this message translates to:
  /// **'Reassign karigar'**
  String get reassignKarigar;

  /// No description provided for @workInstructions.
  ///
  /// In en, this message translates to:
  /// **'Work instructions'**
  String get workInstructions;

  /// No description provided for @internalDeadline.
  ///
  /// In en, this message translates to:
  /// **'Internal deadline'**
  String get internalDeadline;

  /// No description provided for @startWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get startWork;

  /// No description provided for @completeWork.
  ///
  /// In en, this message translates to:
  /// **'Complete work'**
  String get completeWork;

  /// No description provided for @returnForAlteration.
  ///
  /// In en, this message translates to:
  /// **'Return for alteration'**
  String get returnForAlteration;

  /// No description provided for @assignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Assignment history'**
  String get assignmentHistory;

  /// No description provided for @noKarigars.
  ///
  /// In en, this message translates to:
  /// **'No karigars yet'**
  String get noKarigars;

  /// No description provided for @noKarigarsHelp.
  ///
  /// In en, this message translates to:
  /// **'Add workers before assigning garment work.'**
  String get noKarigarsHelp;

  /// No description provided for @dueOverdue.
  ///
  /// In en, this message translates to:
  /// **'Due & Overdue'**
  String get dueOverdue;

  /// No description provided for @outstandingBalances.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balances'**
  String get outstandingBalances;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @workload.
  ///
  /// In en, this message translates to:
  /// **'Workload'**
  String get workload;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get last30Days;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customRange;

  /// No description provided for @grossPayments.
  ///
  /// In en, this message translates to:
  /// **'Gross payments'**
  String get grossPayments;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @netCollections.
  ///
  /// In en, this message translates to:
  /// **'Net collections'**
  String get netCollections;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create and export backup'**
  String get createBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackup;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'Backups include business records and settings, but never copy activation. Backup files are not encrypted.'**
  String get backupDescription;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created. Complete the share or save action to keep a copy outside this device.'**
  String get backupCreated;

  /// No description provided for @backupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Backup export was cancelled.'**
  String get backupCancelled;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the backup.'**
  String get backupFailed;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'Restore replaces all current business records. It does not replace this installation\'s license.'**
  String get restoreWarning;

  /// No description provided for @chooseBackup.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get chooseBackup;

  /// No description provided for @confirmRestore.
  ///
  /// In en, this message translates to:
  /// **'Confirm restore'**
  String get confirmRestore;

  /// No description provided for @restoreComplete.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully.'**
  String get restoreComplete;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore this backup.'**
  String get restoreFailed;

  /// No description provided for @customerReceipt.
  ///
  /// In en, this message translates to:
  /// **'Customer receipt'**
  String get customerReceipt;

  /// No description provided for @karigarSlip.
  ///
  /// In en, this message translates to:
  /// **'Karigar work slip'**
  String get karigarSlip;

  /// No description provided for @combinedDocument.
  ///
  /// In en, this message translates to:
  /// **'Combined document'**
  String get combinedDocument;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @pdfExportComplete.
  ///
  /// In en, this message translates to:
  /// **'PDF export completed.'**
  String get pdfExportComplete;

  /// No description provided for @pdfExportCancelled.
  ///
  /// In en, this message translates to:
  /// **'PDF export was cancelled.'**
  String get pdfExportCancelled;

  /// No description provided for @printingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Printing was cancelled.'**
  String get printingCancelled;

  /// No description provided for @printJobSent.
  ///
  /// In en, this message translates to:
  /// **'Print job sent to the system.'**
  String get printJobSent;

  /// No description provided for @orderReceiptHeading.
  ///
  /// In en, this message translates to:
  /// **'ORDER RECEIPT'**
  String get orderReceiptHeading;

  /// No description provided for @workSlipHeading.
  ///
  /// In en, this message translates to:
  /// **'KARIGAR WORK SLIP'**
  String get workSlipHeading;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// No description provided for @manualTransferNotice.
  ///
  /// In en, this message translates to:
  /// **'Manual bank transfers are recorded but not electronically verified.'**
  String get manualTransferNotice;

  /// No description provided for @financialPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Karigar work slips do not include prices, payments, totals, or balances.'**
  String get financialPrivacyNotice;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version: {version}'**
  String versionLabel(String version);

  /// No description provided for @licenseReleaseSequence.
  ///
  /// In en, this message translates to:
  /// **'License release sequence: {sequence}'**
  String licenseReleaseSequence(int sequence);

  /// No description provided for @offlineTagline.
  ///
  /// In en, this message translates to:
  /// **'Your tailoring shop, organised offline.'**
  String get offlineTagline;

  /// No description provided for @aboutData.
  ///
  /// In en, this message translates to:
  /// **'Your shop details appear on customer receipts. Business records are stored on this device. Export backups outside the phone regularly. There is no automatic cloud synchronisation.'**
  String get aboutData;

  /// No description provided for @openSourceNotices.
  ///
  /// In en, this message translates to:
  /// **'Open-source notices'**
  String get openSourceNotices;

  /// No description provided for @confirmDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get confirmDiscardTitle;

  /// No description provided for @confirmDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your unsaved changes will be lost.'**
  String get confirmDiscardBody;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @couldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load this information.'**
  String get couldNotLoad;

  /// No description provided for @savedDataUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Your saved data has not been changed.'**
  String get savedDataUnchanged;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @activeOrders.
  ///
  /// In en, this message translates to:
  /// **'Active orders'**
  String get activeOrders;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @workshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get workshop;

  /// No description provided for @unassignedItems.
  ///
  /// In en, this message translates to:
  /// **'Unassigned items'**
  String get unassignedItems;

  /// No description provided for @karigarOverdue.
  ///
  /// In en, this message translates to:
  /// **'Karigar overdue'**
  String get karigarOverdue;

  /// No description provided for @upcomingDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Upcoming deliveries'**
  String get upcomingDeliveries;

  /// No description provided for @noUpcomingDeliveries.
  ///
  /// In en, this message translates to:
  /// **'No upcoming deliveries'**
  String get noUpcomingDeliveries;

  /// No description provided for @activeOrdersAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Active orders will appear here.'**
  String get activeOrdersAppearHere;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @searchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search order, customer, or phone'**
  String get searchOrders;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @sortCustomers.
  ///
  /// In en, this message translates to:
  /// **'Sort customers'**
  String get sortCustomers;

  /// No description provided for @recentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get recentlyUpdated;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get nameAZ;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @differentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or phone number.'**
  String get differentSearch;

  /// No description provided for @appPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App preferences and configuration'**
  String get appPreferencesSubtitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export and import your data'**
  String get backupSubtitle;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Business analytics and summaries'**
  String get reportsSubtitle;

  /// No description provided for @karigarsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage tailors and workers'**
  String get karigarsSubtitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App version and offline information'**
  String get aboutSubtitle;

  /// No description provided for @addCustomerFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a customer first'**
  String get addCustomerFirst;

  /// No description provided for @measurementCustomerHelp.
  ///
  /// In en, this message translates to:
  /// **'Measurement profiles are always linked to a customer.'**
  String get measurementCustomerHelp;

  /// No description provided for @addCustomerAction.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get addCustomerAction;

  /// No description provided for @changePrompt.
  ///
  /// In en, this message translates to:
  /// **'Change {item}?'**
  String changePrompt(String item);

  /// No description provided for @keepValues.
  ///
  /// In en, this message translates to:
  /// **'Keep Values'**
  String get keepValues;

  /// No description provided for @clearAndChange.
  ///
  /// In en, this message translates to:
  /// **'Clear and change'**
  String get clearAndChange;

  /// No description provided for @measurementContext.
  ///
  /// In en, this message translates to:
  /// **'Measurement context'**
  String get measurementContext;

  /// No description provided for @measurementContextHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose whether these are body or finished-garment measurements. Values are never converted, and the app does not add allowances.'**
  String get measurementContextHelp;

  /// No description provided for @clearMeasurementsWarning.
  ///
  /// In en, this message translates to:
  /// **'Entered measurement values will be cleared. Values are never converted or reinterpreted automatically.'**
  String get clearMeasurementsWarning;

  /// No description provided for @profileNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Everyday or Wedding'**
  String get profileNameHint;

  /// No description provided for @enterProfileName.
  ///
  /// In en, this message translates to:
  /// **'Enter a profile name'**
  String get enterProfileName;

  /// No description provided for @styleHint.
  ///
  /// In en, this message translates to:
  /// **'Collar, cuff, pocket, or finishing preferences'**
  String get styleHint;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enterNumber;

  /// No description provided for @createNewRevision.
  ///
  /// In en, this message translates to:
  /// **'Create new revision'**
  String get createNewRevision;

  /// No description provided for @revisionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load revision history.'**
  String get revisionLoadFailed;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Measurement profile not found'**
  String get profileNotFound;

  /// No description provided for @profileNotFoundHelp.
  ///
  /// In en, this message translates to:
  /// **'This measurement profile is no longer available.'**
  String get profileNotFoundHelp;

  /// No description provided for @stylePrefix.
  ///
  /// In en, this message translates to:
  /// **'Style: {value}'**
  String stylePrefix(String value);

  /// No description provided for @notesPrefix.
  ///
  /// In en, this message translates to:
  /// **'Notes: {value}'**
  String notesPrefix(String value);

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// No description provided for @customerNotFoundHelp.
  ///
  /// In en, this message translates to:
  /// **'This customer may have been deleted.'**
  String get customerNotFoundHelp;

  /// No description provided for @orderHistoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load order history.'**
  String get orderHistoryLoadFailed;

  /// No description provided for @noCustomerOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders for this customer yet.'**
  String get noCustomerOrders;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @editCustomerAction.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get editCustomerAction;

  /// No description provided for @deleteBlockedOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get deleteBlockedOk;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @orderNotFoundHelp.
  ///
  /// In en, this message translates to:
  /// **'This order is not available.'**
  String get orderNotFoundHelp;

  /// No description provided for @printExportDocuments.
  ///
  /// In en, this message translates to:
  /// **'Print or export documents'**
  String get printExportDocuments;

  /// No description provided for @editOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit delivery date and notes'**
  String get editOrderDetails;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress: {value}'**
  String progressLabel(String value);

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment: {value}'**
  String paymentLabel(String value);

  /// No description provided for @addPaymentRefund.
  ///
  /// In en, this message translates to:
  /// **'Add payment or refund'**
  String get addPaymentRefund;

  /// No description provided for @garmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Garment status'**
  String get garmentStatus;

  /// No description provided for @balanceOutstandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance still outstanding'**
  String get balanceOutstandingTitle;

  /// No description provided for @keepCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Keep current status'**
  String get keepCurrentStatus;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the change. Try again.'**
  String get updateFailed;

  /// No description provided for @cancelOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Cancel order?'**
  String get cancelOrderQuestion;

  /// No description provided for @keepOrder.
  ///
  /// In en, this message translates to:
  /// **'Keep order'**
  String get keepOrder;

  /// No description provided for @noWorkSlips.
  ///
  /// In en, this message translates to:
  /// **'No karigar work slips available'**
  String get noWorkSlips;

  /// No description provided for @assignGarmentFirst.
  ///
  /// In en, this message translates to:
  /// **'Assign a garment to a karigar first.'**
  String get assignGarmentFirst;

  /// No description provided for @combinedPageFor.
  ///
  /// In en, this message translates to:
  /// **'Combined page — {name}'**
  String combinedPageFor(String name);

  /// No description provided for @enterPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get enterPositiveAmount;

  /// No description provided for @paymentExceedsBalance.
  ///
  /// In en, this message translates to:
  /// **'Payment exceeds the outstanding balance.'**
  String get paymentExceedsBalance;

  /// No description provided for @refundExceedsPaid.
  ///
  /// In en, this message translates to:
  /// **'Refund exceeds the net amount paid.'**
  String get refundExceedsPaid;

  /// No description provided for @ledgerEntry.
  ///
  /// In en, this message translates to:
  /// **'Payment ledger entry'**
  String get ledgerEntry;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @orderNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Order notes (optional)'**
  String get orderNotesOptional;

  /// No description provided for @reviewOrder.
  ///
  /// In en, this message translates to:
  /// **'Review order'**
  String get reviewOrder;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @addGarmentLine.
  ///
  /// In en, this message translates to:
  /// **'Add at least one garment line.'**
  String get addGarmentLine;

  /// No description provided for @advanceLimit.
  ///
  /// In en, this message translates to:
  /// **'Enter an advance up to the order total.'**
  String get advanceLimit;

  /// No description provided for @orderAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'This order was already saved.'**
  String get orderAlreadySaved;

  /// No description provided for @couldNotLoadCustomers.
  ///
  /// In en, this message translates to:
  /// **'Could not load customers.'**
  String get couldNotLoadCustomers;

  /// No description provided for @couldNotLoadMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Could not load measurements.'**
  String get couldNotLoadMeasurements;

  /// No description provided for @createMeasurementsFirst.
  ///
  /// In en, this message translates to:
  /// **'Create measurements first'**
  String get createMeasurementsFirst;

  /// No description provided for @removeGarment.
  ///
  /// In en, this message translates to:
  /// **'Remove garment'**
  String get removeGarment;

  /// No description provided for @advancePkr.
  ///
  /// In en, this message translates to:
  /// **'Advance (PKR)'**
  String get advancePkr;

  /// No description provided for @advanceMethod.
  ///
  /// In en, this message translates to:
  /// **'Advance method'**
  String get advanceMethod;

  /// No description provided for @describeAdditionalCharge.
  ///
  /// In en, this message translates to:
  /// **'Describe the additional charge.'**
  String get describeAdditionalCharge;

  /// No description provided for @addLine.
  ///
  /// In en, this message translates to:
  /// **'Add line'**
  String get addLine;

  /// No description provided for @receiptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Charges, payments, and balance'**
  String get receiptSubtitle;

  /// No description provided for @activeOnly.
  ///
  /// In en, this message translates to:
  /// **'Active only'**
  String get activeOnly;

  /// No description provided for @searchKarigars.
  ///
  /// In en, this message translates to:
  /// **'Search karigars…'**
  String get searchKarigars;

  /// No description provided for @garmentSkills.
  ///
  /// In en, this message translates to:
  /// **'Garment skills'**
  String get garmentSkills;

  /// No description provided for @garmentSkillsHint.
  ///
  /// In en, this message translates to:
  /// **'Shirt, trouser, waistcoat'**
  String get garmentSkillsHint;

  /// No description provided for @deactivateBlocked.
  ///
  /// In en, this message translates to:
  /// **'Finish or reassign active work before deactivating.'**
  String get deactivateBlocked;

  /// No description provided for @deleteKarigarQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete karigar?'**
  String get deleteKarigarQuestion;

  /// No description provided for @karigarNotFound.
  ///
  /// In en, this message translates to:
  /// **'Karigar not found'**
  String get karigarNotFound;

  /// No description provided for @karigarNotFoundHelp.
  ///
  /// In en, this message translates to:
  /// **'This karigar may have been deleted.'**
  String get karigarNotFoundHelp;

  /// No description provided for @assignmentActions.
  ///
  /// In en, this message translates to:
  /// **'Assignment actions'**
  String get assignmentActions;

  /// No description provided for @previewWorkSlip.
  ///
  /// In en, this message translates to:
  /// **'Preview work slip'**
  String get previewWorkSlip;

  /// No description provided for @viewOrder.
  ///
  /// In en, this message translates to:
  /// **'View order'**
  String get viewOrder;

  /// No description provided for @noAssignments.
  ///
  /// In en, this message translates to:
  /// **'No assignments yet'**
  String get noAssignments;

  /// No description provided for @assignmentsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Assigned garment items will appear here.'**
  String get assignmentsAppearHere;

  /// No description provided for @noActiveAssignment.
  ///
  /// In en, this message translates to:
  /// **'No active karigar assignment.'**
  String get noActiveAssignment;

  /// No description provided for @alterationReason.
  ///
  /// In en, this message translates to:
  /// **'Alteration reason *'**
  String get alterationReason;

  /// No description provided for @reassignmentReason.
  ///
  /// In en, this message translates to:
  /// **'Reassignment reason *'**
  String get reassignmentReason;

  /// No description provided for @enterReassignmentReason.
  ///
  /// In en, this message translates to:
  /// **'Enter a reason for reassignment.'**
  String get enterReassignmentReason;

  /// No description provided for @inactiveKarigar.
  ///
  /// In en, this message translates to:
  /// **'This karigar is inactive.'**
  String get inactiveKarigar;

  /// No description provided for @replaceLocalDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Replace all local data?'**
  String get replaceLocalDataQuestion;

  /// No description provided for @replaceLocalData.
  ///
  /// In en, this message translates to:
  /// **'Replace local data'**
  String get replaceLocalData;

  /// No description provided for @reportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Reports & analytics'**
  String get reportsAnalytics;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// No description provided for @noDueOrders.
  ///
  /// In en, this message translates to:
  /// **'No overdue or pending orders are due right now.'**
  String get noDueOrders;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total outstanding'**
  String get totalOutstanding;

  /// No description provided for @customersWithDue.
  ///
  /// In en, this message translates to:
  /// **'Customers with due'**
  String get customersWithDue;

  /// No description provided for @customerBalancesCount.
  ///
  /// In en, this message translates to:
  /// **'Customer balances ({count})'**
  String customerBalancesCount(int count);

  /// No description provided for @noOutstandingBalances.
  ///
  /// In en, this message translates to:
  /// **'No outstanding balances'**
  String get noOutstandingBalances;

  /// No description provided for @accountsPaidUp.
  ///
  /// In en, this message translates to:
  /// **'All customer accounts are completely paid up!'**
  String get accountsPaidUp;

  /// No description provided for @grossCollections.
  ///
  /// In en, this message translates to:
  /// **'Gross collections'**
  String get grossCollections;

  /// No description provided for @totalRefunds.
  ///
  /// In en, this message translates to:
  /// **'Total refunds'**
  String get totalRefunds;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @cashCollected.
  ///
  /// In en, this message translates to:
  /// **'Cash collected'**
  String get cashCollected;

  /// No description provided for @bankTransferManual.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer (manual)'**
  String get bankTransferManual;

  /// No description provided for @ledgerEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'Ledger entries ({count})'**
  String ledgerEntriesCount(int count);

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period'**
  String get noTransactions;

  /// No description provided for @activeWorkers.
  ///
  /// In en, this message translates to:
  /// **'Active workers'**
  String get activeWorkers;

  /// No description provided for @activeWorkItems.
  ///
  /// In en, this message translates to:
  /// **'Active work items'**
  String get activeWorkItems;

  /// No description provided for @overdueDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Overdue deadlines'**
  String get overdueDeadlines;

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @workerWorkloadsCount.
  ///
  /// In en, this message translates to:
  /// **'Worker workloads ({count})'**
  String workerWorkloadsCount(int count);

  /// No description provided for @noKarigarsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No karigars registered'**
  String get noKarigarsRegistered;

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get pdfDocument;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not print this document.'**
  String get printFailed;

  /// No description provided for @pdfExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export this PDF.'**
  String get pdfExportFailed;

  /// No description provided for @documentGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate this document.'**
  String get documentGenerationFailed;

  /// No description provided for @documentPreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not preview this PDF.'**
  String get documentPreviewFailed;

  /// No description provided for @webPdfHelp.
  ///
  /// In en, this message translates to:
  /// **'The PDF was generated locally. Export it to view it in your browser.'**
  String get webPdfHelp;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pageOf(int page, int pages);

  /// No description provided for @promised.
  ///
  /// In en, this message translates to:
  /// **'Promised'**
  String get promised;

  /// No description provided for @frozenMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Frozen measurements'**
  String get frozenMeasurements;

  /// No description provided for @workNotes.
  ///
  /// In en, this message translates to:
  /// **'Work notes'**
  String get workNotes;

  /// No description provided for @measurementNotes.
  ///
  /// In en, this message translates to:
  /// **'Measurement notes'**
  String get measurementNotes;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @paymentStatusDocument.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get paymentStatusDocument;

  /// No description provided for @cancelledExcluded.
  ///
  /// In en, this message translates to:
  /// **'Cancelled — excluded from charges'**
  String get cancelledExcluded;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Ahmed Khan'**
  String get nameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'For example, 0300 1234567'**
  String get phoneHint;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Preferences or other useful details'**
  String get notesHint;

  /// No description provided for @activationShared.
  ///
  /// In en, this message translates to:
  /// **'Activation request shared.'**
  String get activationShared;

  /// No description provided for @activationShareSubject.
  ///
  /// In en, this message translates to:
  /// **'TailorDesk activation request'**
  String get activationShareSubject;

  /// No description provided for @activationShareBody.
  ///
  /// In en, this message translates to:
  /// **'Send this request to the TailorDesk license issuer.'**
  String get activationShareBody;

  /// No description provided for @licenseImportFailed.
  ///
  /// In en, this message translates to:
  /// **'The license could not be imported. The current activation was not changed.'**
  String get licenseImportFailed;

  /// No description provided for @licenseNotImported.
  ///
  /// In en, this message translates to:
  /// **'No license has been imported for this installation.'**
  String get licenseNotImported;

  /// No description provided for @licenseSavedUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The saved activation could not be read safely.'**
  String get licenseSavedUnreadable;

  /// No description provided for @licenseFormatUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This license format is not supported.'**
  String get licenseFormatUnsupported;

  /// No description provided for @licensePayloadUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This license payload format is not supported.'**
  String get licensePayloadUnsupported;

  /// No description provided for @licenseKeyMismatch.
  ///
  /// In en, this message translates to:
  /// **'The license key identifiers do not match.'**
  String get licenseKeyMismatch;

  /// No description provided for @licenseUntrustedKey.
  ///
  /// In en, this message translates to:
  /// **'The license was signed by an untrusted key.'**
  String get licenseUntrustedKey;

  /// No description provided for @licenseSignatureSize.
  ///
  /// In en, this message translates to:
  /// **'The license signature has an invalid size.'**
  String get licenseSignatureSize;

  /// No description provided for @licenseSignatureInvalid.
  ///
  /// In en, this message translates to:
  /// **'The license signature is invalid.'**
  String get licenseSignatureInvalid;

  /// No description provided for @licenseDifferentProduct.
  ///
  /// In en, this message translates to:
  /// **'This license is for a different product.'**
  String get licenseDifferentProduct;

  /// No description provided for @licenseDifferentInstallation.
  ///
  /// In en, this message translates to:
  /// **'This license belongs to a different installation.'**
  String get licenseDifferentInstallation;

  /// No description provided for @licenseTypeUnsupported.
  ///
  /// In en, this message translates to:
  /// **'The license type is not supported.'**
  String get licenseTypeUnsupported;

  /// No description provided for @instructionsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Instructions: {value}'**
  String instructionsPrefix(String value);

  /// No description provided for @assignmentHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'Assignment history ({count})'**
  String assignmentHistoryCount(int count);

  /// No description provided for @skillsPrefix.
  ///
  /// In en, this message translates to:
  /// **'Skills: {value}'**
  String skillsPrefix(String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

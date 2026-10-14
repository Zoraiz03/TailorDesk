// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'ٹیلر ڈیسک';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get language => 'زبان';

  @override
  String get languageSelectorLabel => 'ایپ کی زبان: انگریزی یا اردو';

  @override
  String get provisionalUrduNotice =>
      'اردو اصطلاحات عارضی ہیں اور اردو بولنے والے درزی سے جائزہ درکار ہے۔';

  @override
  String get home => 'ہوم';

  @override
  String get orders => 'آرڈرز';

  @override
  String get customers => 'گاہک';

  @override
  String get more => 'مزید';

  @override
  String get karigars => 'کاریگر';

  @override
  String get reports => 'رپورٹس';

  @override
  String get settings => 'ترتیبات';

  @override
  String get backupRestore => 'بیک اپ اور بحالی';

  @override
  String get aboutTailorDesk => 'ٹیلر ڈیسک کے بارے میں';

  @override
  String get cancel => 'منسوخ';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get saving => 'محفوظ ہو رہا ہے…';

  @override
  String get continueLabel => 'آگے';

  @override
  String get back => 'واپس';

  @override
  String get done => 'مکمل';

  @override
  String get close => 'بند کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم';

  @override
  String get add => 'شامل کریں';

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get required => 'ضروری';

  @override
  String get optional => 'اختیاری';

  @override
  String get notes => 'نوٹس';

  @override
  String get address => 'پتہ';

  @override
  String get phone => 'فون';

  @override
  String get name => 'نام';

  @override
  String get status => 'حالت';

  @override
  String get date => 'تاریخ';

  @override
  String get amount => 'رقم';

  @override
  String get active => 'فعال';

  @override
  String get inactive => 'غیر فعال';

  @override
  String get yes => 'ہاں';

  @override
  String get no => 'نہیں';

  @override
  String get notAvailable => 'دستیاب نہیں';

  @override
  String get loading => 'لوڈ ہو رہا ہے…';

  @override
  String get readOnly => 'صرف مطالعہ';

  @override
  String get readOnlyMessage =>
      'کاروباری ریکارڈ تبدیل کرنے کے لیے درست لائسنس ضروری ہے۔';

  @override
  String customerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count گاہک',
      one: '1 گاہک',
      zero: 'کوئی گاہک نہیں',
    );
    return '$_temp0';
  }

  @override
  String orderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آرڈرز',
      one: '1 آرڈر',
      zero: 'کوئی آرڈر نہیں',
    );
    return '$_temp0';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count آئٹمز',
      one: '1 آئٹم',
      zero: 'کوئی آئٹم نہیں',
    );
    return '$_temp0';
  }

  @override
  String releaseNumber(int number) {
    return 'ریلیز $number';
  }

  @override
  String stepOf(int step, int total) {
    return 'مرحلہ $step از $total';
  }

  @override
  String get activateTitle => 'ٹیلر ڈیسک فعال کریں';

  @override
  String get activatedTitle => 'ٹیلر ڈیسک فعال ہے';

  @override
  String get activationRequiredBody =>
      'دکان کے ریکارڈ بنانے یا بدلنے کے لیے خریدا ہوا لائسنس ضروری ہے۔ فعالیت مکمل طور پر آف لائن ہے۔';

  @override
  String get renewLicenseBody =>
      'دیکھ بھال یا ریلیز استحقاق بڑھانے کے لیے تجدید شدہ لائسنس درآمد کریں۔';

  @override
  String get installationCode => 'انسٹالیشن کوڈ';

  @override
  String get copyRequest => 'درخواست نقل کریں';

  @override
  String get shareRequest => 'درخواست شیئر کریں';

  @override
  String get downloadRequest => 'فعالیت کی درخواست ڈاؤن لوڈ کریں';

  @override
  String get importLicense => 'لائسنس فائل درآمد کریں';

  @override
  String get validating => 'جانچ ہو رہی ہے…';

  @override
  String get activationCopied => 'فعالیت کی درخواست کا JSON نقل ہو گیا۔';

  @override
  String get copyBlocked =>
      'براؤزر نے نقل روک دی۔ ڈاؤن لوڈ کا اختیار استعمال کریں۔';

  @override
  String get shareUnsupported =>
      'یہاں فائل شیئر نہیں ہو سکتی۔ ڈاؤن لوڈ کا اختیار استعمال کریں۔';

  @override
  String get downloadCancelled => 'ڈاؤن لوڈ منسوخ ہو گیا۔';

  @override
  String get downloadComplete =>
      'جاری کنندہ کے لیے درست JSON فائل ڈاؤن لوڈ ہو گئی۔';

  @override
  String get downloadFailed =>
      'اس پلیٹ فارم پر فعالیت کی درخواست ڈاؤن لوڈ نہیں ہو سکی۔';

  @override
  String get licenseActivated => 'لائسنس فعال ہو گیا۔';

  @override
  String get licenseUnavailable => 'لائسنس دستیاب نہیں';

  @override
  String get activated => 'فعال';

  @override
  String get activationRequired => 'فعالیت درکار ہے';

  @override
  String licenseId(String id) {
    return 'لائسنس آئی ڈی: $id';
  }

  @override
  String maintenanceThrough(String date) {
    return 'دیکھ بھال کی تاریخ: $date';
  }

  @override
  String entitledRelease(int maximum, int current) {
    return 'ریلیز $maximum تک استحقاق · موجودہ $current';
  }

  @override
  String get importRenewedLicense => 'تجدید شدہ لائسنس درآمد کریں';

  @override
  String get openActivation => 'فعالیت کھولیں';

  @override
  String releaseMaintenanceNote(int release) {
    return 'ریلیز $release · دیکھ بھال ختم ہونے سے پہلے سے مستحق ریلیز بند نہیں ہوتی۔';
  }

  @override
  String get setupTitle => 'ٹیلر ڈیسک سیٹ اپ کریں';

  @override
  String get yourShop => 'آپ کی دکان';

  @override
  String get measurements => 'ناپ';

  @override
  String get garments => 'ملبوسات';

  @override
  String get garmentShalwarQameez => 'شلوار قمیض';

  @override
  String get garmentCoat => 'کوٹ';

  @override
  String get garmentTrouser => 'پتلون';

  @override
  String get garmentShirt => 'شرٹ';

  @override
  String get garmentWaistcoat => 'واسکٹ';

  @override
  String get garmentJacket => 'جیکٹ';

  @override
  String get garmentKurta => 'کرتا';

  @override
  String get garmentSherwani => 'شیروانی';

  @override
  String get measurementKameezLength => 'قمیض لمبائی';

  @override
  String get measurementLength => 'لمبائی';

  @override
  String get measurementShoulder => 'تیرا';

  @override
  String get measurementSleeve => 'آستین';

  @override
  String get measurementCollar => 'کالر';

  @override
  String get measurementChest => 'چھاتی';

  @override
  String get measurementWaist => 'کمر';

  @override
  String get measurementHip => 'کولہا';

  @override
  String get measurementShalwarLength => 'شلوار لمبائی';

  @override
  String get measurementAnkleOpening => 'پائنچہ';

  @override
  String get measurementOutseam => 'بیرونی لمبائی';

  @override
  String get measurementInseam => 'اندرونی لمبائی';

  @override
  String get measurementThigh => 'ران';

  @override
  String get measurementKnee => 'گھٹنا';

  @override
  String get measurementCuff => 'کف';

  @override
  String get defaultPrices => 'طے شدہ قیمتیں';

  @override
  String get shopNameRequired => 'دکان کا نام *';

  @override
  String get enterShopName => 'دکان کا نام درج کریں';

  @override
  String get phoneOptional => 'فون (اختیاری)';

  @override
  String get addressOptional => 'پتہ (اختیاری)';

  @override
  String get measurementUnitPrompt =>
      'نئے ناپ کے لیے پہلے سے منتخب اکائی چنیں۔';

  @override
  String get inches => 'انچ';

  @override
  String get centimetres => 'سینٹی میٹر';

  @override
  String get enableGarmentsPrompt =>
      'وہ ملبوسات منتخب کریں جو آپ کی دکان تیار کرتی ہے۔ بعد میں بدلے جا سکتے ہیں۔';

  @override
  String get pricePerPiece => 'فی عدد قیمت';

  @override
  String get finishSetup => 'سیٹ اپ مکمل کریں';

  @override
  String get couldNotLoadSetup => 'سیٹ اپ لوڈ نہیں ہو سکا۔';

  @override
  String get shopDetails => 'دکان کی تفصیل';

  @override
  String get shopDetailsHelp => 'یہ تفصیل رسیدوں اور کام کی پرچیوں پر آتی ہے۔';

  @override
  String get couldNotLoadSettings => 'ترتیبات لوڈ نہیں ہو سکیں';

  @override
  String get settingsUnchanged => 'محفوظ شدہ دکان کی تفصیل تبدیل نہیں ہوئی۔';

  @override
  String get defaultMeasurementUnit => 'طے شدہ ناپ کی اکائی';

  @override
  String get receiptFooter => 'رسید کا آخری متن';

  @override
  String get receiptFooterHint => 'آپ کے کاروبار کا شکریہ۔';

  @override
  String get saveShopDetails => 'دکان کی تفصیل محفوظ کریں';

  @override
  String get shopDetailsSaved => 'دکان کی تفصیل محفوظ ہو گئی۔';

  @override
  String get shopDetailsSaveFailed =>
      'دکان کی تفصیل محفوظ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get garmentsTemplates => 'ملبوسات اور ناپ کے سانچے';

  @override
  String get garmentsTemplatesSubtitle =>
      'دستیابی، ترتیب، قیمتیں، دو لسانی لیبل اور خانے';

  @override
  String get documentLanguage => 'دستاویز کی زبان';

  @override
  String get documentLanguageHelp =>
      'رسید اور کام کی پرچی کی زبان ایپ کی زبان سے الگ ہے۔';

  @override
  String get documentEnglish => 'انگریزی';

  @override
  String get documentUrdu => 'اردو';

  @override
  String get documentBilingual => 'دو لسانی';

  @override
  String get presentationPreferences => 'زبان اور دستاویزات';

  @override
  String get preferenceSaved => 'ترجیح محفوظ ہو گئی۔';

  @override
  String get customer => 'گاہک';

  @override
  String get addCustomer => 'گاہک شامل کریں';

  @override
  String get editCustomer => 'گاہک میں ترمیم';

  @override
  String get customerName => 'گاہک کا نام *';

  @override
  String get phoneNumber => 'فون نمبر *';

  @override
  String get enterName => 'نام درج کریں';

  @override
  String get enterPhone => 'فون نمبر درج کریں';

  @override
  String get invalidPhone => 'درست فون نمبر درج کریں';

  @override
  String get customerSaved => 'گاہک محفوظ ہو گیا۔';

  @override
  String get customerSaveFailed => 'گاہک محفوظ نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get searchCustomers => 'گاہک تلاش کریں';

  @override
  String get noCustomers => 'ابھی کوئی گاہک نہیں';

  @override
  String get noCustomersHelp =>
      'ناپ اور آرڈر شروع کرنے کے لیے پہلا گاہک شامل کریں۔';

  @override
  String get noMatchingCustomers => 'کوئی مماثل گاہک نہیں';

  @override
  String get customerDetails => 'گاہک کی تفصیل';

  @override
  String get customerHistory => 'گاہک کی تاریخ';

  @override
  String get deleteCustomer => 'گاہک حذف کریں';

  @override
  String get deleteCustomerConfirm =>
      'یہ گاہک حذف کریں؟ یہ عمل واپس نہیں ہو سکتا۔';

  @override
  String get customerDeleteBlocked =>
      'اس گاہک کے ناپ یا آرڈرز موجود ہیں، اس لیے حذف نہیں ہو سکتا۔';

  @override
  String get addMeasurement => 'ناپ شامل کریں';

  @override
  String get editMeasurement => 'نئی ترمیم شامل کریں';

  @override
  String get measurementProfile => 'ناپ کا پروفائل';

  @override
  String get profileName => 'پروفائل کا نام *';

  @override
  String get garment => 'ملبوس';

  @override
  String get unit => 'اکائی';

  @override
  String get measurementBasis => 'ناپ کی بنیاد';

  @override
  String get bodyMeasurements => 'جسمانی ناپ';

  @override
  String get finishedGarmentMeasurements => 'تیار ملبوس کے ناپ';

  @override
  String get fit => 'فٹنگ';

  @override
  String get regularFit => 'عام';

  @override
  String get slimFit => 'سلم';

  @override
  String get looseFit => 'کشادہ';

  @override
  String get styleInstructions => 'سلائی کی ہدایات';

  @override
  String get saveMeasurements => 'ناپ محفوظ کریں';

  @override
  String get measurementSaved => 'ناپ محفوظ ہو گئے۔';

  @override
  String get measurementSaveFailed =>
      'ناپ محفوظ نہیں ہو سکے۔ دوبارہ کوشش کریں۔';

  @override
  String measurementRequired(String label) {
    return '$label درج کریں';
  }

  @override
  String measurementPositive(String label) {
    return '$label صفر سے زیادہ ہونا چاہیے';
  }

  @override
  String revisionNumber(int number) {
    return 'ترمیم $number';
  }

  @override
  String get revisionHistory => 'ترمیمات کی تاریخ';

  @override
  String get noMeasurements => 'ابھی کوئی ناپ نہیں';

  @override
  String get noMeasurementsHelp =>
      'اس گاہک کے لیے ملبوس کا ناپ پروفائل بنائیں۔';

  @override
  String get builtInLabel => 'بلٹ اِن';

  @override
  String get customLabel => 'حسب ضرورت';

  @override
  String get englishLabel => 'انگریزی لیبل';

  @override
  String get urduLabel => 'اردو لیبل (اختیاری)';

  @override
  String get availableLabelFallback =>
      'ایک زبان خالی ہو تو ٹیلر ڈیسک دستیاب لیبل استعمال کرتا ہے۔';

  @override
  String get customGarment => 'حسب ضرورت ملبوس';

  @override
  String get reviseTemplate => 'سانچے میں ترمیم';

  @override
  String get garmentName => 'ملبوس کا نام *';

  @override
  String get garmentNameUrdu => 'ملبوس کا اردو نام (اختیاری)';

  @override
  String get measurementConvention => 'ناپ کا طریقہ';

  @override
  String get noFormulaNotice =>
      'کوئی الاؤنس، تبدیلی یا سلائی کا فارمولا خودکار طور پر لاگو نہیں ہوتا۔ طے شدہ خانے درزی کے جائزے کے منتظر ہیں۔';

  @override
  String get fields => 'خانے';

  @override
  String get stableFieldId => 'مستقل فیلڈ آئی ڈی';

  @override
  String get stableFieldIdHint => 'مثلاً sleeve_length';

  @override
  String get displayLabel => 'انگریزی نمایشی لیبل';

  @override
  String get displayLabelUrdu => 'اردو نمایشی لیبل (اختیاری)';

  @override
  String get addField => 'خانہ شامل کریں';

  @override
  String get createTemplate => 'سانچہ بنائیں';

  @override
  String get saveNewVersion => 'نیا ورژن محفوظ کریں';

  @override
  String get disabledGarmentsHelp =>
      'غیر فعال ملبوسات نئے ناپ میں نظر نہیں آتے۔ پرانے ناپ اور آرڈرز نہیں بدلتے۔';

  @override
  String templateVersion(int version, String basis) {
    return 'سانچہ v$version · $basis';
  }

  @override
  String get setDefaultPrice => 'طے شدہ قیمت مقرر کریں';

  @override
  String get moveUp => 'اوپر کریں';

  @override
  String get moveDown => 'نیچے کریں';

  @override
  String get archiveField => 'نئے ورژن میں خانہ محفوظِ تاریخ کریں';

  @override
  String get newOrder => 'نیا آرڈر';

  @override
  String get order => 'آرڈر';

  @override
  String get orderDetails => 'آرڈر کی تفصیل';

  @override
  String get selectCustomer => 'گاہک منتخب کریں *';

  @override
  String get addGarment => 'ملبوس شامل کریں';

  @override
  String get quantity => 'تعداد';

  @override
  String get stitchingPrice => 'سلائی کی قیمت';

  @override
  String get clothCharge => 'کپڑے کا خرچ';

  @override
  String get additionalCharge => 'اضافی خرچ';

  @override
  String get additionalChargeDescription => 'اضافی خرچ کی تفصیل';

  @override
  String get bookingDate => 'بکنگ کی تاریخ';

  @override
  String get deliveryDate => 'ڈیلیوری کی تاریخ';

  @override
  String get advancePayment => 'پیشگی ادائیگی';

  @override
  String get paymentMethod => 'ادائیگی کا طریقہ';

  @override
  String get cash => 'نقد';

  @override
  String get manualBankTransfer => 'دستی بینک ٹرانسفر';

  @override
  String get saveOrder => 'آرڈر محفوظ کریں';

  @override
  String get orderSaved => 'آرڈر محفوظ ہو گیا۔';

  @override
  String get orderSaveFailed => 'آرڈر محفوظ نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get noOrders => 'ابھی کوئی آرڈر نہیں';

  @override
  String get noOrdersHelp => 'گاہک اور ناپ شامل کرنے کے بعد آرڈر بنائیں۔';

  @override
  String get orderTotal => 'آرڈر کا کل';

  @override
  String get netPaid => 'خالص ادا شدہ';

  @override
  String get balance => 'بقایا';

  @override
  String get paymentStatus => 'ادائیگی کی حالت';

  @override
  String get unpaid => 'غیر ادا شدہ';

  @override
  String get partiallyPaid => 'جزوی ادا شدہ';

  @override
  String get paid => 'ادا شدہ';

  @override
  String get recordPayment => 'ادائیگی درج کریں';

  @override
  String get recordRefund => 'واپسی درج کریں';

  @override
  String get refund => 'واپسی';

  @override
  String get payment => 'ادائیگی';

  @override
  String get paymentRecorded => 'ادائیگی درج ہو گئی۔';

  @override
  String get refundRecorded => 'واپسی درج ہو گئی۔';

  @override
  String get booked => 'بک شدہ';

  @override
  String get assigned => 'سونپا گیا';

  @override
  String get inProgress => 'کام جاری';

  @override
  String get ready => 'تیار';

  @override
  String get partiallyDelivered => 'جزوی ڈیلیوری';

  @override
  String get delivered => 'ڈیلیور شدہ';

  @override
  String get cancelled => 'منسوخ';

  @override
  String get markDelivered => 'ڈیلیور شدہ نشان لگائیں';

  @override
  String get cancelOrder => 'آرڈر منسوخ کریں';

  @override
  String get orderNotes => 'آرڈر نوٹس';

  @override
  String get paymentsRefunds => 'ادائیگیاں اور واپسی';

  @override
  String get addKarigar => 'کاریگر شامل کریں';

  @override
  String get editKarigar => 'کاریگر میں ترمیم';

  @override
  String get workerName => 'کاریگر کا نام *';

  @override
  String get skills => 'مہارتیں';

  @override
  String get assignKarigar => 'کاریگر مقرر کریں';

  @override
  String get reassignKarigar => 'کاریگر تبدیل کریں';

  @override
  String get workInstructions => 'کام کی ہدایات';

  @override
  String get internalDeadline => 'اندرونی آخری تاریخ';

  @override
  String get startWork => 'کام شروع کریں';

  @override
  String get completeWork => 'کام مکمل کریں';

  @override
  String get returnForAlteration => 'ترمیم کے لیے واپس کریں';

  @override
  String get assignmentHistory => 'کام سونپنے کی تاریخ';

  @override
  String get noKarigars => 'ابھی کوئی کاریگر نہیں';

  @override
  String get noKarigarsHelp => 'ملبوس کا کام سونپنے سے پہلے کاریگر شامل کریں۔';

  @override
  String get dueOverdue => 'واجب الادا اور تاخیر';

  @override
  String get outstandingBalances => 'بقایا جات';

  @override
  String get collections => 'وصولیاں';

  @override
  String get workload => 'کام کا بوجھ';

  @override
  String get today => 'آج';

  @override
  String get last7Days => '7 دن';

  @override
  String get last30Days => '30 دن';

  @override
  String get allTime => 'تمام مدت';

  @override
  String get customRange => 'حسب ضرورت';

  @override
  String get grossPayments => 'کل ادائیگیاں';

  @override
  String get refunds => 'واپسیاں';

  @override
  String get netCollections => 'خالص وصولی';

  @override
  String get unassigned => 'غیر مقرر';

  @override
  String get overdue => 'تاخیر شدہ';

  @override
  String get dueToday => 'آج واجب';

  @override
  String get upcoming => 'آنے والے';

  @override
  String get createBackup => 'بیک اپ بنا کر برآمد کریں';

  @override
  String get restoreBackup => 'بیک اپ بحال کریں';

  @override
  String get backupDescription =>
      'بیک اپ میں کاروباری ریکارڈ اور ترتیبات شامل ہیں، لیکن فعالیت نہیں۔ بیک اپ فائل خفیہ کردہ نہیں ہے۔';

  @override
  String get backupCreated =>
      'بیک اپ بن گیا۔ اسے آلے سے باہر رکھنے کے لیے شیئر یا محفوظ کرنے کا عمل مکمل کریں۔';

  @override
  String get backupCancelled => 'بیک اپ برآمد منسوخ ہو گئی۔';

  @override
  String get backupFailed => 'بیک اپ نہیں بن سکا۔';

  @override
  String get restoreWarning =>
      'بحالی موجودہ کاروباری ریکارڈ بدل دیتی ہے۔ یہ اس انسٹالیشن کا لائسنس نہیں بدلتی۔';

  @override
  String get chooseBackup => 'بیک اپ فائل منتخب کریں';

  @override
  String get confirmRestore => 'بحالی کی تصدیق';

  @override
  String get restoreComplete => 'بیک اپ کامیابی سے بحال ہو گیا۔';

  @override
  String get restoreFailed => 'یہ بیک اپ بحال نہیں ہو سکا۔';

  @override
  String get customerReceipt => 'گاہک کی رسید';

  @override
  String get karigarSlip => 'کاریگر کی کام پرچی';

  @override
  String get combinedDocument => 'مشترکہ دستاویز';

  @override
  String get print => 'پرنٹ';

  @override
  String get exportPdf => 'PDF برآمد کریں';

  @override
  String get pdfExportComplete => 'PDF برآمد ہو گئی۔';

  @override
  String get pdfExportCancelled => 'PDF برآمد منسوخ ہو گئی۔';

  @override
  String get printingCancelled => 'پرنٹنگ منسوخ ہو گئی۔';

  @override
  String get printJobSent => 'پرنٹ کام سسٹم کو بھیج دیا گیا۔';

  @override
  String get orderReceiptHeading => 'آرڈر رسید';

  @override
  String get workSlipHeading => 'کاریگر کام پرچی';

  @override
  String get generated => 'تیار کردہ';

  @override
  String get manualTransferNotice =>
      'دستی بینک ٹرانسفر درج ہوتے ہیں لیکن الیکٹرانک تصدیق نہیں ہوتی۔';

  @override
  String get financialPrivacyNotice =>
      'کاریگر کی پرچی میں قیمتیں، ادائیگیاں، کل یا بقایا شامل نہیں ہوتے۔';

  @override
  String versionLabel(String version) {
    return 'ایپ ورژن: $version';
  }

  @override
  String licenseReleaseSequence(int sequence) {
    return 'لائسنس ریلیز سلسلہ: $sequence';
  }

  @override
  String get offlineTagline => 'آپ کی درزی کی دکان، آف لائن منظم۔';

  @override
  String get aboutData =>
      'آپ کی دکان کی تفصیل گاہک کی رسید پر آتی ہے۔ کاروباری ریکارڈ اسی آلے میں محفوظ ہیں۔ باقاعدگی سے فون سے باہر بیک اپ بنائیں۔ خودکار کلاؤڈ ہم وقت سازی نہیں ہے۔';

  @override
  String get openSourceNotices => 'اوپن سورس نوٹس';

  @override
  String get confirmDiscardTitle => 'تبدیلیاں چھوڑ دیں؟';

  @override
  String get confirmDiscardBody => 'غیر محفوظ تبدیلیاں ضائع ہو جائیں گی۔';

  @override
  String get keepEditing => 'ترمیم جاری رکھیں';

  @override
  String get discard => 'چھوڑ دیں';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get couldNotLoad => 'یہ معلومات لوڈ نہیں ہو سکیں۔';

  @override
  String get savedDataUnchanged => 'آپ کا محفوظ ڈیٹا تبدیل نہیں ہوا۔';

  @override
  String get notFound => 'نہیں ملا';

  @override
  String get overview => 'خلاصہ';

  @override
  String get activeOrders => 'فعال آرڈر';

  @override
  String get outstanding => 'بقایا';

  @override
  String get workshop => 'ورکشاپ';

  @override
  String get unassignedItems => 'غیر مقرر اشیاء';

  @override
  String get karigarOverdue => 'کاریگر کا کام تاخیر سے';

  @override
  String get upcomingDeliveries => 'آنے والی ترسیلات';

  @override
  String get noUpcomingDeliveries => 'کوئی آنے والی ترسیل نہیں';

  @override
  String get activeOrdersAppearHere => 'فعال آرڈر یہاں دکھائی دیں گے۔';

  @override
  String get quickActions => 'فوری کام';

  @override
  String get searchOrders => 'آرڈر، گاہک یا فون تلاش کریں';

  @override
  String get all => 'سب';

  @override
  String get sortCustomers => 'گاہک ترتیب دیں';

  @override
  String get recentlyUpdated => 'حال ہی میں تبدیل شدہ';

  @override
  String get nameAZ => 'نام ا تا ے';

  @override
  String get clearSearch => 'تلاش صاف کریں';

  @override
  String get differentSearch => 'کوئی دوسرا نام یا فون آزمائیں۔';

  @override
  String get appPreferencesSubtitle => 'ایپ ترجیحات اور ترتیب';

  @override
  String get backupSubtitle => 'اپنا ڈیٹا برآمد یا درآمد کریں';

  @override
  String get reportsSubtitle => 'کاروباری تجزیہ اور خلاصے';

  @override
  String get karigarsSubtitle => 'درزیوں اور کاریگروں کا انتظام';

  @override
  String get aboutSubtitle => 'ایپ ورژن اور آف لائن معلومات';

  @override
  String get addCustomerFirst => 'پہلے گاہک شامل کریں';

  @override
  String get measurementCustomerHelp =>
      'ناپ پروفائل ہمیشہ کسی گاہک سے منسلک ہوتا ہے۔';

  @override
  String get addCustomerAction => 'گاہک شامل کریں';

  @override
  String changePrompt(String item) {
    return '$item تبدیل کریں؟';
  }

  @override
  String get keepValues => 'قدریں برقرار رکھیں';

  @override
  String get clearAndChange => 'صاف کرکے تبدیل کریں';

  @override
  String get measurementContext => 'ناپ کی نوعیت';

  @override
  String get measurementContextHelp =>
      'منتخب کریں کہ یہ جسم کے ناپ ہیں یا تیار لباس کے۔ ایپ کوئی گنجائش شامل یا تبدیلی نہیں کرتی۔';

  @override
  String get clearMeasurementsWarning =>
      'درج شدہ ناپ صاف ہو جائیں گے۔ قدریں خودکار طور پر تبدیل یا دوبارہ تشریح نہیں کی جاتیں۔';

  @override
  String get profileNameHint => 'مثلاً روزمرہ یا شادی';

  @override
  String get enterProfileName => 'پروفائل کا نام درج کریں';

  @override
  String get styleHint => 'کالر، کف، جیب یا فنشنگ کی ترجیحات';

  @override
  String get enterNumber => 'عدد درج کریں';

  @override
  String get createNewRevision => 'نیا نسخہ بنائیں';

  @override
  String get revisionLoadFailed => 'نسخوں کی تاریخ لوڈ نہیں ہو سکی۔';

  @override
  String get profileNotFound => 'ناپ پروفائل نہیں ملا';

  @override
  String get profileNotFoundHelp => 'یہ ناپ پروفائل اب دستیاب نہیں ہے۔';

  @override
  String stylePrefix(String value) {
    return 'انداز: $value';
  }

  @override
  String notesPrefix(String value) {
    return 'نوٹس: $value';
  }

  @override
  String get customerNotFound => 'گاہک نہیں ملا';

  @override
  String get customerNotFoundHelp => 'ممکن ہے یہ گاہک حذف ہو گیا ہو۔';

  @override
  String get orderHistoryLoadFailed => 'آرڈر کی تاریخ لوڈ نہیں ہو سکی۔';

  @override
  String get noCustomerOrders => 'اس گاہک کا ابھی کوئی آرڈر نہیں۔';

  @override
  String get viewHistory => 'تاریخ دیکھیں';

  @override
  String get editCustomerAction => 'گاہک میں ترمیم';

  @override
  String get deleteBlockedOk => 'ٹھیک ہے';

  @override
  String get orderNotFound => 'آرڈر نہیں ملا';

  @override
  String get orderNotFoundHelp => 'یہ آرڈر دستیاب نہیں ہے۔';

  @override
  String get printExportDocuments => 'دستاویزات پرنٹ یا برآمد کریں';

  @override
  String get editOrderDetails => 'ترسیل کی تاریخ اور نوٹس بدلیں';

  @override
  String progressLabel(String value) {
    return 'پیش رفت: $value';
  }

  @override
  String paymentLabel(String value) {
    return 'ادائیگی: $value';
  }

  @override
  String get addPaymentRefund => 'ادائیگی یا واپسی شامل کریں';

  @override
  String get garmentStatus => 'لباس کی حالت';

  @override
  String get balanceOutstandingTitle => 'بقایا ابھی باقی ہے';

  @override
  String get keepCurrentStatus => 'موجودہ حالت برقرار رکھیں';

  @override
  String get updateFailed => 'تبدیلی محفوظ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get cancelOrderQuestion => 'آرڈر منسوخ کریں؟';

  @override
  String get keepOrder => 'آرڈر برقرار رکھیں';

  @override
  String get noWorkSlips => 'کاریگر کی کوئی کام پرچی دستیاب نہیں';

  @override
  String get assignGarmentFirst => 'پہلے لباس کسی کاریگر کو دیں۔';

  @override
  String combinedPageFor(String name) {
    return 'مشترکہ صفحہ — $name';
  }

  @override
  String get enterPositiveAmount => 'صفر سے زیادہ رقم درج کریں۔';

  @override
  String get paymentExceedsBalance => 'ادائیگی بقایا رقم سے زیادہ ہے۔';

  @override
  String get refundExceedsPaid => 'واپسی خالص ادا شدہ رقم سے زیادہ ہے۔';

  @override
  String get ledgerEntry => 'ادائیگی کا اندراج';

  @override
  String get method => 'طریقہ';

  @override
  String get notesOptional => 'نوٹس (اختیاری)';

  @override
  String get orderNotesOptional => 'آرڈر نوٹس (اختیاری)';

  @override
  String get reviewOrder => 'آرڈر کا جائزہ';

  @override
  String get goBack => 'واپس جائیں';

  @override
  String get addGarmentLine => 'کم از کم ایک لباس شامل کریں۔';

  @override
  String get advanceLimit => 'آرڈر کے کل تک پیشگی رقم درج کریں۔';

  @override
  String get orderAlreadySaved => 'یہ آرڈر پہلے ہی محفوظ ہو چکا ہے۔';

  @override
  String get couldNotLoadCustomers => 'گاہک لوڈ نہیں ہو سکے۔';

  @override
  String get couldNotLoadMeasurements => 'ناپ لوڈ نہیں ہو سکے۔';

  @override
  String get createMeasurementsFirst => 'پہلے ناپ بنائیں';

  @override
  String get removeGarment => 'لباس ہٹائیں';

  @override
  String get advancePkr => 'پیشگی (PKR)';

  @override
  String get advanceMethod => 'پیشگی کا طریقہ';

  @override
  String get describeAdditionalCharge => 'اضافی خرچ کی وضاحت کریں۔';

  @override
  String get addLine => 'آئٹم شامل کریں';

  @override
  String get receiptSubtitle => 'اخراجات، ادائیگیاں اور بقایا';

  @override
  String get activeOnly => 'صرف فعال';

  @override
  String get searchKarigars => 'کاریگر تلاش کریں…';

  @override
  String get garmentSkills => 'لباس کی مہارتیں';

  @override
  String get garmentSkillsHint => 'قمیض، پتلون، واسکٹ';

  @override
  String get deactivateBlocked =>
      'غیر فعال کرنے سے پہلے فعال کام مکمل یا دوبارہ مقرر کریں۔';

  @override
  String get deleteKarigarQuestion => 'کاریگر حذف کریں؟';

  @override
  String get karigarNotFound => 'کاریگر نہیں ملا';

  @override
  String get karigarNotFoundHelp => 'ممکن ہے یہ کاریگر حذف ہو گیا ہو۔';

  @override
  String get assignmentActions => 'کام کے اقدامات';

  @override
  String get previewWorkSlip => 'کام پرچی دیکھیں';

  @override
  String get viewOrder => 'آرڈر دیکھیں';

  @override
  String get noAssignments => 'ابھی کوئی کام مقرر نہیں';

  @override
  String get assignmentsAppearHere => 'مقرر کردہ لباس یہاں دکھائی دیں گے۔';

  @override
  String get noActiveAssignment => 'کوئی فعال کاریگر مقرر نہیں۔';

  @override
  String get alterationReason => 'تبدیلی کی وجہ *';

  @override
  String get reassignmentReason => 'دوبارہ مقرر کرنے کی وجہ *';

  @override
  String get enterReassignmentReason => 'دوبارہ مقرر کرنے کی وجہ درج کریں۔';

  @override
  String get inactiveKarigar => 'یہ کاریگر غیر فعال ہے۔';

  @override
  String get replaceLocalDataQuestion => 'تمام مقامی ڈیٹا بدل دیں؟';

  @override
  String get replaceLocalData => 'مقامی ڈیٹا بدلیں';

  @override
  String get reportsAnalytics => 'رپورٹس اور تجزیہ';

  @override
  String get allCaughtUp => 'سب کام مکمل ہے!';

  @override
  String get noDueOrders => 'اس وقت کوئی تاخیر شدہ یا واجب آرڈر نہیں۔';

  @override
  String get totalOutstanding => 'کل بقایا';

  @override
  String get customersWithDue => 'بقایا والے گاہک';

  @override
  String customerBalancesCount(int count) {
    return 'گاہک کے بقایاجات ($count)';
  }

  @override
  String get noOutstandingBalances => 'کوئی بقایا نہیں';

  @override
  String get accountsPaidUp => 'تمام گاہکوں کے کھاتے مکمل ادا ہیں!';

  @override
  String get grossCollections => 'کل وصولی';

  @override
  String get totalRefunds => 'کل واپسی';

  @override
  String get transactions => 'لین دین';

  @override
  String get cashCollected => 'نقد وصولی';

  @override
  String get bankTransferManual => 'بینک ٹرانسفر (دستی)';

  @override
  String ledgerEntriesCount(int count) {
    return 'کھاتے کے اندراجات ($count)';
  }

  @override
  String get noTransactions => 'اس مدت میں کوئی لین دین نہیں';

  @override
  String get activeWorkers => 'فعال کاریگر';

  @override
  String get activeWorkItems => 'فعال کام';

  @override
  String get overdueDeadlines => 'تاخیر شدہ آخری تاریخیں';

  @override
  String get assign => 'مقرر کریں';

  @override
  String workerWorkloadsCount(int count) {
    return 'کاریگر کا کام ($count)';
  }

  @override
  String get noKarigarsRegistered => 'کوئی کاریگر درج نہیں';

  @override
  String get pdfDocument => 'PDF دستاویز';

  @override
  String get printFailed => 'یہ دستاویز پرنٹ نہیں ہو سکی۔';

  @override
  String get pdfExportFailed => 'یہ PDF برآمد نہیں ہو سکی۔';

  @override
  String get documentGenerationFailed => 'یہ دستاویز تیار نہیں ہو سکی۔';

  @override
  String get documentPreviewFailed => 'یہ PDF دیکھی نہیں جا سکی۔';

  @override
  String get webPdfHelp =>
      'PDF مقامی طور پر بن گئی ہے۔ براؤزر میں دیکھنے کے لیے برآمد کریں۔';

  @override
  String pageOf(int page, int pages) {
    return 'صفحہ $page از $pages';
  }

  @override
  String get promised => 'وعدہ شدہ';

  @override
  String get frozenMeasurements => 'محفوظ ناپ';

  @override
  String get workNotes => 'کام کے نوٹس';

  @override
  String get measurementNotes => 'ناپ کے نوٹس';

  @override
  String get profile => 'پروفائل';

  @override
  String get paymentStatusDocument => 'ادائیگی کی حالت';

  @override
  String get cancelledExcluded => 'منسوخ — اخراجات میں شامل نہیں';

  @override
  String get total => 'کل';

  @override
  String get page => 'صفحہ';

  @override
  String get nameHint => 'مثلاً احمد خان';

  @override
  String get phoneHint => 'مثلاً 0300 1234567';

  @override
  String get notesHint => 'ترجیحات یا دوسری مفید تفصیلات';

  @override
  String get activationShared => 'فعالیت کی درخواست شیئر ہو گئی۔';

  @override
  String get activationShareSubject => 'TailorDesk فعالیت کی درخواست';

  @override
  String get activationShareBody =>
      'یہ درخواست TailorDesk لائسنس جاری کرنے والے کو بھیجیں۔';

  @override
  String get licenseImportFailed =>
      'لائسنس درآمد نہیں ہو سکا۔ موجودہ فعالیت تبدیل نہیں ہوئی۔';

  @override
  String get licenseNotImported =>
      'اس انسٹالیشن کے لیے کوئی لائسنس درآمد نہیں ہوا۔';

  @override
  String get licenseSavedUnreadable =>
      'محفوظ فعالیت محفوظ طریقے سے پڑھی نہیں جا سکی۔';

  @override
  String get licenseFormatUnsupported => 'یہ لائسنس فارمیٹ معاون نہیں ہے۔';

  @override
  String get licensePayloadUnsupported =>
      'یہ لائسنس مواد فارمیٹ معاون نہیں ہے۔';

  @override
  String get licenseKeyMismatch =>
      'لائسنس کلید کے شناختی نام مطابقت نہیں رکھتے۔';

  @override
  String get licenseUntrustedKey =>
      'لائسنس پر غیر معتبر کلید سے دستخط ہوئے ہیں۔';

  @override
  String get licenseSignatureSize => 'لائسنس دستخط کا حجم غلط ہے۔';

  @override
  String get licenseSignatureInvalid => 'لائسنس دستخط درست نہیں ہے۔';

  @override
  String get licenseDifferentProduct =>
      'یہ لائسنس کسی دوسری مصنوعات کے لیے ہے۔';

  @override
  String get licenseDifferentInstallation =>
      'یہ لائسنس کسی دوسری انسٹالیشن کا ہے۔';

  @override
  String get licenseTypeUnsupported => 'یہ لائسنس قسم معاون نہیں ہے۔';

  @override
  String instructionsPrefix(String value) {
    return 'ہدایات: $value';
  }

  @override
  String assignmentHistoryCount(int count) {
    return 'کام کی تاریخ ($count)';
  }

  @override
  String skillsPrefix(String value) {
    return 'مہارتیں: $value';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `تطبيق الوجبات`
  String get appTitle {
    return Intl.message(
      'تطبيق الوجبات',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get signIn {
    return Intl.message(
      'تسجيل الدخول',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب`
  String get signUp {
    return Intl.message(
      'إنشاء حساب',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب؟`
  String get dontHaveAccount {
    return Intl.message(
      'ليس لديك حساب؟',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا بك في تطبيق الوجبات`
  String get welcome {
    return Intl.message(
      'مرحبًا بك في تطبيق الوجبات',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `كل المفضلات لديك`
  String get onboardingTitle1 {
    return Intl.message(
      'كل المفضلات لديك',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي`
  String get onboardingDesc1 {
    return Intl.message(
      'احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي',
      name: 'onboardingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `اطلب من الشيف المختار`
  String get onboardingTitle2 {
    return Intl.message(
      'اطلب من الشيف المختار',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي`
  String get onboardingDesc2 {
    return Intl.message(
      'احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي',
      name: 'onboardingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `عروض توصيل مجانية`
  String get onboardingTitle3 {
    return Intl.message(
      'عروض توصيل مجانية',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي`
  String get onboardingDesc3 {
    return Intl.message(
      'احصل على جميع الأطعمة المفضلة لديك في مكان واحد، فقط قم بالطلب ونحن نقوم بالباقي',
      name: 'onboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `التالي`
  String get next {
    return Intl.message(
      'التالي',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `تخطي`
  String get skip {
    return Intl.message(
      'تخطي',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ الآن`
  String get getStarted {
    return Intl.message(
      'ابدأ الآن',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف`
  String get phoneNumber {
    return Intl.message(
      'رقم الهاتف',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `متابعة`
  String get continueButton {
    return Intl.message(
      'متابعة',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `رمز التحقق`
  String get verificationCode {
    return Intl.message(
      'رمز التحقق',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال رمز التحقق إلى هاتفك المحمول`
  String get verificationCodeSent {
    return Intl.message(
      'تم إرسال رمز التحقق إلى هاتفك المحمول',
      name: 'verificationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `لم تستلم الرمز؟`
  String get didntReceiveCode {
    return Intl.message(
      'لم تستلم الرمز؟',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `الشيء الحقيقي.`
  String get theRealThing {
    return Intl.message(
      'الشيء الحقيقي.',
      name: 'theRealThing',
      desc: '',
      args: [],
    );
  }

  /// `الشروط والأحكام`
  String get termsAndConditions {
    return Intl.message(
      'الشروط والأحكام',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `العربية`
  String get arabic {
    return Intl.message(
      'العربية',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال رقم هاتفك`
  String get phoneNumberRequired {
    return Intl.message(
      'الرجاء إدخال رقم هاتفك',
      name: 'phoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن يكون رقم الهاتف 11 رقمًا على الأقل`
  String get phoneNumberMustBeAtLeast11Digits {
    return Intl.message(
      'يجب أن يكون رقم الهاتف 11 رقمًا على الأقل',
      name: 'phoneNumberMustBeAtLeast11Digits',
      desc: '',
      args: [],
    );
  }

  /// `نسيت كلمة المرور؟`
  String get forgotPassword {
    return Intl.message(
      'نسيت كلمة المرور؟',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تكون كلمة المرور 6 أحرف على الأقل`
  String get passwordMustBeAtLeast6 {
    return Intl.message(
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      name: 'passwordMustBeAtLeast6',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال رمز تحقق مكون من 6 أرقام إلى بريدك الإلكتروني`
  String get otpSentToEmail {
    return Intl.message(
      'تم إرسال رمز تحقق مكون من 6 أرقام إلى بريدك الإلكتروني',
      name: 'otpSentToEmail',
      desc: '',
      args: [],
    );
  }

  /// `رمز التحقق غير صحيح. الرجاء المحاولة مرة أخرى.`
  String get invalidOtp {
    return Intl.message(
      'رمز التحقق غير صحيح. الرجاء المحاولة مرة أخرى.',
      name: 'invalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `إعادة إرسال الرمز في`
  String get resendCodeIn {
    return Intl.message(
      'إعادة إرسال الرمز في',
      name: 'resendCodeIn',
      desc: '',
      args: [],
    );
  }

  /// `ثانية`
  String get seconds {
    return Intl.message(
      'ثانية',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `تحقق`
  String get verify {
    return Intl.message(
      'تحقق',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `إعادة إرسال الرمز`
  String get resendCode {
    return Intl.message(
      'إعادة إرسال الرمز',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `تم إعادة إرسال رمز التحقق`
  String get otpResent {
    return Intl.message(
      'تم إعادة إرسال رمز التحقق',
      name: 'otpResent',
      desc: '',
      args: [],
    );
  }

  /// `الوصول إلى الموقع`
  String get accessLocation {
    return Intl.message(
      'الوصول إلى الموقع',
      name: 'accessLocation',
      desc: '',
      args: [],
    );
  }

  /// `سيصل التطبيق إلى موقعك\nفقط أثناء استخدام التطبيق`
  String get locationAccessDescription {
    return Intl.message(
      'سيصل التطبيق إلى موقعك\nفقط أثناء استخدام التطبيق',
      name: 'locationAccessDescription',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا بك في تطبيق الوجبات`
  String get welcomeToMealsApp {
    return Intl.message(
      'مرحبًا بك في تطبيق الوجبات',
      name: 'welcomeToMealsApp',
      desc: '',
      args: [],
    );
  }

  /// `دعنا نسجلك`
  String get letsSignYouUp {
    return Intl.message(
      'دعنا نسجلك',
      name: 'letsSignYouUp',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسمك الكامل`
  String get enterYourFullName {
    return Intl.message(
      'أدخل اسمك الكامل',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullName {
    return Intl.message(
      'الاسم الكامل',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get emailAddress {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get password {
    return Intl.message(
      'كلمة المرور',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get submit {
    return Intl.message(
      'إرسال',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `الملف الشخصي`
  String get profile {
    return Intl.message(
      'الملف الشخصي',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `الموقع`
  String get location {
    return Intl.message(
      'الموقع',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `اختر مدينتك`
  String get selectYourCity {
    return Intl.message(
      'اختر مدينتك',
      name: 'selectYourCity',
      desc: '',
      args: [],
    );
  }

  /// `المنطقة، الشارع، رقم المبنى`
  String get detailedAddress {
    return Intl.message(
      'المنطقة، الشارع، رقم المبنى',
      name: 'detailedAddress',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال عنوانك التفصيلي`
  String get pleaseEnterAddress {
    return Intl.message(
      'الرجاء إدخال عنوانك التفصيلي',
      name: 'pleaseEnterAddress',
      desc: '',
      args: [],
    );
  }

  /// `المنطقة`
  String get area {
    return Intl.message(
      'المنطقة',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `أدخل منطقتك أو حيك`
  String get areaHint {
    return Intl.message(
      'أدخل منطقتك أو حيك',
      name: 'areaHint',
      desc: '',
      args: [],
    );
  }

  /// `الشارع والمبنى`
  String get streetAndBuilding {
    return Intl.message(
      'الشارع والمبنى',
      name: 'streetAndBuilding',
      desc: '',
      args: [],
    );
  }

  /// `اسم الشارع ورقم المبنى`
  String get streetAndBuildingHint {
    return Intl.message(
      'اسم الشارع ورقم المبنى',
      name: 'streetAndBuildingHint',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال منطقتك`
  String get pleaseEnterArea {
    return Intl.message(
      'الرجاء إدخال منطقتك',
      name: 'pleaseEnterArea',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال اسمك`
  String get pleaseEnterYourName {
    return Intl.message(
      'الرجاء إدخال اسمك',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال بريدك الإلكتروني`
  String get pleaseEnterYourEmail {
    return Intl.message(
      'الرجاء إدخال بريدك الإلكتروني',
      name: 'pleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال عنوان بريد إلكتروني صالح`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'الرجاء إدخال عنوان بريد إلكتروني صالح',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال كلمة مرور`
  String get pleaseEnterPassword {
    return Intl.message(
      'الرجاء إدخال كلمة مرور',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تكون كلمة المرور 8 أحرف على الأقل`
  String get passwordMustBeAtLeast8 {
    return Intl.message(
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
      name: 'passwordMustBeAtLeast8',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال النموذج بنجاح!`
  String get formSubmittedSuccessfully {
    return Intl.message(
      'تم إرسال النموذج بنجاح!',
      name: 'formSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `meals@example.com`
  String get emailExample {
    return Intl.message(
      'meals@example.com',
      name: 'emailExample',
      desc: '',
      args: [],
    );
  }

  /// `القاهرة`
  String get cairo {
    return Intl.message(
      'القاهرة',
      name: 'cairo',
      desc: '',
      args: [],
    );
  }

  /// `الجيزة`
  String get giza {
    return Intl.message(
      'الجيزة',
      name: 'giza',
      desc: '',
      args: [],
    );
  }

  /// `الإسكندرية`
  String get alexandria {
    return Intl.message(
      'الإسكندرية',
      name: 'alexandria',
      desc: '',
      args: [],
    );
  }

  /// `القليوبية`
  String get qalyubia {
    return Intl.message(
      'القليوبية',
      name: 'qalyubia',
      desc: '',
      args: [],
    );
  }

  /// `المنوفية`
  String get monufia {
    return Intl.message(
      'المنوفية',
      name: 'monufia',
      desc: '',
      args: [],
    );
  }

  /// `الغربية`
  String get gharbia {
    return Intl.message(
      'الغربية',
      name: 'gharbia',
      desc: '',
      args: [],
    );
  }

  /// `كفر الشيخ`
  String get kafrElSheikh {
    return Intl.message(
      'كفر الشيخ',
      name: 'kafrElSheikh',
      desc: '',
      args: [],
    );
  }

  /// `الدقهلية`
  String get dakahlia {
    return Intl.message(
      'الدقهلية',
      name: 'dakahlia',
      desc: '',
      args: [],
    );
  }

  /// `الشرقية`
  String get sharqia {
    return Intl.message(
      'الشرقية',
      name: 'sharqia',
      desc: '',
      args: [],
    );
  }

  /// `دمياط`
  String get damietta {
    return Intl.message(
      'دمياط',
      name: 'damietta',
      desc: '',
      args: [],
    );
  }

  /// `بورسعيد`
  String get portSaid {
    return Intl.message(
      'بورسعيد',
      name: 'portSaid',
      desc: '',
      args: [],
    );
  }

  /// `الإسماعيلية`
  String get ismailia {
    return Intl.message(
      'الإسماعيلية',
      name: 'ismailia',
      desc: '',
      args: [],
    );
  }

  /// `السويس`
  String get suez {
    return Intl.message(
      'السويس',
      name: 'suez',
      desc: '',
      args: [],
    );
  }

  /// `شمال سيناء`
  String get northSinai {
    return Intl.message(
      'شمال سيناء',
      name: 'northSinai',
      desc: '',
      args: [],
    );
  }

  /// `جنوب سيناء`
  String get southSinai {
    return Intl.message(
      'جنوب سيناء',
      name: 'southSinai',
      desc: '',
      args: [],
    );
  }

  /// `البحر الأحمر`
  String get redSea {
    return Intl.message(
      'البحر الأحمر',
      name: 'redSea',
      desc: '',
      args: [],
    );
  }

  /// `الفيوم`
  String get faiyum {
    return Intl.message(
      'الفيوم',
      name: 'faiyum',
      desc: '',
      args: [],
    );
  }

  /// `بني سويف`
  String get beniSuef {
    return Intl.message(
      'بني سويف',
      name: 'beniSuef',
      desc: '',
      args: [],
    );
  }

  /// `المنيا`
  String get minya {
    return Intl.message(
      'المنيا',
      name: 'minya',
      desc: '',
      args: [],
    );
  }

  /// `أسيوط`
  String get asyut {
    return Intl.message(
      'أسيوط',
      name: 'asyut',
      desc: '',
      args: [],
    );
  }

  /// `سوهاج`
  String get sohag {
    return Intl.message(
      'سوهاج',
      name: 'sohag',
      desc: '',
      args: [],
    );
  }

  /// `قنا`
  String get qena {
    return Intl.message(
      'قنا',
      name: 'qena',
      desc: '',
      args: [],
    );
  }

  /// `الأقصر`
  String get luxor {
    return Intl.message(
      'الأقصر',
      name: 'luxor',
      desc: '',
      args: [],
    );
  }

  /// `أسوان`
  String get aswan {
    return Intl.message(
      'أسوان',
      name: 'aswan',
      desc: '',
      args: [],
    );
  }

  /// `مطروح`
  String get matrouh {
    return Intl.message(
      'مطروح',
      name: 'matrouh',
      desc: '',
      args: [],
    );
  }

  /// `الوادي الجديد`
  String get newValley {
    return Intl.message(
      'الوادي الجديد',
      name: 'newValley',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا، {name}`
  String hello(Object name) {
    return Intl.message(
      'مرحبًا، $name',
      name: 'hello',
      desc: '',
      args: [name],
    );
  }

  /// `العروض`
  String get offers {
    return Intl.message(
      'العروض',
      name: 'offers',
      desc: '',
      args: [],
    );
  }

  /// `عروض ساخنة`
  String get hotDeals {
    return Intl.message(
      'عروض ساخنة',
      name: 'hotDeals',
      desc: '',
      args: [],
    );
  }

  /// `التوصيل إلى`
  String get deliveryTo {
    return Intl.message(
      'التوصيل إلى',
      name: 'deliveryTo',
      desc: '',
      args: [],
    );
  }

  /// `هذه العناصر متاحة لفترة محدودة فقط. استفد من هذه العروض الرائعة قبل فوات الأوان. جربها الآن!`
  String get hotDealsDescription {
    return Intl.message(
      'هذه العناصر متاحة لفترة محدودة فقط. استفد من هذه العروض الرائعة قبل فوات الأوان. جربها الآن!',
      name: 'hotDealsDescription',
      desc: '',
      args: [],
    );
  }

  /// `موصى به`
  String get recommended {
    return Intl.message(
      'موصى به',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `الأطباق التي يحبها عملاؤنا أكثر. جرب أكثر خياراتنا شعبية والتي ستلبي رغباتك بالتأكيد!`
  String get recommendedDescription {
    return Intl.message(
      'الأطباق التي يحبها عملاؤنا أكثر. جرب أكثر خياراتنا شعبية والتي ستلبي رغباتك بالتأكيد!',
      name: 'recommendedDescription',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message(
      'الرئيسية',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `القائمة`
  String get menu {
    return Intl.message(
      'القائمة',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `طلباتي`
  String get myOrders {
    return Intl.message(
      'طلباتي',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `العناوين المحفوظة`
  String get savedAddresses {
    return Intl.message(
      'العناوين المحفوظة',
      name: 'savedAddresses',
      desc: '',
      args: [],
    );
  }

  /// `السلة`
  String get cart {
    return Intl.message(
      'السلة',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `نقاط الولاء`
  String get loyaltyPoints {
    return Intl.message(
      'نقاط الولاء',
      name: 'loyaltyPoints',
      desc: '',
      args: [],
    );
  }

  /// `التعليقات`
  String get feedback {
    return Intl.message(
      'التعليقات',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `اتصل بالدعم`
  String get callSupport {
    return Intl.message(
      'اتصل بالدعم',
      name: 'callSupport',
      desc: '',
      args: [],
    );
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message(
      'الإعدادات',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل الحساب`
  String get accountDetails {
    return Intl.message(
      'تفاصيل الحساب',
      name: 'accountDetails',
      desc: '',
      args: [],
    );
  }

  /// `معلومات الحساب`
  String get accountInfo {
    return Intl.message(
      'معلومات الحساب',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `تغيير كلمة المرور`
  String get changePassword {
    return Intl.message(
      'تغيير كلمة المرور',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `التفضيلات`
  String get preferences {
    return Intl.message(
      'التفضيلات',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `اللغة`
  String get language {
    return Intl.message(
      'اللغة',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `سياسة الخصوصية`
  String get privacyPolicy {
    return Intl.message(
      'سياسة الخصوصية',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `إصدار التطبيق`
  String get appVersion {
    return Intl.message(
      'إصدار التطبيق',
      name: 'appVersion',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get logout {
    return Intl.message(
      'تسجيل الخروج',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `العناوين المحفوظة`
  String get savedAddressesScreen {
    return Intl.message(
      'العناوين المحفوظة',
      name: 'savedAddressesScreen',
      desc: '',
      args: [],
    );
  }

  /// `تعيين كعنوان رئيسي`
  String get markAsPrimary {
    return Intl.message(
      'تعيين كعنوان رئيسي',
      name: 'markAsPrimary',
      desc: '',
      args: [],
    );
  }

  /// `تعديل`
  String get edit {
    return Intl.message(
      'تعديل',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `إضافة عنوان جديد`
  String get addNewAddress {
    return Intl.message(
      'إضافة عنوان جديد',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `سلتي`
  String get myCart {
    return Intl.message(
      'سلتي',
      name: 'myCart',
      desc: '',
      args: [],
    );
  }

  /// `العناصر`
  String get items {
    return Intl.message(
      'العناصر',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `طلبات خاصة`
  String get specialRequests {
    return Intl.message(
      'طلبات خاصة',
      name: 'specialRequests',
      desc: '',
      args: [],
    );
  }

  /// `اختياري`
  String get optional {
    return Intl.message(
      'اختياري',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `لا يُسمح بإضافات إضافية كطلب خاص.`
  String get noExtrasAllowed {
    return Intl.message(
      'لا يُسمح بإضافات إضافية كطلب خاص.',
      name: 'noExtrasAllowed',
      desc: '',
      args: [],
    );
  }

  /// `اكتب طلباتك الخاصة هنا...`
  String get typeYourSpecialRequestsHere {
    return Intl.message(
      'اكتب طلباتك الخاصة هنا...',
      name: 'typeYourSpecialRequestsHere',
      desc: '',
      args: [],
    );
  }

  /// `المجموع الفرعي`
  String get subTotal {
    return Intl.message(
      'المجموع الفرعي',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `ضريبة القيمة المضافة`
  String get vat {
    return Intl.message(
      'ضريبة القيمة المضافة',
      name: 'vat',
      desc: '',
      args: [],
    );
  }

  /// `المجموع`
  String get total {
    return Intl.message(
      'المجموع',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `إضافة المزيد من العناصر`
  String get addMoreItems {
    return Intl.message(
      'إضافة المزيد من العناصر',
      name: 'addMoreItems',
      desc: '',
      args: [],
    );
  }

  /// `الدفع`
  String get checkout {
    return Intl.message(
      'الدفع',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `التفاصيل الشخصية`
  String get personalDetails {
    return Intl.message(
      'التفاصيل الشخصية',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `التقييم`
  String get rating {
    return Intl.message(
      'التقييم',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `ما مدى رضاك عن جودة الطعام؟`
  String get howSatisfiedAreYouWithFoodQuality {
    return Intl.message(
      'ما مدى رضاك عن جودة الطعام؟',
      name: 'howSatisfiedAreYouWithFoodQuality',
      desc: '',
      args: [],
    );
  }

  /// `ما مدى رضاك عن سرعة الخدمة؟`
  String get howSatisfiedAreYouWithServiceSpeed {
    return Intl.message(
      'ما مدى رضاك عن سرعة الخدمة؟',
      name: 'howSatisfiedAreYouWithServiceSpeed',
      desc: '',
      args: [],
    );
  }

  /// `ما مدى سهولة تقديم طلبك من موقعنا؟`
  String get howEasyToMakeOrder {
    return Intl.message(
      'ما مدى سهولة تقديم طلبك من موقعنا؟',
      name: 'howEasyToMakeOrder',
      desc: '',
      args: [],
    );
  }

  /// `التقييم العام`
  String get overall {
    return Intl.message(
      'التقييم العام',
      name: 'overall',
      desc: '',
      args: [],
    );
  }

  /// `ما مدى رضاك عن الخدمة بشكل عام؟`
  String get howSatisfiedWithOverallService {
    return Intl.message(
      'ما مدى رضاك عن الخدمة بشكل عام؟',
      name: 'howSatisfiedWithOverallService',
      desc: '',
      args: [],
    );
  }

  /// `اترك لنا تعليقًا`
  String get leaveUsFeedback {
    return Intl.message(
      'اترك لنا تعليقًا',
      name: 'leaveUsFeedback',
      desc: '',
      args: [],
    );
  }

  /// `اكتب تعليقك...`
  String get typeYourFeedback {
    return Intl.message(
      'اكتب تعليقك...',
      name: 'typeYourFeedback',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال التعليق بنجاح!`
  String get feedbackSubmittedSuccessfully {
    return Intl.message(
      'تم إرسال التعليق بنجاح!',
      name: 'feedbackSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `الحجم`
  String get size {
    return Intl.message(
      'الحجم',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `إضافات`
  String get extras {
    return Intl.message(
      'إضافات',
      name: 'extras',
      desc: '',
      args: [],
    );
  }

  /// `المشروبات`
  String get beverage {
    return Intl.message(
      'المشروبات',
      name: 'beverage',
      desc: '',
      args: [],
    );
  }

  /// `أضف إلى السلة`
  String get addToCart {
    return Intl.message(
      'أضف إلى السلة',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `بطاطس بالدجاج`
  String get chickenFries {
    return Intl.message(
      'بطاطس بالدجاج',
      name: 'chickenFries',
      desc: '',
      args: [],
    );
  }

  /// `بطاطس دجاج لذيذة مصنوعة من دجاج عالي الجودة، تقدم مع صلصتنا الخاصة.`
  String get foodDescription {
    return Intl.message(
      'بطاطس دجاج لذيذة مصنوعة من دجاج عالي الجودة، تقدم مع صلصتنا الخاصة.',
      name: 'foodDescription',
      desc: '',
      args: [],
    );
  }

  /// `تمت الإضافة إلى السلة بنجاح!`
  String get addedToCart {
    return Intl.message(
      'تمت الإضافة إلى السلة بنجاح!',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `فشلت إضافة العنصر إلى السلة`
  String get failedToAddToCart {
    return Intl.message(
      'فشلت إضافة العنصر إلى السلة',
      name: 'failedToAddToCart',
      desc: '',
      args: [],
    );
  }

  /// `عادي`
  String get regular {
    return Intl.message(
      'عادي',
      name: 'regular',
      desc: '',
      args: [],
    );
  }

  /// `متوسط`
  String get medium {
    return Intl.message(
      'متوسط',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `كبير`
  String get large {
    return Intl.message(
      'كبير',
      name: 'large',
      desc: '',
      args: [],
    );
  }

  /// `تحديث`
  String get update {
    return Intl.message(
      'تحديث',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `حذف حسابي`
  String get deleteMyAccount {
    return Intl.message(
      'حذف حسابي',
      name: 'deleteMyAccount',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد حذف الحساب`
  String get confirmDeleteAccount {
    return Intl.message(
      'تأكيد حذف الحساب',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.`
  String get deleteAccountWarning {
    return Intl.message(
      'هل أنت متأكد من رغبتك في حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
      name: 'deleteAccountWarning',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message(
      'إلغاء',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get delete {
    return Intl.message(
      'حذف',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور الحالية`
  String get currentPassword {
    return Intl.message(
      'كلمة المرور الحالية',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور الجديدة`
  String get newPassword {
    return Intl.message(
      'كلمة المرور الجديدة',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `تم تحديث كلمة المرور بنجاح!`
  String get passwordUpdatedSuccessfully {
    return Intl.message(
      'تم تحديث كلمة المرور بنجاح!',
      name: 'passwordUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `إعادة تعيين كلمة المرور`
  String get resetPassword {
    return Intl.message(
      'إعادة تعيين كلمة المرور',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `إعادة تعيين كلمة المرور لـ`
  String get resetPasswordFor {
    return Intl.message(
      'إعادة تعيين كلمة المرور لـ',
      name: 'resetPasswordFor',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد كلمة المرور`
  String get confirmPassword {
    return Intl.message(
      'تأكيد كلمة المرور',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء تأكيد كلمة المرور`
  String get pleaseConfirmPassword {
    return Intl.message(
      'الرجاء تأكيد كلمة المرور',
      name: 'pleaseConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `كلمات المرور غير متطابقة`
  String get passwordsDoNotMatch {
    return Intl.message(
      'كلمات المرور غير متطابقة',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `أدخل كلمة المرور الجديدة`
  String get enterNewPassword {
    return Intl.message(
      'أدخل كلمة المرور الجديدة',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد كلمة المرور الجديدة`
  String get confirmNewPassword {
    return Intl.message(
      'تأكيد كلمة المرور الجديدة',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `تم إعادة تعيين كلمة المرور بنجاح!`
  String get passwordResetSuccess {
    return Intl.message(
      'تم إعادة تعيين كلمة المرور بنجاح!',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء كلمة مرور`
  String get createPassword {
    return Intl.message(
      'إنشاء كلمة مرور',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء كلمة مرور لحسابك`
  String get createPasswordForEmail {
    return Intl.message(
      'إنشاء كلمة مرور لحسابك',
      name: 'createPasswordForEmail',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب`
  String get createAccount {
    return Intl.message(
      'إنشاء حساب',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال بريد إعادة تعيين كلمة المرور بنجاح!`
  String get passwordResetEmailSent {
    return Intl.message(
      'تم إرسال بريد إعادة تعيين كلمة المرور بنجاح!',
      name: 'passwordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `تعليمات إعادة تعيين كلمة المرور`
  String get passwordResetInstructions {
    return Intl.message(
      'تعليمات إعادة تعيين كلمة المرور',
      name: 'passwordResetInstructions',
      desc: '',
      args: [],
    );
  }

  /// `يرجى التحقق من بريدك الإلكتروني للحصول على رمز إعادة التعيين وإدخاله أدناه مع كلمة المرور الجديدة.`
  String get enterResetTokenInstructions {
    return Intl.message(
      'يرجى التحقق من بريدك الإلكتروني للحصول على رمز إعادة التعيين وإدخاله أدناه مع كلمة المرور الجديدة.',
      name: 'enterResetTokenInstructions',
      desc: '',
      args: [],
    );
  }

  /// `إعادة إرسال بريد إعادة التعيين`
  String get resendResetEmail {
    return Intl.message(
      'إعادة إرسال بريد إعادة التعيين',
      name: 'resendResetEmail',
      desc: '',
      args: [],
    );
  }

  /// `أدخل بريدك الإلكتروني`
  String get enterYourEmail {
    return Intl.message(
      'أدخل بريدك الإلكتروني',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `رمز إعادة التعيين`
  String get resetToken {
    return Intl.message(
      'رمز إعادة التعيين',
      name: 'resetToken',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال رمز إعادة التعيين`
  String get resetTokenRequired {
    return Intl.message(
      'الرجاء إدخال رمز إعادة التعيين',
      name: 'resetTokenRequired',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رمز إعادة التعيين من بريدك الإلكتروني`
  String get enterResetToken {
    return Intl.message(
      'أدخل رمز إعادة التعيين من بريدك الإلكتروني',
      name: 'enterResetToken',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get email {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `هل لديك حساب بالفعل؟`
  String get alreadyHaveAccount {
    return Intl.message(
      'هل لديك حساب بالفعل؟',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.`
  String get noInternetConnection {
    return Intl.message(
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `حاول مرة أخرى`
  String get tryAgain {
    return Intl.message(
      'حاول مرة أخرى',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `يرجى تسجيل الدخول للوصول إلى هذا المحتوى`
  String get pleaseSignInToAccessContent {
    return Intl.message(
      'يرجى تسجيل الدخول للوصول إلى هذا المحتوى',
      name: 'pleaseSignInToAccessContent',
      desc: '',
      args: [],
    );
  }

  /// `سلة التسوق فارغة`
  String get yourCartIsEmpty {
    return Intl.message(
      'سلة التسوق فارغة',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `أضف عناصر إلى سلتك للمتابعة`
  String get addItemsToYourCart {
    return Intl.message(
      'أضف عناصر إلى سلتك للمتابعة',
      name: 'addItemsToYourCart',
      desc: '',
      args: [],
    );
  }

  /// `تصفح القائمة`
  String get browseMenu {
    return Intl.message(
      'تصفح القائمة',
      name: 'browseMenu',
      desc: '',
      args: [],
    );
  }

  /// `عرض السلة`
  String get viewCart {
    return Intl.message(
      'عرض السلة',
      name: 'viewCart',
      desc: '',
      args: [],
    );
  }

  /// `عنصر`
  String get item {
    return Intl.message(
      'عنصر',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `توصيل`
  String get delivery {
    return Intl.message(
      'توصيل',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `استلام`
  String get pickup {
    return Intl.message(
      'استلام',
      name: 'pickup',
      desc: '',
      args: [],
    );
  }

  /// `نوع التوصيل`
  String get deliveryType {
    return Intl.message(
      'نوع التوصيل',
      name: 'deliveryType',
      desc: '',
      args: [],
    );
  }

  /// `وظيفة الدفع غير متاحة حاليًا`
  String get checkoutNotImplemented {
    return Intl.message(
      'وظيفة الدفع غير متاحة حاليًا',
      name: 'checkoutNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `فشل تحميل السلة`
  String get failedToLoadCart {
    return Intl.message(
      'فشل تحميل السلة',
      name: 'failedToLoadCart',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

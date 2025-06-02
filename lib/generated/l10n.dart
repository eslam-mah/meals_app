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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `تطبيق الوجبات`
  String get appTitle {
    return Intl.message('تطبيق الوجبات', name: 'appTitle', desc: '', args: []);
  }

  /// `مرحباً بك في تطبيق الوجبات`
  String get welcome {
    return Intl.message(
      'مرحباً بك في تطبيق الوجبات',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `كل مفضلاتك`
  String get onboardingTitle1 {
    return Intl.message(
      'كل مفضلاتك',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي`
  String get onboardingDesc1 {
    return Intl.message(
      'احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي',
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

  /// `احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي`
  String get onboardingDesc2 {
    return Intl.message(
      'احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي',
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

  /// `احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي`
  String get onboardingDesc3 {
    return Intl.message(
      'احصل على جميع الأطعمة التي تحبها في مكان واحد، فقط قم بتقديم الطلب ونحن نقوم بالباقي',
      name: 'onboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `التالي`
  String get next {
    return Intl.message('التالي', name: 'next', desc: '', args: []);
  }

  /// `تخطي`
  String get skip {
    return Intl.message('تخطي', name: 'skip', desc: '', args: []);
  }

  /// `ابدأ الآن`
  String get getStarted {
    return Intl.message('ابدأ الآن', name: 'getStarted', desc: '', args: []);
  }

  /// `رقم الهاتف`
  String get phoneNumber {
    return Intl.message('رقم الهاتف', name: 'phoneNumber', desc: '', args: []);
  }

  /// `متابعة`
  String get continueButton {
    return Intl.message('متابعة', name: 'continueButton', desc: '', args: []);
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

  /// `لم تتلق رمز التحقق؟`
  String get didntReceiveCode {
    return Intl.message(
      'لم تتلق رمز التحقق؟',
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

  /// `الشروط والاتفاقيات`
  String get termsAndConditions {
    return Intl.message(
      'الشروط والاتفاقيات',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `العربية`
  String get arabic {
    return Intl.message('العربية', name: 'arabic', desc: '', args: []);
  }

  /// `الرجاء إدخال رقم الهاتف`
  String get phoneNumberRequired {
    return Intl.message(
      'الرجاء إدخال رقم الهاتف',
      name: 'phoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `السماح بالوصول للموقع`
  String get accessLocation {
    return Intl.message(
      'السماح بالوصول للموقع',
      name: 'accessLocation',
      desc: '',
      args: [],
    );
  }

  /// `دي فود سيصل إلى موقعك\nفقط أثناء استخدام التطبيق`
  String get locationAccessDescription {
    return Intl.message(
      'دي فود سيصل إلى موقعك\nفقط أثناء استخدام التطبيق',
      name: 'locationAccessDescription',
      desc: '',
      args: [],
    );
  }

  /// `مرحبا بك في تطبيق الوجبات`
  String get welcomeToMealsApp {
    return Intl.message(
      'مرحبا بك في تطبيق الوجبات',
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
    return Intl.message('الاسم الكامل', name: 'fullName', desc: '', args: []);
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
    return Intl.message('كلمة المرور', name: 'password', desc: '', args: []);
  }

  /// `إرسال`
  String get submit {
    return Intl.message('إرسال', name: 'submit', desc: '', args: []);
  }

  /// `الملف الشخصي`
  String get profile {
    return Intl.message('الملف الشخصي', name: 'profile', desc: '', args: []);
  }

  /// `الموقع`
  String get location {
    return Intl.message('الموقع', name: 'location', desc: '', args: []);
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
    return Intl.message('المنطقة', name: 'area', desc: '', args: []);
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

  /// `الرجاء إدخال المنطقة`
  String get pleaseEnterArea {
    return Intl.message(
      'الرجاء إدخال المنطقة',
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

  /// `الرجاء إدخال بريد إلكتروني صحيح`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'الرجاء إدخال بريد إلكتروني صحيح',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال كلمة المرور`
  String get pleaseEnterPassword {
    return Intl.message(
      'الرجاء إدخال كلمة المرور',
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

  /// `تم تقديم النموذج بنجاح!`
  String get formSubmittedSuccessfully {
    return Intl.message(
      'تم تقديم النموذج بنجاح!',
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
    return Intl.message('القاهرة', name: 'cairo', desc: '', args: []);
  }

  /// `الجيزة`
  String get giza {
    return Intl.message('الجيزة', name: 'giza', desc: '', args: []);
  }

  /// `الإسكندرية`
  String get alexandria {
    return Intl.message('الإسكندرية', name: 'alexandria', desc: '', args: []);
  }

  /// `القليوبية`
  String get qalyubia {
    return Intl.message('القليوبية', name: 'qalyubia', desc: '', args: []);
  }

  /// `المنوفية`
  String get monufia {
    return Intl.message('المنوفية', name: 'monufia', desc: '', args: []);
  }

  /// `الغربية`
  String get gharbia {
    return Intl.message('الغربية', name: 'gharbia', desc: '', args: []);
  }

  /// `كفر الشيخ`
  String get kafrElSheikh {
    return Intl.message('كفر الشيخ', name: 'kafrElSheikh', desc: '', args: []);
  }

  /// `الدقهلية`
  String get dakahlia {
    return Intl.message('الدقهلية', name: 'dakahlia', desc: '', args: []);
  }

  /// `الشرقية`
  String get sharqia {
    return Intl.message('الشرقية', name: 'sharqia', desc: '', args: []);
  }

  /// `دمياط`
  String get damietta {
    return Intl.message('دمياط', name: 'damietta', desc: '', args: []);
  }

  /// `بورسعيد`
  String get portSaid {
    return Intl.message('بورسعيد', name: 'portSaid', desc: '', args: []);
  }

  /// `الإسماعيلية`
  String get ismailia {
    return Intl.message('الإسماعيلية', name: 'ismailia', desc: '', args: []);
  }

  /// `السويس`
  String get suez {
    return Intl.message('السويس', name: 'suez', desc: '', args: []);
  }

  /// `شمال سيناء`
  String get northSinai {
    return Intl.message('شمال سيناء', name: 'northSinai', desc: '', args: []);
  }

  /// `جنوب سيناء`
  String get southSinai {
    return Intl.message('جنوب سيناء', name: 'southSinai', desc: '', args: []);
  }

  /// `البحر الأحمر`
  String get redSea {
    return Intl.message('البحر الأحمر', name: 'redSea', desc: '', args: []);
  }

  /// `الفيوم`
  String get faiyum {
    return Intl.message('الفيوم', name: 'faiyum', desc: '', args: []);
  }

  /// `بني سويف`
  String get beniSuef {
    return Intl.message('بني سويف', name: 'beniSuef', desc: '', args: []);
  }

  /// `المنيا`
  String get minya {
    return Intl.message('المنيا', name: 'minya', desc: '', args: []);
  }

  /// `أسيوط`
  String get asyut {
    return Intl.message('أسيوط', name: 'asyut', desc: '', args: []);
  }

  /// `سوهاج`
  String get sohag {
    return Intl.message('سوهاج', name: 'sohag', desc: '', args: []);
  }

  /// `قنا`
  String get qena {
    return Intl.message('قنا', name: 'qena', desc: '', args: []);
  }

  /// `الأقصر`
  String get luxor {
    return Intl.message('الأقصر', name: 'luxor', desc: '', args: []);
  }

  /// `أسوان`
  String get aswan {
    return Intl.message('أسوان', name: 'aswan', desc: '', args: []);
  }

  /// `مطروح`
  String get matrouh {
    return Intl.message('مطروح', name: 'matrouh', desc: '', args: []);
  }

  /// `الوادي الجديد`
  String get newValley {
    return Intl.message('الوادي الجديد', name: 'newValley', desc: '', args: []);
  }

  /// `مرحباً، {name}`
  String hello(Object name) {
    return Intl.message('مرحباً، $name', name: 'hello', desc: '', args: [name]);
  }

  /// `العروض`
  String get offers {
    return Intl.message('العروض', name: 'offers', desc: '', args: []);
  }

  /// `عروض ساخنة`
  String get hotDeals {
    return Intl.message('عروض ساخنة', name: 'hotDeals', desc: '', args: []);
  }

  /// `التوصيل إلى`
  String get deliveryTo {
    return Intl.message('التوصيل إلى', name: 'deliveryTo', desc: '', args: []);
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
    return Intl.message('موصى به', name: 'recommended', desc: '', args: []);
  }

  /// `الأطباق التي يحبها عملاؤنا أكثر. جرب خياراتنا الأكثر شعبية والتي ستلبي رغباتك بالتأكيد!`
  String get recommendedDescription {
    return Intl.message(
      'الأطباق التي يحبها عملاؤنا أكثر. جرب خياراتنا الأكثر شعبية والتي ستلبي رغباتك بالتأكيد!',
      name: 'recommendedDescription',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message('الرئيسية', name: 'home', desc: '', args: []);
  }

  /// `القائمة`
  String get menu {
    return Intl.message('القائمة', name: 'menu', desc: '', args: []);
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

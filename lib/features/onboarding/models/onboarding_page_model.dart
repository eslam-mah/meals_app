class OnboardingPageModel {
  final String titleKey;
  final String descriptionKey;
  final String imagePath;
  final int pageIndex;

  OnboardingPageModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.pageIndex,
    required this.imagePath,
  });

  static List<OnboardingPageModel> getOnboardingPages() {
    return [
      OnboardingPageModel(
        titleKey: 'onboardingTitle1',
        descriptionKey: 'onboardingDesc1',
        pageIndex: 0,
        imagePath: '1',
      ),
      OnboardingPageModel(
        titleKey: 'onboardingTitle2',
        descriptionKey: 'onboardingDesc2',
        pageIndex: 1,
        imagePath: '2',
      ),
      OnboardingPageModel(
        titleKey: 'onboardingTitle3',
        descriptionKey: 'onboardingDesc3',
        pageIndex: 2,
        imagePath: '3',
      ),
    ];
  }
} 
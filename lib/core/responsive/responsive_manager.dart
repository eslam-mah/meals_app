import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ViewSize {
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge,
  xxxLarge,
}

enum DeviceTypeView { mobile, tablet }

enum CustomOrientation { portrait, landscape, squared }

class RM {
  RM._();
  static final RM data = RM._();

  late TargetPlatform platform;
  late Orientation nativeOrientation;
  late CustomOrientation customOrientation; //
  late double width;
  late double height;
  late double physicalWidth;
  late double physicalHeight;
  late ViewSize viewSize;
  late DeviceTypeView deviceType;
  late double devicePixelRatio;
  late bool isLtr;

  void init(BuildContext context) {
    platform = Theme.of(context).platform;
    nativeOrientation = MediaQuery.of(context).orientation;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    physicalWidth = MediaQuery.of(context).size.width * devicePixelRatio;
    physicalHeight = MediaQuery.of(context).size.height * devicePixelRatio;
    customOrientation = calculateCustomOrientation();
    viewSize = calculateViewSize();
    deviceType = calculateDeviceTypeView();
    isLtr = Directionality.of(context) == TextDirection.ltr;
    printScreenInfo();
  }

  // void reCalculateData(BuildContext context) => init(context);

  ViewSize calculateViewSize() {
    if (width <= _BreakPoints.small) {
      return ViewSize.xSmall;
    } else if (width <= _BreakPoints.medium) {
      return ViewSize.small;
    } else if (width <= _BreakPoints.large) {
      return ViewSize.medium;
    } else if (width <= _BreakPoints.xLarge) {
      return ViewSize.large;
    } else if (width <= _BreakPoints.xxLarge) {
      return ViewSize.xLarge;
    } else if (width <= _BreakPoints.xxxLarge) {
      return ViewSize.xxLarge;
    } else if (width > _BreakPoints.xxxLarge) {
      return ViewSize.xxxLarge;
    } else {
      return ViewSize.small;
    }
  }

  CustomOrientation calculateCustomOrientation() {
    final double widthToHeightRatio =
        1 - (width < height ? width / height : height / width);

    final double percentWidthToHeightRatio = widthToHeightRatio * 100;

    print(percentWidthToHeightRatio);

    if (percentWidthToHeightRatio <= 15) {
      return CustomOrientation.squared;
    } else if (width > height) {
      return CustomOrientation.landscape;
    } else {
      return CustomOrientation.portrait;
    }
  }

  DeviceTypeView calculateDeviceTypeView() {
    if (width < _BreakPoints.medium) {
      return DeviceTypeView.mobile;
    } else if (width < _BreakPoints.xLarge) {
      return DeviceTypeView.tablet;
    } else {
      return DeviceTypeView.mobile;
    }
  }

  double mapSize({
    double? smallerMobile,
    required double mobile,
    required double tablet,
    double? largerTablet,
  }) {
    switch (data.viewSize) {
      case ViewSize.xSmall:
        return smallerMobile ?? mobile;
      case ViewSize.small:
        return mobile;
      case ViewSize.medium:
        return tablet;
      case ViewSize.large:
        return largerTablet ?? tablet;
      case ViewSize.xLarge:
        return largerTablet ?? tablet;

      default:
        return mobile;
    }
  }

  double setWidth({
    required double size,
  }) {
    double lowerLimit = size * 0.8;
    double upperLimit = size * 1.4;
    return size.w.clamp(lowerLimit, upperLimit);
  }

  double setRadius({
    required double size,
  }) {
    double lowerLimit = size * 0.8;
    double upperLimit = size * 1.4;
    return size.r.clamp(lowerLimit, upperLimit);
  }

  mapValue<T>({
    T? smallerMobile,
    required T mobile,
    required T tablet,
    T? largerTablet,
  }) {
    switch (data.viewSize) {
      case ViewSize.xSmall:
        return smallerMobile ?? mobile;
      case ViewSize.small:
        return mobile;
      case ViewSize.medium:
        return tablet;
      case ViewSize.large:
        return largerTablet ?? tablet;

      default:
        return mobile;
    }
  }

  String mapFontFamily({
    required String mobile,
    required String tablet,
  }) {
    switch (deviceType) {
      case DeviceTypeView.mobile:
        return mobile;

      case DeviceTypeView.tablet:
        return tablet;

      default:
        return mobile;
    }
  }

  FontWeight mapFontWeight(
      {required FontWeight mobile,
      required FontWeight tablet,
      FontWeight? tv}) {
    switch (deviceType) {
      case DeviceTypeView.mobile:
        return mobile;

      case DeviceTypeView.tablet:
        return tablet;

      default:
        return mobile;
    }
  }

  void printScreenInfo() {
    print("""
  \n
      platform: $platform
      nativeOrientation: $nativeOrientation
      customOrientation: $customOrientation
      width: $width
      height: $height
      physicalWidth: $physicalWidth
      physicalHeight: $physicalHeight
      viewSize: $viewSize
      deviceType: $deviceType
      devicePixelRatio: $devicePixelRatio
  """);
  }
}

class _BreakPoints {
  // note: xSmall is less than the small breakpoint 375
  static double small = 375;
  static double medium = 768;
  static double large = 1050;
  static double xLarge = 1320;
  static double xxLarge = 1745;
  static double xxxLarge = 2300;

  // note: xxxLarge is bigger than the xxxLarge breakpoint 1600
  // tvs and other bigger screens
}

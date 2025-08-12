// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Inter_24pt-Bold.ttf
  String get inter24ptBold => 'assets/fonts/Inter_24pt-Bold.ttf';

  /// File path: assets/fonts/Inter_24pt-Medium.ttf
  String get inter24ptMedium => 'assets/fonts/Inter_24pt-Medium.ttf';

  /// File path: assets/fonts/Inter_24pt-Regular.ttf
  String get inter24ptRegular => 'assets/fonts/Inter_24pt-Regular.ttf';

  /// File path: assets/fonts/Tajawal-Bold.ttf
  String get tajawalBold => 'assets/fonts/Tajawal-Bold.ttf';

  /// File path: assets/fonts/Tajawal-Light.ttf
  String get tajawalLight => 'assets/fonts/Tajawal-Light.ttf';

  /// File path: assets/fonts/Tajawal-Regular.ttf
  String get tajawalRegular => 'assets/fonts/Tajawal-Regular.ttf';

  /// List of all assets
  List<String> get values => [
        inter24ptBold,
        inter24ptMedium,
        inter24ptRegular,
        tajawalBold,
        tajawalLight,
        tajawalRegular
      ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Alert.svg
  String get alert => 'assets/icons/Alert.svg';

  /// File path: assets/icons/google_icon.svg
  String get googleIcon => 'assets/icons/google_icon.svg';

  /// List of all assets
  List<String> get values => [alert, googleIcon];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Brain 1.png
  AssetGenImage get brain1 => const AssetGenImage('assets/images/Brain 1.png');

  /// File path: assets/images/Dentistry.png
  AssetGenImage get dentistry =>
      const AssetGenImage('assets/images/Dentistry.png');

  /// File path: assets/images/Iamge.png
  AssetGenImage get iamge => const AssetGenImage('assets/images/Iamge.png');

  /// File path: assets/images/Kidneys 1.png
  AssetGenImage get kidneys1 =>
      const AssetGenImage('assets/images/Kidneys 1.png');

  /// File path: assets/images/Man Doctor.png
  AssetGenImage get manDoctor =>
      const AssetGenImage('assets/images/Man Doctor.png');

  /// File path: assets/images/Optometry.png
  AssetGenImage get optometry =>
      const AssetGenImage('assets/images/Optometry.png');

  /// File path: assets/images/doctor.png
  AssetGenImage get doctor => const AssetGenImage('assets/images/doctor.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [brain1, dentistry, iamge, kidneys1, manDoctor, optometry, doctor];
}

class $AssetsLangsGen {
  const $AssetsLangsGen();

  /// File path: assets/langs/ar.json
  String get ar => 'assets/langs/ar.json';

  /// File path: assets/langs/en.json
  String get en => 'assets/langs/en.json';

  /// List of all assets
  List<String> get values => [ar, en];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLangsGen langs = $AssetsLangsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

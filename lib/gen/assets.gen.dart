/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AsssetsGen {
  const $AsssetsGen();

  /// Directory path: asssets/fonts
  $AsssetsFontsGen get fonts => const $AsssetsFontsGen();

  /// Directory path: asssets/icons
  $AsssetsIconsGen get icons => const $AsssetsIconsGen();

  /// Directory path: asssets/images
  $AsssetsImagesGen get images => const $AsssetsImagesGen();
}

class $AsssetsFontsGen {
  const $AsssetsFontsGen();

  /// File path: asssets/fonts/Tajawal-Bold.ttf
  String get tajawalBold => 'asssets/fonts/Tajawal-Bold.ttf';

  /// File path: asssets/fonts/Tajawal-Light.ttf
  String get tajawalLight => 'asssets/fonts/Tajawal-Light.ttf';

  /// File path: asssets/fonts/Tajawal-Regular.ttf
  String get tajawalRegular => 'asssets/fonts/Tajawal-Regular.ttf';

  /// List of all assets
  List<String> get values => [tajawalBold, tajawalLight, tajawalRegular];
}

class $AsssetsIconsGen {
  const $AsssetsIconsGen();

  /// File path: asssets/icons/Alert.svg
  String get alert => 'asssets/icons/Alert.svg';

  /// List of all assets
  List<String> get values => [alert];
}

class $AsssetsImagesGen {
  const $AsssetsImagesGen();

  /// File path: asssets/images/Brain 1.png
  AssetGenImage get brain1 => const AssetGenImage('asssets/images/Brain 1.png');

  /// File path: asssets/images/Iamge.png
  AssetGenImage get iamge => const AssetGenImage('asssets/images/Iamge.png');

  /// File path: asssets/images/Kidneys 1.png
  AssetGenImage get kidneys1 =>
      const AssetGenImage('asssets/images/Kidneys 1.png');

  /// File path: asssets/images/Man Doctor.png
  AssetGenImage get manDoctor =>
      const AssetGenImage('asssets/images/Man Doctor.png');

  /// File path: asssets/images/doctor.png
  AssetGenImage get doctor => const AssetGenImage('asssets/images/doctor.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    brain1,
    iamge,
    kidneys1,
    manDoctor,
    doctor,
  ];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AsssetsGen asssets = $AsssetsGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

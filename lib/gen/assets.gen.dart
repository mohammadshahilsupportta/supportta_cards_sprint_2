/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/backgroundlog.png
  AssetGenImage get backgroundlog =>
      const AssetGenImage('assets/png/backgroundlog.png');

  /// File path: assets/png/supportta4.png
  AssetGenImage get supportta4 =>
      const AssetGenImage('assets/png/supportta4.png');

  /// File path: assets/png/supporttalogin.png
  AssetGenImage get supporttalogin =>
      const AssetGenImage('assets/png/supporttalogin.png');

  /// File path: assets/png/supporttalogo.png
  AssetGenImage get supporttalogo =>
      const AssetGenImage('assets/png/supporttalogo.png');

  /// File path: assets/png/supporttaqr.png
  AssetGenImage get supporttaqr =>
      const AssetGenImage('assets/png/supporttaqr.png');

  /// File path: assets/png/supporttaqr1.png
  AssetGenImage get supporttaqr1 =>
      const AssetGenImage('assets/png/supporttaqr1.png');

  /// File path: assets/png/supporttaqr3.png
  AssetGenImage get supporttaqr3 =>
      const AssetGenImage('assets/png/supporttaqr3.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    backgroundlog,
    supportta4,
    supporttalogin,
    supporttalogo,
    supporttaqr,
    supporttaqr1,
    supporttaqr3,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/addround.svg
  String get addround => 'assets/svg/addround.svg';

  /// File path: assets/svg/behance.svg
  String get behance => 'assets/svg/behance.svg';

  /// File path: assets/svg/facebook.svg
  String get facebook => 'assets/svg/facebook.svg';

  /// File path: assets/svg/github.svg
  String get github => 'assets/svg/github.svg';

  /// File path: assets/svg/instagram.svg
  String get instagram => 'assets/svg/instagram.svg';

  /// File path: assets/svg/link.svg
  String get link => 'assets/svg/link.svg';

  /// File path: assets/svg/linkdin.svg
  String get linkdin => 'assets/svg/linkdin.svg';

  /// File path: assets/svg/logo.svg
  String get logo => 'assets/svg/logo.svg';

  /// File path: assets/svg/pinterest.svg
  String get pinterest => 'assets/svg/pinterest.svg';

  /// File path: assets/svg/premium.svg
  String get premium => 'assets/svg/premium.svg';

  /// File path: assets/svg/threads.svg
  String get threads => 'assets/svg/threads.svg';

  /// File path: assets/svg/twitter.svg
  String get twitter => 'assets/svg/twitter.svg';

  /// File path: assets/svg/whatsapp.svg
  String get whatsapp => 'assets/svg/whatsapp.svg';

  /// File path: assets/svg/youtube.svg
  String get youtube => 'assets/svg/youtube.svg';

  /// List of all assets
  List<String> get values => [
    addround,
    behance,
    facebook,
    github,
    instagram,
    link,
    linkdin,
    logo,
    pinterest,
    premium,
    threads,
    twitter,
    whatsapp,
    youtube,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
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

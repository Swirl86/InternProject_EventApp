import 'package:consid_event_app/reusables/reusables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgPictureCache {
  // Always only one SvgPictureCache instance like Singleton
  SvgPictureCache._privateConstructor();
  static final SvgPictureCache _instance =
      SvgPictureCache._privateConstructor();
  static SvgPictureCache get instance => _instance;

  final Map<String, SvgPicture> _svgPictureCache = {};

  SvgPicture getSvgPicture(BuildContext context, String svgKey, String url,
      String lable, double d, double l) {
    if (!_svgPictureCache.containsKey(svgKey)) {
      SvgPicture svgPicture = SvgPicture.network(url,
          width: MediaQuery.of(context).size.width * d,
          semanticsLabel: lable,
          placeholderBuilder: (context) =>
              loadingSpinner(MediaQuery.of(context).size.width, l));
      _svgPictureCache[svgKey] = svgPicture;
    }
    return _svgPictureCache[svgKey]!;
  }
}

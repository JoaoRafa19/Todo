import 'package:google_mobile_ads/google_mobile_ads.dart';

class TargetInfo {
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
}

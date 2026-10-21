import 'package:web_browser_detect/src/abstract_class.dart';
import 'package:web_browser_detect/src/browser_detection.dart';
import 'package:web_browser_detect/src/enum.dart';

class BrowserPlatform extends BrowserPlatformAbstract {
  /// Browser initialization, there is no browser to detect on non-web platforms
  BrowserPlatform() : _detection = null;

  /// Browser initialization from provided userAgent or vendor, works cross-platform
  BrowserPlatform.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) : _detection = BrowserDetection.detectFrom(
         userAgent: userAgent,
         vendor: vendor,
         appVersion: appVersion,
       );

  @override
  BrowserAgent get browserAgent =>
      _detection?.browserAgent ?? BrowserAgent.unknown;
  @override
  String get browser => browserAgent.browserName;
  @override
  String get version =>
      _detection?.version ?? 'Unsupported on non-web platform';

  /// Detection is available only when created from provided values
  final BrowserDetection? _detection;

  /// Returns null for unsupported platforms.
  static BrowserPlatform? detectOrNull() => null;
}

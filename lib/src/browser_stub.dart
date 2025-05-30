import 'package:web_browser_detect/src/abstract_class.dart';
import 'package:web_browser_detect/src/enum.dart';

class BrowserPlatform extends BrowserPlatformAbstract {
  BrowserPlatform();

  BrowserPlatform.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    userAgent = 'unknown';
    vendor = 'unknown';
    appVersion = 'unknown';
  }

  @override
  BrowserAgent get browserAgent => BrowserAgent.unknown;
  @override
  String get browser => browserAgent.browserName;
  @override
  String get version => 'Unsupported on mobile';

  /// Returns null for unsupported platforms.
  static BrowserPlatform? detectOrNull() => null;
}

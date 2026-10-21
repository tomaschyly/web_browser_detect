import 'package:web_browser_detect/src/abstract_class.dart';
import 'package:web_browser_detect/src/browser.dart'
    if (dart.library.html) 'package:web_browser_detect/src/browser.dart'
    if (dart.library.io) 'package:web_browser_detect/src/browser_stub.dart'
    as browser_impl;
import 'package:web_browser_detect/src/enum.dart';

export 'package:web_browser_detect/src/enum.dart';

class Browser extends BrowserPlatformAbstract {
  /// Browser initialization
  Browser() {
    _browserInstance = browser_impl.BrowserPlatform();
  }

  /// Browser initialization from provided userAgent or vendor, works cross-platform
  Browser.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    _browserInstance = browser_impl.BrowserPlatform.detectFrom(
      userAgent: userAgent,
      vendor: vendor,
      appVersion: appVersion,
    );
  }

  /// Browser initialization from already detected platform instance
  Browser._fromPlatform(browser_impl.BrowserPlatform browserInstance)
    : _browserInstance = browserInstance;

  /// Internal instance of the browser detection
  /// for multiplatform support and calls from web or mobile
  /// so code can be called without falling into Exception
  /// regardless of the platform
  browser_impl.BrowserPlatform? _browserInstance;

  @override
  BrowserAgent get browserAgent =>
      _browserInstance?.browserAgent ?? BrowserAgent.unknown;
  @override
  String get browser => browserAgent.browserName;
  @override
  String get version => _browserInstance?.version ?? 'Unsupported on mobile';

  /// Alternative initialization for cross-platform, returns null instead of Exception
  static Browser? detectOrNull() {
    // Platform implementation decides, stub returns null on non-web platforms
    final browserInstance = browser_impl.BrowserPlatform.detectOrNull();

    return browserInstance != null
        ? Browser._fromPlatform(browserInstance)
        : null;
  }
}

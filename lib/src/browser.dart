import 'package:flutter/foundation.dart';
import 'package:web/web.dart';
import 'package:web_browser_detect/src/abstract_class.dart';
import 'package:web_browser_detect/src/browser_detection.dart';
import 'package:web_browser_detect/src/enum.dart';

class BrowserPlatform extends BrowserPlatformAbstract {
  /// Browser initialization
  BrowserPlatform() {
    if (!kIsWeb) {
      throw Exception('Browser is supported only on the web platform');
    }

    final appVersion = window.navigator.appVersion;

    _detection = BrowserDetection.detectFrom(
      userAgent: window.navigator.userAgent,
      vendor: window.navigator.vendor,
      appVersion: appVersion,
    );
  }

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
  BrowserAgent get browserAgent => _detection.browserAgent;

  @override
  String get browser => browserAgent.browserName;

  @override
  String get version => _detection.version;

  late final BrowserDetection _detection;

  /// Alternative initialization for cross-platform, returns null instead of Exception
  static BrowserPlatform? detectOrNull() {
    try {
      return BrowserPlatform();
    } on Exception catch (e) {
      debugPrint('Browser detection failed: $e');
      return null;
    }
  }
}

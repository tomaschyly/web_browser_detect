import 'package:flutter/foundation.dart';
import 'package:web/web.dart';
import 'package:web_browser_detect/src/abstract_class.dart';
import 'package:web_browser_detect/src/enum.dart';

class BrowserPlatform extends BrowserPlatformAbstract {
  /// Browser initialization
  BrowserPlatform() {
    if (!kIsWeb) {
      throw Exception('Browser is supported only on the web platform');
    }

    final appVersion = window.navigator.appVersion;

    _detectBrowser(
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
  }) {
    _detectBrowser(
      userAgent: userAgent,
      vendor: vendor,
      appVersion: appVersion,
    );
  }
  @override
  BrowserAgent get browserAgent =>
      _detected?.browserAgent ?? BrowserAgent.unknown;

  @override
  String get browser => browserAgent.browserName;

  @override
  String get version => _version;

  _BrowserDetection? _detected;
  String _version = 'Unknown version';

  /// Alternative initialization for cross-platform, returns null instead of Exception
  static BrowserPlatform? detectOrNull() {
    try {
      return BrowserPlatform();
    } on Exception catch (e) {
      debugPrint('Browser detection failed: $e');
      return null;
    }
  }

  /// Detect current browser if it is known
  void _detectBrowser({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    final detections = [
      _BrowserDetection(
        browserAgent: BrowserAgent.edgeChromium,
        string: userAgent,
        subString: 'Edg',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.chrome,
        string: userAgent,
        subString: 'Chrome',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.safari,
        string: vendor,
        subString: 'Apple',
        versionSearch: 'Version',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.firefox,
        string: userAgent,
        subString: 'Firefox',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'MSIE',
        versionSearch: 'MSIE',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'Trident',
        versionSearch: 'rv',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.edge,
        string: userAgent,
        subString: 'Edge',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.brave,
        string: userAgent,
        subString: 'Brave',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.opera,
        string: userAgent,
        subString: 'OPR',
      ),
    ];

    for (final detection in detections) {
      if (detection.string.contains(detection.subString)) {
        _detected = detection;

        final versionSearchString =
            detection.versionSearch ?? detection.subString;
        var versionFromString = userAgent;
        var index = versionFromString.indexOf(versionSearchString);
        if (index == -1) {
          versionFromString = appVersion;
          index = versionFromString.indexOf(versionSearchString);
        }

        if (index == -1) {
          _version = 'Unknown version';
        } else {
          _version = versionFromString
              .substring(index + versionSearchString.length + 1);

          if (_version.split(' ').length > 1) {
            _version = _version.split(' ').firstOrNull ?? 'Unknown version';
          }
        }

        break;
      }
    }
  }
}

class _BrowserDetection {
  const _BrowserDetection({
    required this.browserAgent,
    required this.string,
    required this.subString,
    this.versionSearch,
  });
  final BrowserAgent browserAgent;
  final String string;
  final String subString;
  final String? versionSearch;
}

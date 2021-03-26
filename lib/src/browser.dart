import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

enum BrowserAgent {
  UnKnown,
  Chrome,
  Safari,
  Firefox,
  Explorer,
  Edge,
  EdgeChromium,
}

class Browser {
  BrowserAgent get browserAgent => _detected?.browserAgent ?? BrowserAgent.UnKnown;

  String get browser => _browserIdentifiers[browserAgent]!;

  String get version => _version;

  static const Map<BrowserAgent, String> _browserIdentifiers = <BrowserAgent, String>{
    BrowserAgent.UnKnown: 'Unknown browser',
    BrowserAgent.Chrome: 'Chrome',
    BrowserAgent.Safari: 'Safari',
    BrowserAgent.Firefox: 'Firefox',
    BrowserAgent.Explorer: 'Internet Explorer',
    BrowserAgent.Edge: 'Edge',
    BrowserAgent.EdgeChromium: 'Chromium Edge',
  };

  _BrowserDetection? _detected;
  String _version = 'Unknown version';

  /// Browser initialization
  Browser() {
    if (!kIsWeb) {
      throw Exception('Browser is supported only on the web platform');
    }

    _detectBrowser(
      userAgent: window.navigator.userAgent,
      vendor: window.navigator.vendor,
      appVersion: window.navigator.appVersion ?? '', // The ?? are because of bug when building for mobile
    );
  }

  /// Browser initialization from provided userAgent or vendor, works crossplatform
  Browser.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    _detectBrowser(userAgent: userAgent, vendor: vendor, appVersion: appVersion);
  }

  /// Alternative initialization for crossplatform, returns null instead of Exception
  static Browser? detectOrNull() {
    try {
      return Browser();
    } catch (e, t) {
      return null;
    }
  }

  /// Detect current browser if it is known
  _detectBrowser({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    final List<_BrowserDetection> detections = <_BrowserDetection>[
      _BrowserDetection(
        browserAgent: BrowserAgent.EdgeChromium,
        string: userAgent,
        subString: 'Edg',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Chrome,
        string: userAgent,
        subString: 'Chrome',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Safari,
        string: vendor,
        subString: 'Apple',
        versionSearch: 'Version',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Firefox,
        string: userAgent,
        subString: 'Firefox',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Explorer,
        string: userAgent,
        subString: 'MSIE',
        versionSearch: 'MSIE',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Explorer,
        string: userAgent,
        subString: 'Trident',
        versionSearch: 'rv',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Edge,
        string: userAgent,
        subString: 'Edge',
      ),
    ];

    for (_BrowserDetection detection in detections) {
      if (detection.string.contains(detection.subString)) {
        _detected = detection;

        final String versionSearchString = detection.versionSearch ?? detection.subString;
        String versionFromString = userAgent;
        int index = versionFromString.indexOf(versionSearchString);
        if (index == -1) {
          versionFromString = appVersion;
          index = versionFromString.indexOf(versionSearchString);
        }

        if (index == -1) {
          _version = 'Unknown version';
        } else {
          _version = versionFromString.substring(index + versionSearchString.length + 1);

          if (_version.split(' ').length > 1) {
            _version = _version.split(' ').first;
          }
        }

        break;
      }
    }
  }
}

class _BrowserDetection {
  final BrowserAgent browserAgent;
  final String string;
  final String subString;
  final String? versionSearch;

  /// BrowserDetection initialization
  _BrowserDetection({
    required this.browserAgent,
    required this.string,
    required this.subString,
    this.versionSearch,
  });
}

import 'package:web_browser_detect/src/enum.dart';

/// Browser detection from provided userAgent, vendor and appVersion
/// without dependency on web APIs, so it works cross-platform
class BrowserDetection {
  /// Detect browser and its version if it is known
  factory BrowserDetection.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    final rules = [
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.edgeChromium,
        string: userAgent,
        subString: 'Edg',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.chrome,
        string: userAgent,
        subString: 'Chrome',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.safari,
        string: vendor,
        subString: 'Apple',
        versionSearch: 'Version',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.firefox,
        string: userAgent,
        subString: 'Firefox',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'MSIE',
        versionSearch: 'MSIE',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'Trident',
        versionSearch: 'rv',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.edge,
        string: userAgent,
        subString: 'Edge',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.brave,
        string: userAgent,
        subString: 'Brave',
      ),
      _BrowserDetectionRule(
        browserAgent: BrowserAgent.opera,
        string: userAgent,
        subString: 'OPR',
      ),
    ];

    for (final rule in rules) {
      if (rule.string.contains(rule.subString)) {
        return BrowserDetection._(
          browserAgent: rule.browserAgent,
          version: _detectVersion(
            rule: rule,
            userAgent: userAgent,
            appVersion: appVersion,
          ),
        );
      }
    }

    return const BrowserDetection._(
      browserAgent: BrowserAgent.unknown,
      version: _unknownVersion,
    );
  }

  const BrowserDetection._({required this.browserAgent, required this.version});

  final BrowserAgent browserAgent;
  final String version;

  static const _unknownVersion = 'Unknown version';

  /// Detect version of matched browser from userAgent, fallback to appVersion
  static String _detectVersion({
    required _BrowserDetectionRule rule,
    required String userAgent,
    required String appVersion,
  }) {
    final versionSearchString = rule.versionSearch ?? rule.subString;
    var versionFromString = userAgent;
    var index = versionFromString.indexOf(versionSearchString);
    if (index == -1) {
      versionFromString = appVersion;
      index = versionFromString.indexOf(versionSearchString);
    }

    // Version is expected after search string and one separator, e.g. Chrome/126
    final versionStart = index + versionSearchString.length + 1;
    if (index == -1 || versionStart >= versionFromString.length) {
      return _unknownVersion;
    }

    final version = versionFromString.substring(versionStart);

    return version.split(' ').first;
  }
}

class _BrowserDetectionRule {
  final BrowserAgent browserAgent;
  final String string;
  final String subString;
  final String? versionSearch;

  const _BrowserDetectionRule({
    required this.browserAgent,
    required this.string,
    required this.subString,
    this.versionSearch,
  });
}

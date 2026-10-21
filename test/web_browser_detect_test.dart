import 'package:flutter_test/flutter_test.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

/// Tests run on the Dart VM, so the non-web stub implementation is used
void main() {
  group('Browser on non-web platform', () {
    test('detectOrNull returns null', () {
      expect(Browser.detectOrNull(), isNull);
    });

    test('default constructor does not throw and reports unknown browser', () {
      final browser = Browser();

      expect(browser.browserAgent, BrowserAgent.unknown);
      expect(browser.browser, BrowserAgent.unknown.browserName);
      expect(browser.version, 'Unsupported on non-web platform');
    });
  });

  group('Browser.detectFrom on non-web platform', () {
    /// Detect browser from provided values with defaults for unused ones
    Browser detectFrom({
      required String userAgent,
      String vendor = '',
      String appVersion = '',
    }) => Browser.detectFrom(
      userAgent: userAgent,
      vendor: vendor,
      appVersion: appVersion,
    );

    test('detects Chrome', () {
      final browser = detectFrom(
        userAgent:
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
        vendor: 'Google Inc.',
      );

      expect(browser.browserAgent, BrowserAgent.chrome);
      expect(browser.version, '126.0.0.0');
    });

    test('detects Chromium Edge', () {
      final browser = detectFrom(
        userAgent:
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 '
            'Edg/126.0.2592.87',
        vendor: 'Google Inc.',
      );

      expect(browser.browserAgent, BrowserAgent.edgeChromium);
      expect(browser.version, '126.0.2592.87');
    });

    test('detects Safari', () {
      final browser = detectFrom(
        userAgent:
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
            'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 '
            'Safari/605.1.15',
        vendor: 'Apple Computer, Inc.',
      );

      expect(browser.browserAgent, BrowserAgent.safari);
      expect(browser.version, '17.4');
    });

    test('detects Firefox', () {
      final browser = detectFrom(
        userAgent:
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) '
            'Gecko/20100101 Firefox/128.0',
      );

      expect(browser.browserAgent, BrowserAgent.firefox);
      expect(browser.version, '128.0');
    });

    test('falls back to appVersion for version', () {
      final browser = detectFrom(
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
        vendor: 'Apple Computer, Inc.',
        appVersion: '5.0 (Macintosh) Version/17.4 Safari/605.1.15',
      );

      expect(browser.browserAgent, BrowserAgent.safari);
      expect(browser.version, '17.4');
    });

    test('reports unknown version when nothing follows search string', () {
      final browser = detectFrom(userAgent: 'Firefox');

      expect(browser.browserAgent, BrowserAgent.firefox);
      expect(browser.version, 'Unknown version');
    });

    test('reports unknown browser for unrecognized values', () {
      final browser = detectFrom(userAgent: 'Some unknown agent');

      expect(browser.browserAgent, BrowserAgent.unknown);
      expect(browser.version, 'Unknown version');
    });
  });
}

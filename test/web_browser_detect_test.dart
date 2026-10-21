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
    });
  });
}

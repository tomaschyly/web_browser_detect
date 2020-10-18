import 'package:web_browser_detect/browser.dart';

void main() {
  final browser = Browser();

  final String whatBrowser = browser.browser;

  print('The browser is $whatBrowser');

  final String browserVersion = browser.version;

  print('Browser version is $browserVersionň');
}

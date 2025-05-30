import 'package:web_browser_detect/src/enum.dart';

/// Abstract class to force the presence of getters
abstract class BrowserPlatformAbstract {
  BrowserAgent get browserAgent;
  String get browser;
  String get version;
}

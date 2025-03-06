// Conditional export based on platform
export 'package:web_browser_detect/src/browser.dart'
    if (dart.library.html) 'package:web_browser_detect/src/browser.dart'
    if (dart.library.io) 'package:web_browser_detect/src/browser_stub.dart';

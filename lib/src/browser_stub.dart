enum BrowserAgent {
  unknown('Unknown browser');

  const BrowserAgent(this.browserName);
  final String browserName;
}

class Browser {
  const Browser();

  Browser.detectFrom({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    userAgent = 'unknown';
    vendor = 'unknown';
    appVersion = 'unknown';
  }

  BrowserAgent get browserAgent => BrowserAgent.unknown;
  String get browser => browserAgent.browserName;
  String get version => 'Unsupported on mobile';

  /// Returns null for unsupported platforms.
  static Browser? detectOrNull() => null;
}

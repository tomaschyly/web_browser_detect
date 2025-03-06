class Browser {
  factory Browser() => _singleton;
  Browser._internal();
  final bool isOpera = false;
  final bool isFirefox = false;
  final bool isSafari = false;
  final bool isIE = false;
  final bool isEdge = false;
  final bool isChrome = false;
  final bool isMobile = false;
  final bool isTablet = false;
  final String vendor = '';
  final String userAgent = '';
  final String appVersion = '';
  final String appName = '';
  final String platform = '';
  final int browserVersion = -1;

  static final Browser _singleton = Browser._internal();

  @override
  String toString() => 'Non-web platform';
}

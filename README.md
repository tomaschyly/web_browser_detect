# web_browser_detect

FlutterWeb browser detection package.
This package helps you to detect current browser and version of the browser.

**Warning:** Remember that browser detection using UserAgent is never completely reliable. Therefore if you have some other way to do what you want to do, then do not use this package.

## Contents

- [web_browser_detect](#web_browser_detect)
  - [Contents](#contents)
  - [Installation](#installation)
  - [How to Use](#how-to-use)
  - [Important Notes](#important-notes)

## Installation

In your project's `pubspec.yaml` add:

```yaml
dependencies:
  web_browser_detect: ^2.2.0
```

## How to Use

1. If your IDE does not autoImport, add manually:

```dart
import 'package:web_browser_detect/web_browser_detect.dart';
```

2. Create Browser object and then you can access detected values.

```dart
import 'package:web_browser_detect/web_browser_detect.dart';

void main() {
  final browser = Browser();

  print('${browser.browser} ${browser.version}');
}
```

Or you can use alternative method, which does not throw Exception when you are on other platforms then web, this way you get null, if you are not on web.

```dart
import 'package:web_browser_detect/web_browser_detect.dart';

void main() {
  final browser = Browser.detectOrNull();

  print('${browser?.browser ?? 'Wrong platform'} ${browser?.version ?? 'Wrong platform'}');
}
```

If you want to detect Browser on other platform from your own provided userAgent, vendor & appVersion.

```dart
import 'package:web_browser_detect/web_browser_detect.dart';

void main() {
  final browser = Browser.detectFrom(userAgent: userAgent, vendor: vendor, appVersion: appVersion);

  print('${browser.browser} ${browser.version}');
}
```

## Important Notes

Obviously this package supports only Flutter Web platform, it will not work on others.
Additionally it does not support all current or past browsers, but PRs to add more are welcome.

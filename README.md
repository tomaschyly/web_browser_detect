# web_browser_detect

FlutterWeb browser detection package.
This package helps you to detect current browser and version of the browser.

**Warning:** Remember that browser detection using UserAgent is never completely reliable. Therefore if you have some other way to do what you want to do, then do not use this package.

## Contents

1. [Installation](#installation)
2. [How to Use](#how-to-use)
3. [Important Notes](#important-notes)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  web_browser_detect: ^1.0.2+1
```

## How to Use

1. If your IDE does not autoImport, add manually:

```dart
import 'package:web_browser_detect/browser.dart';
```

2. Create Browser object and then you can access detected values.

```dart
import 'package:web_browser_detect/browser.dart';

void main() {
  final browser = Browser();

  print('${browser.browser} ${browser.version}');
}
```

## Important Notes

Obviously this package supports only Flutter Web platform, it will not work on others.
Additionally it does not support all current or past browsers, but PRs to add more are welcome.

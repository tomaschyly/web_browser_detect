import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final browser = Browser(); // throws exception if not on web platform

    final browser = Browser.detectOrNull(); // return null if not on web platform

    // You provide your own userAgent & vendor, works crossplatform
    // final browser = Browser.detectFrom(userAgent: window.navigator.userAgent, vendor: window.navigator.vendor, appVersion: window.navigator.appVersion);

    return MaterialApp(
      title: 'web_browser_detect Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Material(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The browser is ${browser?.browser ?? 'Wrong platform'}'),
            Text('Browser version is ${browser?.version ?? 'Wrong platform'}'),
          ],
        ),
      ),
    );
  }
}

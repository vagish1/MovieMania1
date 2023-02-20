import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWidget extends StatefulWidget {
  final String initialUrl;
  const MyWidget({super.key, required this.initialUrl});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.initialUrl,
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:poolinspection/src/components/responsive_text.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title,style: TextStyle(fontSize: getFontSize(context, 4))),
          actions: [Image.asset(
            "assets/img/app-iconwhite.jpg",
            // fit: BoxFit.cover,
            fit: BoxFit.fitWidth,
          )],
        ),
        body: WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Newsview extends StatefulWidget {
  final String url;
  Newsview(this.url);

  @override
  State<Newsview> createState() => _NewsviewState();
}

class _NewsviewState extends State<Newsview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News View")),
      body: WebViewWidget(controller: _controller),
    );
  }
}

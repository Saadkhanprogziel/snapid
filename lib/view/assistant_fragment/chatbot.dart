import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZapierChatbotView extends StatefulWidget {
  const ZapierChatbotView({super.key});

  @override
  State<ZapierChatbotView> createState() => _ZapierChatbotViewState();
}

class _ZapierChatbotViewState extends State<ZapierChatbotView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_buildHtml());
  }

  String _buildHtml() {
    return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script async type="module"
        src="https://interfaces.zapier.com/assets/web-components/zapier-interfaces/zapier-interfaces.esm.js">
      </script>
    </head>
    <body style="margin:0;padding:0;display:flex;justify-content:center;align-items:center;height:100vh;">
      <zapier-interfaces-chatbot-embed
        is-popup="false"
        chatbot-id="cmgf34e8q003syxep2fc6i7vb"
        height="600px"
        width="400px">
      </zapier-interfaces-chatbot-embed>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zapier Chatbot')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

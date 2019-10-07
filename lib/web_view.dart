import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatelessWidget {

  final String gotUrl;
  bool isSwitched;

  WebView({Key key, @required this.gotUrl, this.isSwitched}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Read More', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: isSwitched ? Colors.black87 : Colors.blueAccent,
        elevation: 8.0,
      ),
      url: gotUrl,
    );
  }
}
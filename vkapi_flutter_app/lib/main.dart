import 'dart:async';
import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vkapi_flutter_app/MostWeeklyLikedPost.dart';
import 'package:vkapi_flutter_app/RepostTracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vk_sdk/flutter_vk_sdk.dart';
import 'package:http/http.dart' as http;

void main() => runApp(VkApiApp());

class VkApiApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VK Api Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyWidgetState();
}

class BodyWidgetState extends State<BodyWidget>  {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vk Helper'),
      ),
      body: Center(
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () => _login(),
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  _login() async {
    String accessToken;
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    final url = 'https://oauth.vk.com/authorize?client_id=7246061&display=mobile&redirect_uri=https://vk.com/&scope=groups,wall&response_type=token&v=5.103&state=123456';
    flutterWebviewPlugin.launch(url);
    StreamSubscription<String> onChangeUrl;
    onChangeUrl = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        accessToken = url;
        flutterWebviewPlugin.dispose();
        flutterWebviewPlugin.close();
      }
    });
    print(accessToken);
  }
}



import 'dart:async';
import 'dart:convert';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vkapi_flutter_app/MostWeeklyLikedPost.dart';
import 'package:vkapi_flutter_app/RepostTracker.dart';
import 'package:flutter/material.dart';
import 'package:vkapi_flutter_app/ChooseAction.dart';
import 'package:flutter_vk_sdk/flutter_vk_sdk.dart';
import 'package:http/http.dart' as http;

import 'MostWeeklyLikedPost.dart';

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
        child: ActoinList(),
      ),
    );
  }
}



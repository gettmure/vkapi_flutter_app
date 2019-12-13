import 'package:vkapi_flutter_app/RepostTrackerLayout.dart';
import 'package:flutter/material.dart';

void main() => runApp(RepostTracker());

class RepostTracker extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VK Repost Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepostTrackerLayout(),
    );
  }
}

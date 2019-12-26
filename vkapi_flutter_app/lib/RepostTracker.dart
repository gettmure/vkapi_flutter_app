import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:vkapi_flutter_app/RepostData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vkio/vk.dart';

class RepostTracker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RepostTrackerState();
  }
}

class RepostTrackerState extends State<RepostTracker> {
  List<RepostData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VK Repost Tracker'),
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _showPostForm(),
      ),
    );
  }

  _showPostForm() async {
    TextEditingController textFieldController = TextEditingController();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Укажите ссылку на пост'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: textFieldController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        Navigator.pop(context);
                        _loadReposts(textFieldController.text);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }



  _login() async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    const url = 'https://oauth.vk.com/authorize?client_id=7246061&display=mobile&redirect_uri=https://vk.com/&scope=groups,wall&response_type=token&v=5.103';

    flutterWebviewPlugin.launch(url);
    String redirectedUrl = await flutterWebviewPlugin.onUrlChanged.first.then((String url) {
      return url;
    });
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();

    const START = "=";
    const END = "&";

    int startIndex = redirectedUrl.indexOf(START);
    int endIndex = redirectedUrl.indexOf(END);

    String accessToken = redirectedUrl.substring(startIndex + 1, endIndex);

    return new VK(
        token: accessToken
    );
  }

  _getGroupId(String url) {
    const START = 'wall';
    const END = '_';

    int startIndex = url.indexOf(START);
    int endIndex = url.indexOf(END);

    return url.substring(startIndex + START.length, endIndex);
  }

  _getPostId(String url) {
    const START = '_';
    return url.substring(url.indexOf(START) + 1, url.length);
  }

  _loadReposts(String url) async {
    String groupId = _getGroupId(url);
    String postId = _getPostId(url);
    VK vk = await _login();

    var repostsDataList = List<RepostData>();

    final reposts = await vk.api.wall.getReposts({
          'owner_id': groupId,
          'post_id': postId
        }).then((response) {
      return response['response']['profiles'];
    });

    reposts.forEach((dynamic value) {
      var repost = RepostData(
          id: value['id'],
          name: value['first_name'] + ' ' + value['last_name'],
          profilePicture: NetworkImage(value['photo_100']));
      repostsDataList.add(repost);
    });

    setState(() {
      data = repostsDataList;
    });
  }

  List<Widget> _buildList() {
    return data
        .map((RepostData f) => ListTile(
              title: Text(f.name),
              subtitle: Text(f.id.toString()),
              leading: CircleAvatar(
                backgroundImage: f.profilePicture,
                radius: 26,
              ),
            ))
        .toList();
  }
}

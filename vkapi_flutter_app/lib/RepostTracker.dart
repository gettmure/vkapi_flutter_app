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

  _loadReposts(String url) async {
    print(url);
    VK vk = _vkAuth();

    var repostsDataList = List<RepostData>();

    final reposts = await vk.api.wall.getReposts(
        {'owner_id': '-169971271', 'post_id': '5904'}).then((response) {
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

  _vkAuth() {
    return new VK(
        token:
            '05b4daeccbf3c5318e7d6cd2f7d61569ac0fc865fd48fd7a411f38d5d6766ba16a54fbd679755dbe701d5');
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

import 'package:vkapi_flutter_app/RepostData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vkio/vk.dart';

class MostWeeklyLikedPost extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MostWeeklyLikedPostState();
  }
}

class MostWeeklyLikedPostState extends State<MostWeeklyLikedPost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VK Most Weekly Liked Post'),
        ),
        body: Container(
          child: Center(
              child: FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: _loadPosts,
              )
          ),
        )
    );
  }

  _loadPosts() async {
    VK vk = new VK(
        token:'05b4daeccbf3c5318e7d6cd2f7d61569ac0fc865fd48fd7a411f38d5d6766ba16a54fbd679755dbe701d5'
    );

    final response = await vk.api.wall.get({
      'offset': '1',
      'owner_id': '-169971271',
      'domain': 'beatboxmemesh',
      'count': '7',
      'filter': 'owner',
      'extended': '1',
      'fields': 'id, first_name, last_name, screen_name, photo_100'
    }).then((response) {
      return response['response'];
    });

    final posts = response['items'];
    final post = _getMostLikedPost(posts);
    print(post['likes']['count']);
  }

  _getMostLikedPost(var map) {
    Map<String, dynamic> post = new Map<String, dynamic>();
    for (var data in map) {
      if (data.containsKey('signer_key')) {
        int max = 0;
        int likesCount = data['likes']['count'];
        if (likesCount > max) {
          max = likesCount;
          post = data;
        }
      }
    }
//    map.forEach((dynamic data) {
//      if (data.containsKey('signer_key')) {
//        int max = 0;
//        int likesCount = data['likes']['count'];
//        if (likesCount > max) {
//          max = likesCount;
//          post = data;
//        }
//      }
//    });
//    return post;
  }
}
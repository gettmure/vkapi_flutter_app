import 'dart:async';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:vkapi_flutter_app/PostData.dart';
import 'package:flutter/material.dart';
import 'package:vkapi_flutter_app/widgets/Hyperlink.dart';
import 'package:vkio/vk.dart';
import 'package:url_launcher/url_launcher.dart';

class MostWeeklyLikedPost extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MostWeeklyLikedPostState();
  }
}

class MostWeeklyLikedPostState extends State<MostWeeklyLikedPost> {
  PostData mostLikedPost;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VK Most Weekly Like Post'),
      ),
      body: Container(
        child: Center(
          child: _buildMostLikedPostWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:  Icon(Icons.refresh),
        onPressed: () => _loadPosts(),
      ),
    );
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

  _loadPosts() async {
    VK vk = await _login();
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

    final allPosts = response['items'];
    final allUsers = response['profiles'];

    _collectPostInfo(allPosts, allUsers);
  }

  _collectPostInfo(var posts, var users) {
    final post = _getMostLikedPost(posts);
    final user = _getPostAuthor(users, post['signer_id']);

    String userVkUrl = 'vk.com/' + user['screen_name'];
    String userName = user['first_name'] + ' ' + user['last_name'];
    NetworkImage userProfilePicture = NetworkImage(user['photo_100']);
    NetworkImage postPicture = NetworkImage(post['attachments'][0]['photo']['sizes'][3]['url']);
    int likes = post['likes']['count'];

    setState(() {
      mostLikedPost = new PostData(url: userVkUrl, authorName: userName,
          profilePicture: userProfilePicture, postAttachedPicture: postPicture, likesCount: likes);
    });
  }

  _getMostLikedPost(var posts) {
    var post;
    int max = 0;
    for (var data in posts) {
      if (data.containsKey('signer_id')) {
        int likesCount = data['likes']['count'];
        if (likesCount > max) {
          max = likesCount;
          post = data;
        }
      }
    }

    return post;
  }

  _getPostAuthor(var users, var authorId) {
    for (var data in users) {
      if (data['id'] == authorId) {
        return data;
      }
    }

    return null;
  }

  Column _buildMostLikedPostWidget() {
    if (mostLikedPost == null) return Column();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          alignment: FractionalOffset(0, 20),
          image: mostLikedPost.postAttachedPicture,
        ),
        ListTile (
            title: Text(mostLikedPost.authorName),
            subtitle: Hyperlink('https://' + mostLikedPost.url + '/', mostLikedPost.url),
            leading: CircleAvatar(
              backgroundImage: mostLikedPost.profilePicture,
              radius: 26,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                Text(mostLikedPost.likesCount.toString()),
              ],
            )
        ),
      ],
    );
  }

}
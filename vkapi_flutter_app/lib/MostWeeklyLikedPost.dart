import 'dart:async';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:vkapi_flutter_app/PostData.dart';
import 'package:flutter/material.dart';
import 'package:vkapi_flutter_app/widgets/Hyperlink.dart';
import 'package:vkio/vk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class MostWeeklyLikedPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MostWeeklyLikedPostState();
  }
}

class MostWeeklyLikedPostState extends State<MostWeeklyLikedPost> {
  VK _vk;

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
        child: Icon(Icons.refresh),
        onPressed: () => _showGroupForm(),
      ),
    );
  }

  _showGroupForm() async {
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
                    child: Text('Укажите ссылку на группу'),
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
                        _loadPosts(textFieldController.text);
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
    const url =
        'https://oauth.vk.com/authorize?client_id=7246061&display=mobile&redirect_uri=https://vk.com/&scope=groups,wall&response_type=token&v=5.103';

    flutterWebviewPlugin.launch(url);
    String redirectedUrl =
        await flutterWebviewPlugin.onUrlChanged.first.then((String url) {
      return url;
    });
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();

    const START = "=";
    const END = "&";

    int startIndex = redirectedUrl.indexOf(START);
    int endIndex = redirectedUrl.indexOf(END);

    String accessToken = redirectedUrl.substring(startIndex + 1, endIndex);

    return new VK(token: accessToken);
  }

  _loadPosts(String url) async {
    if (_vk == null) {
      _vk = await _login();
    }

    if (url.isNotEmpty) {
      if (isURL(url) && matches(url, "vk.com\/(.+)")) {
        String regexString = "vk.com\/(.+)";
        RegExp regExp = new RegExp(regexString);
        var matches = regExp.allMatches(url);
        var match = matches.elementAt(0);
        String groupDomain = match.group(1);
        final response = await _vk.api.wall.get({
          'offset': '1',
          'domain': groupDomain,
          'count': '7',
          'filter': 'owner',
          'extended': '1',
          'fields': 'id, first_name, last_name, screen_name, photo_100'
        }).then((response) {
          return response['response'];
        });
        if (response != []) {
          final allPosts = response['items'];
          final allUsers = response['profiles'];

          _collectPostInfo(allPosts, allUsers);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Ошибка!"),
                  content: Text("Не удалось получить список постов, проверьте правильность ссылки!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ввести ссылку ещё раз"),
                      onPressed: () {
                        Navigator.pop(context);
                        _showGroupForm();
                      },
                    ),
                    FlatButton(
                      child: Text("ОК"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ошибка!"),
              content: Text("Поле для ссылки не может быть пустым!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ввести ссылку ещё раз"),
                  onPressed: () {
                    Navigator.pop(context);
                    _showGroupForm();
                  },
                ),
                FlatButton(
                  child: Text("ОК"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  _collectPostInfo(var posts, var users) {
    try {
      final post = _getMostLikedPost(posts);
      final user = _getPostAuthor(users, post['signer_id']);

      String userVkUrl = 'vk.com/' + user['screen_name'];
      String userName = user['first_name'] + ' ' + user['last_name'];
      NetworkImage userProfilePicture = NetworkImage(user['photo_100']);
      NetworkImage postPicture =
      NetworkImage(post['attachments'][0]['photo']['sizes'][3]['url']);
      int likes = post['likes']['count'];

      setState(() {
        mostLikedPost = new PostData(
            url: userVkUrl,
            authorName: userName,
            profilePicture: userProfilePicture,
            postAttachedPicture: postPicture,
            likesCount: likes);
      });
    } on NoSuchMethodError catch(e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Ошибка!"),
              content: Text("Произошла ошибка во время получения постов. Возможно, на стене группы нет предложенных записей, либо ссылка на группу введена не верно."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ввести ссылку ещё раз"),
                  onPressed: () {
                    Navigator.pop(context);
                    _showGroupForm();
                  },
                ),
                FlatButton(
                  child: Text("ОК"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }

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
        ListTile(
            title: Text(mostLikedPost.authorName),
            subtitle: Hyperlink(
                'https://' + mostLikedPost.url + '/', mostLikedPost.url),
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
            )),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';

class PostData {
  String url;
  String authorName;
  NetworkImage profilePicture;
  NetworkImage postAttachedPicture;
  int likesCount;

  PostData({this.url, this.authorName, this.profilePicture, this.postAttachedPicture, this.likesCount});
}
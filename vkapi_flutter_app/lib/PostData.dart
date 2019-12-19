import 'package:flutter/cupertino.dart';

class PostData {
  int postedAt;
  int authorId;
  String authorName;
  String screenName;
  NetworkImage profilePicture;
  NetworkImage postPicture;

  PostData({this.postedAt, this.authorId, this.authorName, this.screenName, this.profilePicture, this.postPicture});
}
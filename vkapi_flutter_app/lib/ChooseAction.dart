import 'package:flutter/material.dart';

import 'MostWeeklyLikedPost.dart';
import 'RepostTracker.dart';

class ActionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RepostTracker())),
                child: Text(
                  "REPOST TRACKER",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MostWeeklyLikedPost())),
                child: Text(
                  "MOST WEEKLY LIKED POST",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
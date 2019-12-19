import 'package:flutter_vk_sdk/models/vk_access_token.dart';
import 'package:vkapi_flutter_app/RepostTrackerLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vk_sdk/flutter_vk_sdk.dart';

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
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RepostTrackerLayout())),
            child: Text(
              "LOGIN",
              style: TextStyle(fontSize: 20.0),
            ),
          )
      ),
    );
  }
}

//class Login extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Vk Helper'),
//      ),
//      body: Center(
//          child: FlatButton(
//            color: Colors.blue,
//            textColor: Colors.white,
//            padding: EdgeInsets.all(8.0),
//            splashColor: Colors.blueAccent,
//            onPressed: () => {},
//            child: Text(
//              "LOGIN",
//              style: TextStyle(fontSize: 20.0),
//            ),
//          )
//      ),
//    );
//  }
//}



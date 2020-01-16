
import 'package:flutter/material.dart';
import 'package:vkapi_flutter_app/ChooseAction.dart';

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
        child: ActionList(),
      ),
    );
  }
}



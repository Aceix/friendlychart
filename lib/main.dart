import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  final String appTitle = 'FriendlyChat';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      home: new ChatScreen(title: appTitle),
      theme: new ThemeData.dark(),
    );
  }
}

class ChatScreen extends StatefulWidget{
  final String title;

  ChatScreen({this.title});

  @override
  State<ChatScreen> createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>{
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(widget.title),
    ),
    body: _buildTextComposer(),
  );

  Widget _buildTextComposer() => new IconTheme(
    data: Theme.of(context).accentIconTheme,
    child: new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"
              ),
            ),
          ),
          new Container(
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.toString()),
            )
          )
        ],
      ),
    )
  );

  void _handleSubmitted(String text){
    _textController.clear();
  }
}

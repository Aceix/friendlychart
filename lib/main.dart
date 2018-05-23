import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(new MyApp());

const String _name = "Aceix Smart";
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);
final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget{
  final String appTitle = 'FriendlyChat';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      home: new ChatScreen(title: appTitle),
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
    );
  }
}

class ChatScreen extends StatefulWidget{
  final String title;

  ChatScreen({this.title});

  @override
  State<ChatScreen> createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(widget.title),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
    ),
    body: new Container(
      decoration: Theme.of(context).platform == TargetPlatform.iOS
        ? new BoxDecoration(
            border: new Border(
              top: new BorderSide(color: Colors.grey[200])
            )
          )
        : null,
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int i) => _messages[i],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 2.0,),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    ),
  );

  @override
  void dispose(){
    for(ChatMessage msg in _messages){
      msg.animationController.dispose();
    }
    super.dispose();
  }

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
              onChanged: (String text){
                _isComposing = text.length > 0;
              },
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"
              ),
            ),
          ),
          new Container(
            child: Theme.of(context).platform == TargetPlatform.iOS 
            ? new CupertinoButton(
                child: new Text('Send'),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
              )
            : new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _isComposing ? _handleSubmitted(_textController.text) : null,
              ),
          )
        ],
      ),
    )
  );

  void _handleSubmitted(String text){
    _textController.clear();
    setState((){
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 700),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final AnimationController animationController;
  
  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

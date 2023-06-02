import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';


class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }

  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }
}

class MyHomePage extends StatefulWidget {
  // final WebSocketChannel channel;
  //
  // MyHomePage({required this.channel});

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = new TextEditingController();
  // late Socket socket;

  // IOWebSocketChannel channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/chat');

  late StompClient stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/chat',
        onConnect: onConnectCallback,
        onStompError: onError
  ));
  // WebSocketChannel? channel;

  void _setUpStompClient() {
    stompClient.activate();
  }

  @override
  void initState() {
    super.initState();
    _setUpStompClient();
  }

  void onConnectCallback(StompFrame connectFrame) {
    print('stomp client connected');
    stompClient.subscribe(destination: '/topic/chat', callback: frameCallback);
  }

  void onError(StompFrame stompFrame) {
    print('error');
  }

  void frameCallback(StompFrame frame) {
    print(frame.body);
  }
      @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text("Web Socket"),
          ),
          body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Form(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: "Send any message"),
                    controller: editingController,
                  ),
                ),
                // new StreamBuilder(
                //   stream: channel.stream,
                //   builder: (context, snapshot) {
                //     return new Padding(
                //       padding: const EdgeInsets.all(20.0),
                //       child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),
                //     );
                //   },
                // )
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.send),
            onPressed: () {
              print('pressed');
              // channel.sink.add('test');
              // print(stompClient.connected);
              stompClient.send(destination: '/app/chat', body: json.encode(
                  {
                    "text": editingController.text,
                    "eventId": 1,
                    "personNickname": "Dunadan"
                  })
              );
            },
          ),
        );
  }
}

import 'dart:convert';


import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/widgets/ChatWidget.dart';
import 'package:boardgm/widgets/NameWidget.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<ChatBubble> chatsBubbles = [
    ChatBubble(text: "hello", isCurrentUser: true, interlocutor: Interlocutor(nickname: "denis", name: "denis", avatarId: 2)),
    ChatBubble(text: "hello", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "denis2", avatarId: 3)),
    ChatBubble(text: "hello ", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "denisgjh2", avatarId: 3)),
    ChatBubble(text: "hello", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "denisfsdf2", avatarId: 2)),
    ChatBubble(text: "hellofdsfsdfdsfdsfdsf fhdjfdkskjgfdghdsghldf", isCurrentUser: false, interlocutor: Interlocutor(nickname: "deniadsfds", name: "dfdsfenis2", avatarId: 1)),
    ChatBubble(text: "hello", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "densdfis2", avatarId: 2)),
    ChatBubble(text: "hello ", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "denisgjh2", avatarId: 3)),
    ChatBubble(text: "hello", isCurrentUser: false, interlocutor: Interlocutor(nickname: "denis", name: "denisfsdf2", avatarId: 2)),
    ChatBubble(text: "hellof", isCurrentUser: false, interlocutor: Interlocutor(nickname: "deniadsfds", name: "dfdsfenis2", avatarId: 1)),
    ChatBubble(text: "hello", isCurrentUser: true, interlocutor: Interlocutor(nickname: "denis", name: "densdfis2", avatarId: 2)),

  ];

  late StompClient stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/chat',
        onConnect: onConnectCallback,
        onStompError: onError
  ));

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
  void dispose() {
    messageController.dispose();
    super.dispose();
    stompClient.deactivate();
  }

      @override
  Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title:
              Text("Чат", style: TextStyle(fontSize: 24),),
              //
              centerTitle: true,
              backgroundColor: Color(0xff50bc55),
            ),
            backgroundColor: Color(0xff292929),
          body: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  //shrinkWrap: true,
                    itemCount: chatsBubbles.length,
                    itemBuilder: (_, index) =>
                       chatsBubbles[index]
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 100, 16),
                child: NameWidget(controller: messageController, text: "Сообщение",)
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: new Icon(Icons.send),
            onPressed: () {
              //if (messageController.text.isEmpty) return;
              print('pressed');
              // channel.sink.add('test');
              // print(stompClient.connected);
              Restart.restartApp();
              stompClient.send(destination: '/app/chat', body: json.encode(
                  {
                    "text": messageController.text,
                    "eventId": 1,
                    "personNickname": "Dunadan"
                  })
              );
            },
          ),
        );
  }
}


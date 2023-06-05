import 'dart:convert';


import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/utils/dialog.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/widgets/ChatWidget.dart';
import 'package:boardgm/widgets/NameWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../apiclient/events_api_client.dart';
import '../bloc/events_bloc.dart';
import '../repositories/events_repository.dart';

class ChatScreen extends StatefulWidget {

  late int color;

  ChatScreen({super.key, required this.color});

  @override
  ChatScreenState createState() {
    return ChatScreenState(color: color);
  }
}

class ChatScreenState extends State<ChatScreen> {

  late int color;

  ChatScreenState({required this.color});
  TextEditingController messageController = TextEditingController();
  List<Widget> chatBubbles = [];
  final scrollController = ScrollController();
  final bloc = EventsBloc(
      eventsRepository: EventsRepository(
          apiClient: EventsApiClient()
      )
  );
  late int eventId;

  late StompClient stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/chat',
        onConnect: onConnectCallback,
        onStompError: onError,
        onDisconnect: onDisconnect
  ));

  void _setUpStompClient() {
    stompClient.activate();
  }

  @override
  void initState() {
    super.initState();
    //scrollController.jumpTo(scrollController.position.maxScrollExtent);
    scrollController.addListener(_scrollListener);
    _setUpStompClient();
  }

  void _scrollListener() {
    // Проверяем, если мы прокрутили до конца списка
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      bloc.add(LoadMessages(eventId));
    }
  }

  void onConnectCallback(StompFrame connectFrame) {
    print('stomp client connected');
    stompClient.subscribe(destination: '/topic/chat', callback: frameCallback);
  }

  void onError(StompFrame stompFrame) {
    print('error');
  }

  void onDisconnect(StompFrame farem) {
    print('disconnected');
  }

  void frameCallback(StompFrame frame) {
    var json = jsonDecode(frame.body!);
    if (json['eventId'] as int == eventId) {
      setState(() {
        chatBubbles.insert(0, ChatBubble.fromJson(json));
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
    stompClient.deactivate();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

      @override
  Widget build(BuildContext context) {
    eventId = (ModalRoute.of(context)?.settings.arguments) as int;

        return BlocProvider(
          create: (context) => bloc..add(LoadMessages(eventId)),
          child: Scaffold(
              appBar: AppBar(
                title:
                Text("Чат", style: TextStyle(fontSize: 24),),
                //
                centerTitle: true,
                backgroundColor: Color(color),
              ),
              backgroundColor: Color(0xff292929),
            body: BlocBuilder<EventsBloc, EventsState>(
              builder: (context, state) {
                if (state is MessagesLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      chatBubbles = state.messages;
                    });
                  });
                  return Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          controller: scrollController,
                            reverse: true,
                            itemCount: chatBubbles.length,
                            itemBuilder: (_, index) =>
                            chatBubbles[index]
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 100, 16),
                          child: NameWidget(
                            controller: messageController, text: "Сообщение",)
                      )
                    ],
                  );
                } else if (state is EventsFirstLoading) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is EventsError) {
                  return Center(child: Text(state.errorMessage),);
                } else {
                  return Container();
                }
              }
            ),
            floatingActionButton: FloatingActionButton(
              child: new Icon(Icons.send),
              onPressed: () async {
                //if (messageController.text.isEmpty) return;
                print('pressed');
                // await DialogUtil.showErrorDialog(context, "Удоли");
                stompClient.send(destination: '/app/chat', body: json.encode(
                    {
                      "text": messageController.text,
                      "eventId": eventId,
                      "personNickname": await Preference.getNickname()
                    })
                );
                messageController.clear();
              },
            ),
          ),
        );
  }
}


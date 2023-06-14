import 'dart:convert';


import 'package:appmetrica_plugin/appmetrica_plugin.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late int color;
  static const authorization = 'Authorization';
  static const bearer = 'Bearer ';
  static const address = 'https://board-game-meet-dunad4n.cloud.okteto.net';

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
  late String token;
  late String nickname;
  bool isAdmin = false;

  late StompClient stompClient;

  void _setUpStompClient() async {
    stompClient = StompClient(
        config: StompConfig(
            url: 'ws://board-game-meet-dunad4n.cloud.okteto.net/chat',
            webSocketConnectHeaders: {authorization: bearer + (await Preference.getToken())!},
            onConnect: onConnectCallback,
            onStompError: onError,
            onDisconnect: onDisconnect
        ));
    stompClient.activate();
  }

  @override
  void initState() {
    _setToken();
    _setAdmin();
    _setNickname();
    super.initState();
    scrollController.addListener(_scrollListener);
    _setUpStompClient();
    AppMetrica.reportEvent('Chat screen');
  }

  _setToken() async {
    token = (await Preference.getToken())!;
  }

  _setNickname() async {
    nickname = (await Preference.getNickname())!;
  }

  _setAdmin() async {
    isAdmin = await Preference.isAdmin();
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
    var json = jsonDecode(stompFrame.body!);

    print(json['statusCodeValue']);
  }

  void onDisconnect(StompFrame frame) {
    print('disconnected');
  }

  void frameCallback(StompFrame frame) async {
    var json = await jsonDecode(frame.body!);
    print(json);
    int statusCode = json['statusCodeValue'];
    if (statusCode == 200) {
      if (json['body']['eventId'] as int == eventId) {
        setState(() {
          chatBubbles.insert(0, ChatBubble.fromJson(json['body'], nickname));
        });
      }
    } else {
      print(json);
      if (json['body'] == nickname) {
        _errorHandler(statusCode);
      }
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
              key: _scaffoldKey,
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
                            controller: messageController, text: "Сообщение", size: 255,)
                      )
                    ],
                  );
                } else if (state is EventsFirstLoading) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is EventNotFoundError)  {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      DialogUtil.showErrorDialog(context, state.errorMessage);
                    });
                  return Container();
                } else if (state is KickPersonError)  {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    DialogUtil.showErrorDialog(context, state.errorMessage);
                  });
                  return Container();
                } else if (state is EventsError) {
                  return Center(child: Text(state.errorMessage),);
                } else {
                  return Container();
                }
              }
            ),
            floatingActionButton: FloatingActionButton(
              child: new Icon(Icons.send),
              backgroundColor: Color(color),
              onPressed: () async {
                if (messageController.text.isEmpty) return;
                try {
                  stompClient.send(destination: '/app/chat',
                    body: json.encode(
                  {
                  "text": messageController.text,
                  "eventId": eventId,
                  "personNickname": await Preference.getNickname()
                  }),
                  );
                } catch (e) {

                }
                messageController.clear();
              },
            ),
          ),
        );
  }

  Future<void> _errorHandler(int code) async {
    if (code == 471) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      DialogUtil.showErrorDialog(context, "Мероприятие не найдено, возможно оно было удалено создателем или администратором");
    } else if (code == 472) {
      await DialogUtil.showErrorDialog(context, "Ошибка авторизации");
      await Preference.deletePreferences();
      Restart.restartApp();
    } else if (code == 473) {
      if (isAdmin) {
        DialogUtil.showErrorDialog(context, "Вы не являетесь участником мероприятия!");
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        DialogUtil.showErrorDialog(context, "Похоже вы были исключены из мероприятия");
      }
    }
  }
}


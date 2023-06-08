import 'package:boardgm/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/events_api_client.dart';
import '../bloc/events_bloc.dart';
import '../model/dto/event_dto.dart';
import '../repositories/events_repository.dart';

class MainScreen extends StatefulWidget {

  late int color;
  MainScreen({super.key, required this.color});


  @override
  State<MainScreen> createState() => _MainScreenState(color: color);
}

class _MainScreenState extends State<MainScreen> {

  late int color;

  _MainScreenState({required this.color});
  List<MainPageEvent> events = [];
  String? avatarPath;
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  String? search;
  final bloc = EventsBloc(
      eventsRepository: EventsRepository(
          apiClient: EventsApiClient()
      )
  );

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
    _getAvatar();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    // Удаляем обработчик прокрутки списка
    //scrollController.removeListener(_scrollListener);
  }

  Future<void> _getAvatar() async {
      avatarPath = await Preference.getAvatar();
  }

  void _scrollListener() {
    // Проверяем, если мы прокрутили до конца списка
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      bloc.add(LoadEvents(search));
    }
  }

  @override
  void didChangeDependencies() {
    print("hello");
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    search = (ModalRoute.of(context)?.settings.arguments) == null ? null : (ModalRoute.of(context)?.settings.arguments) as String;
    return BlocProvider<EventsBloc>(
      create: (context) => bloc..add(LoadEvents(search)),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Список мероприятий", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: RefreshIndicator(
          onRefresh: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
          child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is MainPageEventsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  events = state.events;
                });
              });
              return Column(
                children: [buildAvatar(),
                  buildSearchLine(), getColumnEvents()],
              );
            } else if (state is EventsFirstLoading) {
              return Column(
                children: [buildAvatar(),
                  buildSearchLine(), Expanded(child: Center(child: CircularProgressIndicator(),))],
              );
            } else if (state is EventsLoading) {
              return Column(
                children: [buildAvatar(),
                  buildSearchLine(), getColumnEvents(), Center(child: CircularProgressIndicator())],
              );
            } else if (state is EventsError) {
              return Center(child: Text(state.errorMessage),);
            } else {
              return Container();
            }
          }
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          await Preference.checkToken() ? Navigator.pushNamed(context, '/editEvent') : Navigator.pushNamed(context, '/authorization');
        },
          backgroundColor: Color(color),
          child: Icon(Icons.add, color: Colors.white, size: 30.0,),
          heroTag: 'create_event',
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.black,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (int index) async {
            if (index == 1) {
              await Preference.checkToken()
                  ? Navigator.pushNamedAndRemoveUntil(context, '/my_events', (route) => false)
                  :Navigator.pushNamed(context, '/authorization');
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.0,),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, size: 30.0,),
                label: ""),
          ],
          backgroundColor: Color(color),
        ),
      ),
    );
  }

  Widget getColumnEvents() {
    return
      Flexible(
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: ListView.builder(
            //shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: events.length,
              itemBuilder: (_, index) =>
                  Card(
                    color: Colors.white,
                    child: ListTile(
                        onTap: ()  async {
                            MainPageEvent selectedEvent = events[index];
                            await Navigator.pushNamed(context, '/eventShow',
                                arguments: [selectedEvent.name,
                                  selectedEvent.game,
                                  selectedEvent.date,
                                  selectedEvent.address,
                                  selectedEvent.viewCountPlayers(),
                                  selectedEvent.id]);
                        },
                        title: Text(events[index].name),
                        subtitle: Text(
                            "${events[index].game} - ${(events[index].date
                                .toString()).substring(0, 16)} - ${events[index].address}")
                    ),
                  )
          ),
        ),
      );
  }

  Container buildSearchLine() {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Поиск",
                    fillColor:  Color(0xff171717),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white60)
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
                onPressed: () {
                  print(search);
                  if (searchController.text.isEmpty) {
                    if (search == null) {
                      return;
                    } else {
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/home', (route) => false);
                    }
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context,
                        '/home', (route) => false,
                        arguments: searchController.text);
                  }
                },
                icon: Icon(Icons.search), color: Colors.white,),
          ]),
    );
  }

  Padding buildAvatar() {
    return Padding(
    padding: EdgeInsets.all(16),
    child: Align(
      alignment: Alignment.topRight,
      child: avatarPath == null ?
      ElevatedButton( onPressed: () {
        Navigator.pushNamed(context, "/authorization");
      },
        child: Text("Войти"),
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
      ) :
      FloatingActionButton(onPressed: () async {
        await Preference.savePath('/home');
        Navigator.pushNamed(context, '/profile', arguments: [null, null, await Preference.getNickname()]);
      },
        child: CircleAvatar(
          backgroundImage: AssetImage(avatarPath!),
          radius: 200,
        ),
        heroTag: 'avatar',
      ),
    ),
    );
  }

}
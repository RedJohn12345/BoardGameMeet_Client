import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiclient/events_api_client.dart';
import '../bloc/events_bloc.dart';
import '../model/dto/event_dto.dart';
import '../repositories/events_repository.dart';

class MainScreen extends StatefulWidget {


  MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<MainPageEvent> events = [];
  Widget button = Container();
  final scrollController = ScrollController();
  final bloc = EventsBloc(
      eventsRepository: EventsRepository(
          apiClient: EventsApiClient()
      )
  )..add(LoadEvents("Voronezh", null));

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // Удаляем обработчик прокрутки списка
    scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    // Проверяем, если мы прокрутили до конца списка
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      bloc.add(LoadEvents("string", null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Список мероприятий", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is MainPageEventsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                events = state.events;
              });
            });
            return Column(
              children: getColumnEvents(),
            );
          } else if (state is ButtonEntry) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                button =
                    ElevatedButton( onPressed: () {
                      Navigator.pushNamed(context, "/authorization");
                    },
                      child: Text("Войти"),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                    );
              });
            });
            return Column(
              children: getColumnEvents(),
            );
          } else if (state is AvatarIsLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                button = FloatingActionButton(onPressed: () {
                  Navigator.pushNamed(context, '/profile', arguments: state.nickname);
                },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(state.avatar),
                    radius: 200,
                  ),
                  heroTag: 'avatar',
                );
              });
            });
            return Column(
              children: getColumnEvents(),
            );
          } else if (state is EventsFirstLoading) {
            return Center(child: CircularProgressIndicator(),);
          } else if (state is EventsLoading) {
            return Column(
              children: getColumnEvents()..add(Center(child: CircularProgressIndicator())),
            );
          } else if (state is EventsError) {
            return Center(child: Text(state.errorMessage),);
          } else {
            return Container();
          }
        }
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          await _checkToken() ? Navigator.pushNamed(context, '/editEvent', arguments: null) : Navigator.pushNamed(context, '/authorization');
          // Navigator.pushNamed(context, '/authorization');
        },
          backgroundColor: Color(0xff50bc55),
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
              await _checkToken()
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
          backgroundColor: Color(0xff50bc55),
        ),
      ),
    );
  }

  List<Widget> getColumnEvents() {
    return [Padding(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topRight,
        child: this.button),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Row(
            children: [
              Expanded(
                child: const TextField(
                  decoration: InputDecoration(
                      hintText: "Введите название игры или мероприятия",
                      fillColor:  Color(0xff171717),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.white60)
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //IconButton(onPressed: (){}, icon: Icon(Icons.search))
            ]),
      ),
      Flexible(
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: ListView.builder(
            //shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (_, index) =>
                  Card(
                    color: Colors.white,
                    child: ListTile(
                        onTap: () {
                          MainPageEvent selectedEvent = events[index];
                          Navigator.pushNamed(context, '/eventShow',
                              arguments: [selectedEvent.name,
                                          selectedEvent.game,
                                          selectedEvent.date,
                                          selectedEvent.address,
                                          selectedEvent.viewCountPlayers(),
                                          selectedEvent.id]);
                        },
                        title: Text(events[index].name),
                        subtitle: Text(
                            "${events[index].game} - ${events[index].date
                                .toString()} - ${events[index].address}")
                    ),
                  )
          ),
        ),
      ),];
  }

  static Future<bool> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

}
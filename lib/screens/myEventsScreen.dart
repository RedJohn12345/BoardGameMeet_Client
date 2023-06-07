import 'package:boardgm/apiclient/events_api_client.dart';
import 'package:boardgm/bloc/events_bloc.dart';
import 'package:boardgm/custom_icons.dart';
import 'package:boardgm/repositories/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/event.dart';
import '../utils/preference.dart';

class MyEventsScreen extends StatefulWidget {

  late int color;

  MyEventsScreen({super.key, required this.color});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState(color: color);
}

class _MyEventsScreenState extends State<MyEventsScreen> {

  late int color;
  _MyEventsScreenState({required this.color});
  List<Event> myEvents = [];
  Widget button = Container();
  final scrollController = ScrollController();
  final bloc = EventsBloc(
      eventsRepository: EventsRepository(
          apiClient: EventsApiClient()
      )
  )..add(LoadMyEvents());

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
      bloc.add(LoadMyEvents());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Мои мероприятия", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is MyEventsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  myEvents = state.events;
                });
              });
              return Column(
                children: getColumnEvents(),
              );
            } else if (state is AvatarIsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  button = FloatingActionButton(onPressed: () async {
                    await Navigator.pushNamed(context, '/profile', arguments: [null, null, state.nickname]);
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
          }),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.pushNamed(context, '/editEvent', arguments: null);
        },
          backgroundColor: Color(color),
          child: Icon(Icons.add, color: Colors.white, size: 30.0,),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          onTap: (int index) {
            if (index == 0) {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
  
  List<Widget> getColumnEvents() {
    return [
      Padding(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topRight,
        child: button
      ),
    ),
      Flexible(
        child: Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: ListView.builder(
            //shrinkWrap: true,
              controller: scrollController,
              itemCount: myEvents.length,
              itemBuilder: (_, index) =>
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () async {
                          await Navigator.pushNamed(context, '/event', arguments: [myEvents[index], '/my_events']);
                          },
                      title: myEvents[index].date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch
                          ? Text(myEvents[index].name) : Text("${myEvents[index].name} (Прошел)") ,
                      subtitle: Text(
                          "${myEvents[index].game} - ${(myEvents[index].date
                              .toString()).substring(0, 16)} - ${myEvents[index].location}"),
                      trailing: Icon(myEvents[index].isHost ? CustomIcons.crown : Icons.account_box),
                    ),
                  )
          ),
        ),
      ),
    ];
  }
}
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event.dart';
import '../model/item.dart';
import '../repositories/persons_repository.dart';

class EventScreen extends StatefulWidget {

  EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  final personBloc = PersonBloc(
          personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );
  List<Item> items = [];
  bool isAdmin = false;

  @override void initState() {
    _setAdmin();
    super.initState();
  }

  _setAdmin() async {
    isAdmin = await _isAdmin();
  }

  @override
  Widget build(BuildContext context) {

    final list = (ModalRoute.of(context)?.settings.arguments) as List;
    final event = list[0] as Event;
    final route = list[1] as String;

    final List<Widget> itemsWidget = [];

    final List<Widget> params = [
      const Center(child: Text("Игра", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.game, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Дата", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.date.toString(), style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Место", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.location, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Описание", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Align(alignment: Alignment.topLeft, child: Text(event.description, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.viewCountPlayers(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      Row(
        children: [
          Expanded(
              child: Center(child: Text("Нужные предметы", style: TextStyle(color: Colors.black, fontSize: 26)))),
          event.isHost ? IconButton(onPressed: () {
            Navigator.pushNamed(context, "/items", arguments: event);
          }, icon: Icon(Icons.edit), color: Colors.black,
          ) : SizedBox(),
        ],
      ),
      const SizedBox(height: 10,),
    ];

    for (Item item in items) {
      itemsWidget.add(Container(
        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black), borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(item.name),
                value: item.marked,
                onChanged: (bool? value) {
                  setState(() {
                    item.marked = value!;
                  });
                },
              ),
          ],
        ),
      ),
      );
      itemsWidget.add(const SizedBox(height: 10,),);
    }

    params.add(itemsWidget.length == 0 ? SizedBox() : Container(decoration: BoxDecoration(
        color: Color(0xff50bc55),
        borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),child: Column(children: itemsWidget,)));

    return BlocProvider<PersonBloc>(
      create: (context) => personBloc..add(LoadEventForPerson(event.id!)),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(event.name, style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
          actions: [
            IconButton(onPressed: () async {
              final membersCount = await Navigator.pushNamed(context, '/members', arguments: [event.id, event.isHost]) as int;
              setState(() {
                event.numberPlayers = membersCount;
              });
            },
                icon: Icon(Icons.account_box_sharp)),
            Visibility(
                visible: event.isHost && event.date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch,
                child: IconButton(onPressed: () {
                  Navigator.pushNamed(context, '/editEvent', arguments: event);
                },
                    icon: Icon(Icons.edit)),
            ),
          ],
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState>(
          builder: (context, state) {
            if (state is EventForPersonLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  items = state.items;
                });
              });
              return Column(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ListView.builder(
                        itemCount: params.length,
                        itemBuilder: (_, index) =>
                        params[index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        children: [
                          Visibility(
                            visible: event.isHost || isAdmin,
                              //   () async {
                              // return await _isAdmin();
                              // },
                              child: Expanded(
                                child: ElevatedButton(onPressed: () {
                                  personBloc.add(DeleteEvent(event.id!));
                                },
                                child: Text("Удалить"),
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Color(0xff50bc55))),
                                ),
                              )
                          ),
                          Visibility(
                            visible: !event.isHost,
                            child: Expanded(
                              child: ElevatedButton(onPressed: () {
                                personBloc.add(LeaveFromEvent(event.id));
                              },
                                child: Text("Покинуть"),
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Color(0xff50bc55))),
                              ),
                            )
                          ),
                          const SizedBox(width: 16,),
                          Expanded(
                            child: ElevatedButton(onPressed: () {
                              Navigator.pushReplacementNamed(context, '/');
                            },
                              child: Text("Чат"),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<
                                      Color>(Color(0xff50bc55))),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],);
            } else if (state is LeavingFromEvent) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is DeletingEvent) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              return Center(child: Text(state.errorMessage),);
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        )
      ),
    );
  }

  static Future<bool> _isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') == 'USER_ADMIN';
  }

}
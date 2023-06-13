import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../model/event.dart';
import '../model/item.dart';
import '../repositories/persons_repository.dart';
import '../utils/dialog.dart';

class EventScreen extends StatefulWidget {

  late int color;

  EventScreen({super.key, required this.color});

  @override
  State<EventScreen> createState() => _EventScreenState(color: color);
}

class _EventScreenState extends State<EventScreen> {

  final personBloc = PersonBloc(
          personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );
  late int color;

  _EventScreenState({required this.color});
  List<Item> items = [];
  bool isAdmin = false;
  bool showOnly = false;
  List<Widget> params = [];
  Event? event;
  String? pathBack;

  @override void initState() {
    _setAdmin();
    super.initState();
    _getPathBack();
    AppMetrica.reportEvent('Event screen');
  }

  _setAdmin() async {
    isAdmin = await Preference.isAdmin();
  }

  Future<void> _getPathBack() async {
    pathBack = await Preference.getPath();
  }

  @override
  Widget build(BuildContext context) {
    var id = (ModalRoute.of(context)?.settings.arguments) as int;

    return BlocProvider<PersonBloc>(
      create: (context) => personBloc..add(LoadEventForPerson(id)),
      child: WillPopScope(
        onWillPop: () {
          if (pathBack == null) {
            return Future.value(true);
          }
          Navigator.pushNamedAndRemoveUntil(context, pathBack!, (route) => false);
          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacementNamed(context, '/event', arguments: id);
          },
          child: Scaffold(
            appBar: AppBar(
              title: event == null ? SizedBox() :
                  Text(event!.name, style: TextStyle(fontSize: 24),),
              //
              centerTitle: true,
              backgroundColor: Color(color),
              actions: [
                event == null ? SizedBox() :
                IconButton(onPressed: () {
                  Navigator.pushNamed(context, '/members', arguments: event);

                },
                    icon: Icon(Icons.account_box_sharp)),
                event == null ? SizedBox() :
                Visibility(
                    visible: event!.isHost && event!.date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch,
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
                      event = state.event;
                      params = getParams();
                    });
                  });
                  return buildColumn(params, state.event, context);
                } else if (state is LeavingFromEvent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamedAndRemoveUntil(context, '/my_events', (route) => false);
                  });
                  return const Center(child: CircularProgressIndicator(),);
                } else if (state is PersonsLoading) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is DeletingEvent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamedAndRemoveUntil(context, '/my_events', (route) => false);
                  });
                  return const Center(child: CircularProgressIndicator(),);
                } else if (state is AddressLoadedEvent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await Navigator.pushNamed(context, '/mapShow', arguments: [state.point, state.address]);
                    setState(() {
                      personBloc.add(LoadEventForPerson(id));
                    });
                  });
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is EventNotFoundErrorForPerson)  {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    DialogUtil.showErrorDialog(context, state.errorMessage);
                  });
                  return Container();
                } else if (state is KickPersonErrorForPerson)  {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    DialogUtil.showErrorDialog(context, state.errorMessage);
                  });
                  return Container();
                } else if (state is PersonsError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await DialogUtil.showErrorDialog(context, "Не удалось подключиться к серверу");
                    Restart.restartApp();
                  });
                  return Container();
                } else {
                  return Container();
                }
              }
            )
          ),
        ),
      ),
    );
  }

  Column buildColumn(List<Widget> params, Event event, BuildContext context) {
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
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Color(color))),
                                ),
                              ),
                          ),
                          Visibility(
                            visible: event.isHost || isAdmin,
                            //   () async {
                            // return await _isAdmin();
                            // },
                            child: const SizedBox(width: 16,),
                          ),
                          Visibility(
                            visible: !event.isHost,
                            child: Expanded(
                              child: ElevatedButton(onPressed: () async {
                                if (isAdmin && !(await PersonsApiClient.fetchIsMemberEvent(event.id))) {
                                  Navigator.pushNamedAndRemoveUntil(context, '/my_events', (route) => false);
                                  return;
                                }
                                personBloc.add(LeaveFromEvent(event.id));
                              },
                                child: Text("Покинуть"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Color(color))),
                              ),
                            )
                          ),
                          const SizedBox(width: 16,),
                          Expanded(
                            child: ElevatedButton(onPressed: () {
                              Navigator.pushNamed(context, '/chat', arguments: event.id);
                            },
                              child: Text("Чат"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<
                                      Color>(Color(color))),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],);
  }

  List<Widget> getParams() {
    List<Widget> list = [
      const Center(child: Text("Игра", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event!.game, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Дата", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text((event!.date
          .toString()).substring(0, 16), style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Место", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event!.location, style: TextStyle(color: Colors.black, fontSize: 24)),),
      Center(child: TextButton(onPressed: () {
        setState(() {
          personBloc.add(ShowAddress(event!.location));
        });
      },
        child: Text("Посмотреть на карте", style: TextStyle(fontSize: 24, color: Colors.blue),),
      ),
      ),
      const SizedBox(height: 16,),
      event!.description.isEmpty ? Container() :
      const Center(child: Text("Описание", style: TextStyle(color: Colors.black, fontSize: 26)),),
      event!.description.isEmpty ? Container() :
      Align(alignment: Alignment.topLeft, child: Text(event!.description, style: TextStyle(color: Colors.black, fontSize: 24)),),
      event!.description.isEmpty ? Container() :
      const SizedBox(height: 16,),
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event!.viewCountPlayers(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      Row(
        children: [
          Expanded(
              child: Center(child: Text("Нужные предметы", style: TextStyle(color: Colors.black, fontSize: 26)))),
          (event!.isHost  && event!.date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)
              ? IconButton(onPressed: () {
            Navigator.pushNamed(context, "/items", arguments: event);
          }, icon: Icon(Icons.edit), color: Colors.black,
          ) : SizedBox(),
        ],
      ),
      const SizedBox(height: 10,),
    ];

    final List<Widget> itemsWidget = [];

    for (Item item in items) {
      itemsWidget.add(Container(
        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black), borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(item.name),
              value: item.marked,
              onChanged: (bool? value) async {
                setState(() {
                  item.marked = value!;
                });
                if (isAdmin && !(await PersonsApiClient.fetchIsMemberEvent(event!.id))) {
                  return;
                }
                personBloc.add(MarkItem(event!.id!, item));
              },
            ),
          ],
        ),
      ),
      );
      itemsWidget.add(const SizedBox(height: 10,),);
    }

    list.add(itemsWidget.isEmpty ? const SizedBox() : Container(decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),child: Column(children: itemsWidget,)));

    return list;
  }
}
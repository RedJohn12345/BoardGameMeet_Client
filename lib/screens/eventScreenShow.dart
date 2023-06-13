
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:boardgm/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';

import '../utils/dialog.dart';
import '../utils/preference.dart';


class EventScreenShow extends StatefulWidget {

  late int color;

  EventScreenShow({super.key, required this.color});

  @override
  State<EventScreenShow> createState() => _EventScreenShowState(color: color);
}

class _EventScreenShowState extends State<EventScreenShow> {

  final bloc = PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );
  bool isAdmin = false;
  late int color;

  _EventScreenShowState({required this.color});

  @override void initState() {
    _setAdmin();
    super.initState();
    AppMetrica.reportEvent('Event show screen');
  }

  _setAdmin() async {
    isAdmin = await Preference.isAdmin();
  }

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments) as List;
    final name = arguments[0] as String;
    final game = arguments[1] as String;
    final date = arguments[2] as DateTime;
    final address = arguments[3] as String;
    final viewCountPlayers = arguments[4] as String;
    final eventId = arguments[5] as int;


    final List<Widget> params = [
      const Center(child: Text("Игра", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(game, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Дата", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text((date
          .toString()).substring(0, 16), style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Место", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(address, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(viewCountPlayers, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];

    return BlocProvider<PersonBloc>(
      create: (context) => bloc..add(WatchEvent(eventId)),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(name, style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState> (
          builder: (context, state) {
            if (state is WatchingEvent) {
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
                          Expanded(
                            child: ElevatedButton(onPressed: () async {
                              await Preference.checkToken()
                                  ? setState(() {
                                      bloc.add(JoinToEvent(eventId: eventId));
                                    })
                                  :Navigator.pushNamed(context, '/authorization');
                                  AppMetrica.reportEvent('User is joining to event');
                            },
                              child: Text("Вступить"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<
                                      Color>(Color(color))),
                            ),

                          ),
                          Visibility(
                            visible: isAdmin,
                            child: SizedBox(width: 16,)
                          ),
                          Visibility(
                            visible: isAdmin,
                            child: Expanded(
                              child: ElevatedButton(onPressed: () {
                                setState(() {
                                  bloc.add(AdminShowEvent(eventId: eventId));
                                });
                              },
                                child: Text("Посмотреть"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll<
                                        Color>(Color(color))),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],);
            } else if (state is JoinedToEvent) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Preference.savePath('/home');
                Navigator.pushReplacementNamed(
                    context, '/event', arguments: state.event.id);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is AdminShowedEvent) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Navigator.pushReplacementNamed(
                    context, '/event', arguments: state.event.id);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is EventNotFoundErrorForPerson)  {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                DialogUtil.showErrorDialog(context, state.errorMessage);;
              });
              return Container();
            } else if (state is PersonsError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, "Не удалось подключиться к серверу");
                Restart.restartApp();
              });
              return Container();
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        )
      )
    );
  }
}
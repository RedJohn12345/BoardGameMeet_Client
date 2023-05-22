
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../model/event.dart';

class EventScreenShow extends StatefulWidget {

  EventScreenShow({super.key});

  @override
  State<EventScreenShow> createState() => _EventScreenShowState();
}

class _EventScreenShowState extends State<EventScreenShow> {

  final bloc = PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );

  @override
  Widget build(BuildContext context) {

    final event = (ModalRoute.of(context)?.settings.arguments) as Event;


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
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.viewCountPlayers(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];

    return BlocProvider<PersonBloc>(
      create: (context) => bloc..add(WatchEvent()),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(event.name, style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonsState> (
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
                            child: ElevatedButton(onPressed: () {
                              setState(() {
                                bloc.add(JoinToEvent(eventId: event.id));
                              });
                            },
                              child: Text("Вступить"),
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<
                                      Color>(Color(0xff50bc55))),
                            ),
                          ),
                        ]
                    ),
                  ),
                ],);
            } else if (state is JoinedToEvent) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(
                    context, '/event', arguments: event);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              return Center(child: Text(state.errorMessage),);
            } else {
              return const Center(child: CircularProgressIndicator(),);
            }
          }
        )
      )
    );
  }
}
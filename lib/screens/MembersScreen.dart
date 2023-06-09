import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/custom_icons.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';

import '../apiclient/persons_api_client.dart';
import '../model/dto/member_dto.dart';
import '../model/event.dart';
import '../utils/dialog.dart';
import '../utils/preference.dart';

class MembersScreen extends StatefulWidget {

  late int color;

  MembersScreen({super.key, required this.color});

  @override
  State<MembersScreen> createState() => _MembersScreenState(color: color);
}

class _MembersScreenState extends State<MembersScreen> {
  final bloc = PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );
  late int id;
  late int color;
  late bool isHost;

  _MembersScreenState({required this.color});
  final scrollController = ScrollController();
  List<MemberInEvent> members = [];

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
    AppMetrica.reportEvent('Members screen');
  }

  @override
  void dispose() {
    super.dispose();
    // Удаляем обработчик прокрутки списка
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }

  void _scrollListener() {
    // Проверяем, если мы прокрутили до конца списка
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bloc.add(AllMembersOfEvent(id));
    }
  }


  @override
  Widget build(BuildContext context) {
    final event = (ModalRoute.of(context)?.settings.arguments) as Event;
    id = event.id!;
    isHost = event.isHost;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(context, "/event", arguments: event.id,
                (Route<dynamic> route) => route.settings.name != '/event' && route.settings.name != '/members');
        return Future.value(false);
      },
      child: BlocProvider(create: (context) => bloc..add(AllMembersOfEvent(id)),
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacementNamed(context, '/members', arguments: [event]);
          },
          child: Scaffold(
            appBar: AppBar(
              title:
              Text("Список участников", style: TextStyle(fontSize: 24),),
              //
              centerTitle: true,
              backgroundColor: Color(color),
            ),
            backgroundColor: Color(0xff292929),
            body: BlocBuilder<PersonBloc, PersonState>(
                builder: (context, state) {
                  if (state is AllMembers) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        members = state.members;
                      });
                    });
                    return Column(
                      children: [
                        const SizedBox(height: 40,),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                            child: ListView.builder(
                              //shrinkWrap: true,
                                controller: scrollController,
                                itemCount: state.members.length,
                                itemBuilder: (context, int index) =>
                                  Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      onTap: () async {
                                        await Preference.deletePath();
                                        Navigator.pushNamed(context, '/profile',
                                            arguments: [event, state.members[index].nickname]);
                                      },
                                      title: Text(state.members[index].nickname),
                                      leading: SizedBox(height: 40, width: 40,
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(state.members[index].getAvatar()),
                                          radius: 200,
                                        ),
                                      ),
                                      trailing:
                                      index == 0 ? IconButton(icon: Icon(CustomIcons.crown), onPressed: (){}, splashRadius: 1, enableFeedback: false,) :
                                      Visibility(
                                          visible: isHost && index > 0,
                                          child: IconButton(icon: Icon(
                                              Icons.disabled_by_default_outlined),
                                            color: Colors.red,
                                            onPressed: () {
                                              bloc.add(KickPerson(state.members[index].nickname, id));
                                            },
                                          )
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is KickingPerson) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, '/members', arguments: event);
                    });
                    return Center(child: Text("error"),);
                  } else if (state is EventNotFoundErrorForPerson)  {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      DialogUtil.showErrorDialog(context, state.errorMessage);
                    });
                    return Container();
                  } else if (state is PersonNotFoundErrorForPerson)  {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await DialogUtil.showErrorDialog(context, state.errorMessage);
                      Navigator.pushReplacementNamed(context, '/members', arguments: event);
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
                  } else if (state is PersonsFirstLoading) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else {
                    return Container();
                  }
                }
            ),
          ),
        ),
      )
    );
    }
}
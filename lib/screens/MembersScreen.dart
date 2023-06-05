import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/custom_icons.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/persons_api_client.dart';
import '../model/dto/member_dto.dart';

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

  _MembersScreenState({required this.color});
  final scrollController = ScrollController();
  List<MemberInEvent> members = [];

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
    scrollController.dispose();
  }

  void _scrollListener() {
    // Проверяем, если мы прокрутили до конца списка
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bloc.add(AllMembersOfEvent(id));
      print("hay");
    }
  }


  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as List;
    id = arguments[0] as int;
    final isHost = arguments[1] as bool;
    late int membersCount;

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, membersCount);
        return Future.value(true);
      },
      child: BlocProvider(create: (context) => bloc..add(AllMembersOfEvent(id)),
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
                      membersCount = state.members.length;
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
                                    onTap: () {
                                      Navigator.pushNamed(context, '/profile',
                                          arguments: [id, isHost, state.members[index].nickname]);
                                    },
                                    title: Text(state.members[index].nickname),
                                    leading: SizedBox(height: 40, width: 40,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(state.members[index].getAvatar()),
                                        radius: 200,
                                      ),
                                    ),
                                    trailing:
                                    index == 0 ? Icon(CustomIcons.crown) :
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
                    Navigator.pushReplacementNamed(context, '/members', arguments: [id, isHost]);
                  });
                  return Center(child: Text("error"),);
                } else if (state is PersonsError) {
                  return Center(child: Text(state.errorMessage),);
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              }
          ),
        ),
      )
    );
    }
}
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/persons_api_client.dart';
import '../model/member.dart';

class MembersScreen extends StatelessWidget {

  final bloc = PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()
      )
  );

  final int numberPage = 1;
  final List<Member> members = [
  ];


  MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = (ModalRoute
        .of(context)
        ?.settings
        .arguments) as int;
    bloc.add(AllMembersOfEvent(id));

    return BlocProvider(create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
          Text("Список участников", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonsState>(
            builder: (context, state) {
              if (state is AllMembers) {
                return Column(
                  children: [
                    const SizedBox(height: 40,),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: ListView.builder(
                          //shrinkWrap: true,
                            itemCount: state.members.length,
                            itemBuilder: (_, index) =>
                                Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/profile',
                                          arguments: state.members[index]);
                                    },
                                    title: Text(state.members[index].nickname),
                                    leading: SizedBox(height: 40, width: 40,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(members[index].getAvatar()),
                                        radius: 200,
                                      ),
                                    ),
                                    trailing: IconButton(icon: Icon(
                                        Icons.disabled_by_default_outlined),
                                      color: Colors.red,
                                      onPressed: () {},),
                                  ),
                                )
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is PersonsError) {
                return Center(child: Text(state.errorMessage),);
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            }
        ),
      ),
    );
  }
}
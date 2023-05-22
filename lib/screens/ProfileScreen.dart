
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/Sex.dart';
import '../model/member.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bloc = PersonBloc(personRepository: PersonsRepository(apiClient: PersonsApiClient()));

  @override
  Widget build(BuildContext context) {

    String? nickname = ModalRoute.of(context)?.settings.arguments == null ? null : ModalRoute.of(context)?.settings.arguments as String;
    Member? member;

    return BlocProvider<PersonBloc>(
      create: (context) => bloc..add(nickname == null ? LoadOwnProfile() : LoadProfile(nickname)),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Профиль", style: TextStyle(fontSize: 24),),
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
          actions: nickname == null ?[
            IconButton(onPressed: () {
              Navigator.pushReplacementNamed(context, '/profileEdit', arguments: member);
            }, icon: Icon(Icons.settings))
          ] : [],
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonsState>(
            builder: (context, state) {
              if (state is OwnProfileLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    member = state.member;
                  });
                });
                return Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          children: getParams(state.member),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton( onPressed: () {
                                setState(() {
                                  bloc.add(ExitProfile());
                                });
                              },
                                child: Text("Выйти"),
                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                              ),
                            ),]
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    member = state.member;
                  });
                });
                return Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          children: getParams(state.member),
                        )
                    ),
                  ],
                );
              } else if (state is PersonsLoading) {
                return Center(child: CircularProgressIndicator(),);
              } else if (state is PersonsError) {
                return Center(child: Text(state.errorMessage),);
              } else if (state is ExitSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                });
                return const Center(child: CircularProgressIndicator(),);
              } else {
                return Container();
              }
            }
        ),

      ),
    );
  }

  List<Widget> getParams(Member member) {
    return [
      Center(
        child: SizedBox(height: 140, width: 140,
          child: CircleAvatar(
            backgroundImage: AssetImage(member.pathToAvatar),
            radius: 200,
          ),
        ),
      ),
      const SizedBox(height: 16,),
      Center(child: Text(member.sex == Sex.NONE ? "" : member.sex.title, style: TextStyle(color: Colors.black, fontSize: 26)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Имя", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.name, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Никнейм", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.login, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      const Center(child: Text("Город", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.city, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      member.age == 0 ? SizedBox() : const Center(child: Text("Возраст", style: TextStyle(color: Colors.black, fontSize: 26)),),
      member.age == 0 ? SizedBox() : Center(child: Text(member.age.toString(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];
  }

}
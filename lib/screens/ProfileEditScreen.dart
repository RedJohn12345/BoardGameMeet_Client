import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:boardgm/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../model/member.dart';
import '../utils/dialog.dart';
import '../widgets/CityWidget.dart';
import '../widgets/LoginWidget.dart';
import '../widgets/NameWidget.dart';
import '../widgets/SexWidget.dart';
import '../widgets/ageWidget.dart';

class ProfileEditScreen extends StatefulWidget {

  late int color;

  ProfileEditScreen({super.key, required this.color});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState(color: color);
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {

  late int color;

  _ProfileEditScreenState({required this.color});

  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final cityController = TextEditingController();
  final SexWidget sexController = SexWidget();

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Profile edit screen');
  }

  @override
  void dispose() {
    nicknameController.dispose();
    nameController.dispose();
    ageController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = (ModalRoute
        .of(context)
        ?.settings
        .arguments) as Member;

    nicknameController.text = member.nickname;
    nameController.text = member.name;
    ageController.text = member.age == null ? "" : member.age.toString();
    cityController.text = member.city;
    sexController.sex = member.sex;
    final params = getParams(member);
    final bloc = PersonBloc(
        personRepository: PersonsRepository(apiClient: PersonsApiClient()));
    return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/profile', arguments: [null, null, member.nickname]);
          return Future.value(true);
        },
        child: BlocProvider<PersonBloc>(
          create: (context) => bloc,
          child: Scaffold(
              appBar: AppBar(
                title:
                Text("Редактирование профиля", style: TextStyle(fontSize: 24),),
                //
                centerTitle: true,
                backgroundColor: Color(color),
              ),
              backgroundColor: Color(0xff292929),
              body: BlocBuilder<PersonBloc, PersonState>(
                builder: (context, state) {
                  if (state is PersonsInitial) {
                    return buildCenter(params, member, bloc);
                  } else if (state is PersonsLoading) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (state is PersonsError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await DialogUtil.showErrorDialog(context, state.getErrorMessageWithoutException());
                    });
                    return buildCenter(params, member, bloc);
                    //return Center(child: Text(state.errorMessage),);
                  } else if (state is UpdateProfileSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, '/profile', arguments: [null, null, nicknameController.text]);
                    });
                    return const Center(child: CircularProgressIndicator(),);
                  } else {
                    return Container();
                  }
                },
              )
          ),
        )
    );
  }

  Center buildCenter(List<Widget> params, Member member, PersonBloc bloc) {
    return Center(
                    child: Form(
                      key: formKey,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                            children: [
                              Flexible(
                              child: ListView.builder(
                                itemCount: params.length,
                                itemBuilder: (_, index) =>
                                params[index],
                                ),
                              ),
                              Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(onPressed: () {
                                        final form = formKey.currentState!;
                                        if (form.validate()) {
                                          Member profile = Member(
                                              nickname: nicknameController.text, name: nameController.text, city: cityController.text,
                                              age: ageController.text.isEmpty ? null : int.parse(ageController.text), avatarId: member.avatarId, sex: sexController.sex);
                                          bloc.add(UpdateProfile(profile));
                                        }
                                      },
                                        child: Text("Сохранить"),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll<
                                                Color>(Color(color))),
                                      ),
                                    ),
                                  ]
                              ),

                              const SizedBox(height: 16,),
                            ]),
                      ),
                    ),
                  );
  }

  List<Widget> getParams(Member member) {
    return [Center(
      child: SizedBox(height: 140, width: 140,
        child: FloatingActionButton(
          onPressed: () async {
            final memberResponse = await Navigator.pushNamed(
                context, '/avatarChoose', arguments: member) as Member;
            setState(() {
              member.avatarId = memberResponse.avatarId;
              member.nickname = nicknameController.text;
              member.name = nameController.text;
              member.city = cityController.text;
            });
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(
                member.getAvatar()),
            radius: 200,
          ),
        ),
      ),
    ),
      const SizedBox(height: 16,),
      sexController,
      const SizedBox(height: 16,),
      NameWidget(controller: nameController,),
      const SizedBox(height: 16,),
      LoginWidget(controller: nicknameController,),
      const SizedBox(height: 16,),
      CityWidget(controller: cityController, city: member.city,),
      const SizedBox(height: 16,),
      AgeWidget(controller: ageController),
      const SizedBox(height: 16,),];
  }
}
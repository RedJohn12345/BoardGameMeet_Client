import 'dart:ffi';

import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/SexWidget.dart';
import '../widgets/ageWidget.dart';

class Registration2Screen extends StatefulWidget {

  Registration2Screen({super.key});

  @override
  State<Registration2Screen> createState() => _Registration2ScreenState();
}

class _Registration2ScreenState extends State<Registration2Screen> {
  final ageController = TextEditingController();
  final passwordController = TextEditingController();
  final SexWidget sexController = SexWidget();

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = (ModalRoute.of(context)?.settings.arguments) as Member;
    final bloc =  PersonBloc(
    repository: PersonsRepository(
    apiClient: PersonsApiClient()));
    return BlocProvider<PersonBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Регистрация", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(0xff50bc55),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonsState> (
          builder: (context, state) {
            if (state is PersonsInitial ) {
              return Center(
                child: Form(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: sexController),
                            ],
                          ),
                          const SizedBox(height: 16,),
                          AgeWidget(controller: ageController,),
                          const SizedBox(height: 16,),
                          Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton( onPressed: () {
                                    member.sex = sexController.sex;
                                    member.age = ageController.text.isNotEmpty ? int.parse(ageController.text) : 0;
                                    bloc.add(RegistrationPerson(member));
                                  },
                                    child: Text("Продолжить"),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                                  ),
                                ),]
                          ),

                          const SizedBox(height: 16,),
                          Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton( onPressed: () {
                                    bloc.add(RegistrationPerson(member));
                                  },
                                    child: Text("Пропустить"),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                                  ),
                                ),]
                          ),

                          const SizedBox(height: 16,),
                        ]),
                  ),
                ),
              );
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              return Center(child: Text(state.errorMessage),);
            } else if (state is RegistrationSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return Container();
            }
          },
        )

      ),
    );
  }
}
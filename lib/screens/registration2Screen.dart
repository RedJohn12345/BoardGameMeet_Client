import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import '../utils/dialog.dart';
import '../widgets/SexWidget.dart';
import '../widgets/ageWidget.dart';

class Registration2Screen extends StatefulWidget {

  late int color;

  Registration2Screen({super.key, required this.color});

  @override
  State<Registration2Screen> createState() => _Registration2ScreenState(color: color);
}

class _Registration2ScreenState extends State<Registration2Screen> {
  late int color;

  _Registration2ScreenState({required this.color});
  final ageController = TextEditingController();
  final passwordController = TextEditingController();
  final SexWidget sexController = SexWidget();

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Registration screen 2');
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = (ModalRoute.of(context)?.settings.arguments) as Member;
    final bloc =  PersonBloc(
    personRepository: PersonsRepository(
    apiClient: PersonsApiClient()));
    return BlocProvider<PersonBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Регистрация", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState> (
          builder: (context, state) {
            if (state is PersonsInitial ) {
              return buildCenter(member, bloc);
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonInputError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, state.errorMessage);
              });
              return buildCenter(member, bloc);
            } else if (state is PersonsError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, "Не удалось подключиться к серверу");
                Restart.restartApp();
              });
              return Container();
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

  Center buildCenter(Member member, PersonBloc bloc) {
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
                                  member.age = ageController.text.isNotEmpty ? int.parse(ageController.text) : null;
                                  bloc.add(RegistrationPerson(member));
                                  AppMetrica.reportEvent('User doing registration');
                                },
                                  child: Text("Продолжить"),
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                ),
                              ),]
                        ),

                        const SizedBox(height: 16,),
                        Row(
                            children: [
                              Expanded(
                                child: ElevatedButton( onPressed: () {
                                  bloc.add(RegistrationPerson(member));
                                  AppMetrica.reportEvent('User doing registration');
                                },
                                  child: Text("Пропустить"),
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                ),
                              ),]
                        ),

                        const SizedBox(height: 16,),
                      ]),
                ),
              ),
            );
  }
}
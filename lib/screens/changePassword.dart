import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/model/dto/member_dto.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';

import '../utils/dialog.dart';
import '../widgets/LoginWidget.dart';

import '../widgets/SecretWordWidget.dart';

class ChangePasswordScreen extends StatefulWidget {

  late int color;
  ChangePasswordScreen({super.key, required this.color});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState(color: color);
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  late int color;

  _ChangePasswordScreenState({required this.color});
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final secretWordController = TextEditingController();
  final PersonBloc bloc = PersonBloc(personRepository: PersonsRepository(apiClient: PersonsApiClient()));
  bool isValid = true;

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Change password screen 1');
  }

  @override
  void dispose() {
    loginController.dispose();
    secretWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Восстановление пароля", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState>(
          builder: (context, state) {
            if (state is PersonsInitial) {
            return Center(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        children: [
                          LoginWidget(controller: loginController, withHelper: false,),
                          const SizedBox(height: 16,),
                          SecretWordWidget(controller: secretWordController, withHelper: false,),
                          const SizedBox(height: 5,),
                          isValid ? Container() : const Center(child:
                          Text("Неверное секретное слово", style: TextStyle(color: Colors.red),),),
                          const SizedBox(height: 16,),
                          Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton( onPressed: () {
                                    final form = formKey.currentState!;
                                    if (form.validate()) {
                                      setState(() {
                                        bloc.add(ValidateSecretWordEvent(NickNameAndSecretWord(
                                          nickname: loginController.text,
                                          secretWord: secretWordController.text
                                        )));
                                      });
                                    }
                                  },
                                    child: Text("Продолжить"),
                                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                  ),
                                ),]
                          ),

                          const SizedBox(height: 16,),
                        ]),
                  ),
                ),
              );
            } else if (state is ValidateSecretWordResult) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state.valid) {
                  Navigator.pushNamedAndRemoveUntil(context, '/changePassword+', (route) => false, arguments: loginController.text);
                } else {
                  setState(() {
                    isValid = false;
                    bloc.add(InitialEvent());
                  });
                }
              });
              return Center(child: CircularProgressIndicator());
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, "Не удалось подключиться к серверу");
                Restart.restartApp();
              });
              return Container();
            } else  {
              return Container();
            }
          }

        )

      ),
    );
  }
}
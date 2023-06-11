import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/utils/analytics.dart';
import 'package:boardgm/utils/dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/persons_api_client.dart';
import '../model/member.dart';
import '../repositories/persons_repository.dart';
import '../widgets/LoginWidget.dart';
import '../widgets/PasswordWidget.dart';

class AuthorizationScreen extends StatefulWidget {

  late int color;
  final FirebaseAnalytics analytics;
  AuthorizationScreen({super.key, required this.color, required this.analytics});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState(color: color, analytics: analytics);
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {

  late int color;
  final FirebaseAnalytics analytics;
  // final  FirebaseAnalyticsObserver observer;


  _AuthorizationScreenState({required this.color, required this.analytics});
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final bloc =  PersonBloc(
      personRepository: PersonsRepository(
          apiClient: PersonsApiClient()));

  @override
  void initState() {
    super.initState();
    widget.analytics.setCurrentScreen(screenName: 'Authorization screen');
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<PersonBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Авторизация", style: TextStyle(fontSize: 24),),
          //
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
        body: BlocBuilder<PersonBloc, PersonState> (
          builder: (context, state) {
            if (state is PersonsInitial ) {
              return buildCenter(bloc, context);
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await DialogUtil.showErrorDialog(context, state.getErrorMessageWithoutException());
              });
              return buildCenter(bloc, context);
              //return Center(child: Text(state.errorMessage),);
            } else if (state is AuthorizationSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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

  Center buildCenter(PersonBloc bloc, BuildContext context) {
    return Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      children: [
                        LoginWidget(controller: loginController),
                        const SizedBox(height: 16,),
                        PasswordWidget(controller: passwordController,),
                        const SizedBox(height: 16,),
                        Row(
                            children: [
                              Expanded(
                                child: ElevatedButton( onPressed: () {
                                  final form = formKey.currentState!;
                                  if (form.validate()) {
                                    Member member = Member(nickname: loginController.text, password: passwordController.text);
                                    setState(() {
                                      bloc.add(AuthorizationPerson(member));
                                    });
                                  }
                                },
                                  child: Text("Войти"),
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                ),
                              ),]
                        ),
                        const SizedBox(height: 16,),
                        Row(
                            children: [
                              Expanded(
                                child: ElevatedButton( onPressed: () {
                                  Navigator.pushNamed(context, '/registration');
                                },
                                  child: Text("Зарегистрироваться"),
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                ),
                              ),]
                        ),
                        const SizedBox(height: 16,),
                        TextButton(
                          child: Text("Восстановление пароля", style: TextStyle(fontSize: 21, color: Colors.blue,), textAlign: TextAlign.center,),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/changePassword');
                          },
                        ),
                        const SizedBox(height: 16,),
                      ]),
                ),
              ),
            );
  }
}
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../apiclient/persons_api_client.dart';
import '../model/member.dart';
import '../repositories/persons_repository.dart';
import '../widgets/LoginWidget.dart';
import '../widgets/PasswordWidget.dart';

class AuthorizationScreen extends StatefulWidget {

  AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {

  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc =  PersonBloc(
        personRepository: PersonsRepository(
            apiClient: PersonsApiClient()));
    return BlocProvider<PersonBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Авторизация", style: TextStyle(fontSize: 24),),
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
                                      Member member = Member(login: loginController.text, password: passwordController.text);
                                      bloc.add(AuthorizationPerson(member));
                                    }
                                  },
                                    child: Text("Войти"),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
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
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
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
            } else if (state is PersonsLoading) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (state is PersonsError) {
              return Center(child: Text(state.errorMessage),);
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
}
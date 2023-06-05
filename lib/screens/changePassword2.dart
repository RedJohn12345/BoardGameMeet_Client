import 'package:boardgm/bloc/person_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../apiclient/persons_api_client.dart';
import '../repositories/persons_repository.dart';
import '../widgets/PasswordWidget.dart';

class ChangePassword2Screen extends StatefulWidget {

  late int color;
  ChangePassword2Screen({super.key, required this.color});

  @override
  State<ChangePassword2Screen> createState() => _ChangePassword2ScreenState(color: color);
}

class _ChangePassword2ScreenState extends State<ChangePassword2Screen> {
  late int color;
  _ChangePassword2ScreenState({required this.color});
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final repeatController = TextEditingController();
  final PersonBloc bloc = PersonBloc(personRepository: PersonsRepository(apiClient: PersonsApiClient()));

  @override
  void dispose() {
    passwordController.dispose();
    repeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nickname = (ModalRoute.of(context)?.settings.arguments) as String;
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
                          PasswordWidget(controller: passwordController, withHelper: true,),
                          const SizedBox(height: 16,),
                          PasswordWidget(controller: repeatController, withHelper: true, hintText: "Повторение пароля", subController: passwordController,),
                          const SizedBox(height: 16,),
                          Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton( onPressed: () {
                                    final form = formKey.currentState!;
                                    if (form.validate()) {
                                      setState(() {
                                        bloc.add(ChangePasswordEvent(passwordController.text,
                                            repeatController.text, nickname));
                                      });
                                    }
                                  },
                                    child: Text("Восстановить"),
                                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(color))),
                                  ),
                                ),]
                          ),

                          const SizedBox(height: 16,),
                        ]),
                  ),
                ),
              );
            } else if (state is ChangePasswordSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              });
              return CircularProgressIndicator();
            } else {
              return Container();
            }
          }
        )

      ),
    );
  }
}
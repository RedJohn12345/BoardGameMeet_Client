import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/bloc/person_bloc.dart';
import 'package:boardgm/custom_icons.dart';
import 'package:boardgm/repositories/persons_repository.dart';
import 'package:boardgm/utils/analytics.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Sex.dart';
import '../model/event.dart';
import '../model/member.dart';
import '../utils/dialog.dart';

class ProfileScreen extends StatefulWidget {

  late int color;

  ProfileScreen({super.key, required this.color});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(color: color);
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int color;
  _ProfileScreenState({required this.color});
  String? pathBack;
  final bloc = PersonBloc(personRepository: PersonsRepository(apiClient: PersonsApiClient()));
  bool isAdmin = false;
  bool isMyProfile = false;
  Member? member;

  @override void initState() {
    _setAdmin();
    super.initState();
    _getPathBack();
    AppMetrica.reportEvent('Profile screen');
  }

  _setAdmin() async {
    isAdmin = await _isAdmin();
    print(isAdmin);
  }

  Future<void> _getPathBack() async {
    pathBack = await Preference.getPath();
  }

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments) as List;
    final event = arguments[0] as Event?;
    final nickname = arguments[1] as String;
    // Member? member;

    return BlocProvider<PersonBloc>(
      create: (context) => bloc..add(LoadProfile(nickname)),
      child: WillPopScope(
        onWillPop: () {
          if (pathBack == null) {
            return Future.value(true);
          }

          Navigator.pushNamedAndRemoveUntil(context, pathBack!, (route) => false);

          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacementNamed(context, '/profile', arguments: [event, nickname]);
          },
          child: Scaffold(
                  appBar: AppBar(
                    title:
                    Text("Профиль", style: TextStyle(fontSize: 24),),
                    centerTitle: true,
                    backgroundColor: Color(color),
                    actions: isMyProfile && member != null ? [
                      IconButton(onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/profileEdit', arguments: member);
                      }, icon: Icon(Icons.settings))
                    ] : [],
                  ),
                  backgroundColor: Color(0xff292929),
                  body: BlocBuilder<PersonBloc, PersonState>(
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isMyProfile = state.isMyProfile;
                            member = state.member;
                          });
                        });
                      return SingleChildScrollView(
                        child: Column(
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
                                    Visibility(
                                      visible: state.isMyProfile,
                                        child: Expanded(
                                      child: ElevatedButton(onPressed: () {
                                        setState(() {
                                          bloc.add(ExitProfile());
                                        });
                                      },
                                        child: Text("Выйти"),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll<
                                                Color>(Color(color))),
                                      ),
                                    ),
                                    )
                                  ]
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                  children: [
                                    Visibility(
                                      visible: !state.isMyProfile && isAdmin,
                                      child: Expanded(
                                        child: ElevatedButton(onPressed: () {
                                          setState(() {
                                            bloc.add(BanPerson(nickname));
                                          });
                                        },
                                          child: Text("Заблокировать"),
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll<
                                                  Color>(Color(color))),
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ),
                          ],
                        ),
                      );
                      } else if (state is PersonsLoading) {
                          return Center(child: CircularProgressIndicator(),);
                      } else if (state is PersonBanned) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamedAndRemoveUntil(context, "/members", arguments: event,
                            (Route<dynamic> route) => route.settings.name != '/members' && route.settings.name != '/profile');
                         });
                          return Center(child: CircularProgressIndicator(),);
                      } else if (state is PersonNotFoundErrorForPerson)  {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          Navigator.pushNamedAndRemoveUntil(context, "/members", arguments: event,
                                  (Route<dynamic> route) => route.settings.name != '/members' && route.settings.name != '/profile');
                          DialogUtil.showErrorDialog(context, state.errorMessage);
                          //Navigator.pop(context);
                        });
                        return Container();
                      } else if (state is PersonsError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await DialogUtil.showErrorDialog(context, "Не удалось подключиться к серверу");
                          Restart.restartApp();
                        });
                        return Container();
                      } else if (state is ExitSuccess) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                         });
                         return const Center(child: CircularProgressIndicator(),);
                      } else {
                        return Container();
                      }
                    }
                  ),
          ),
        ),
      )
    );

  }

  List<Widget> getParams(Member member) {
    return [
      Center(
        child: SizedBox(height: 140, width: 140,
          child: CircleAvatar(
            backgroundImage: AssetImage(member.getAvatar()),
            radius: 200,
          ),
        ),
      ),
      const SizedBox(height: 16,),
      Center(child: member.sex == Sex.NONE ? SizedBox() : (member.sex.title == "Мужской" ? Icon(CustomIcons.male, color: Colors.blue,) : Icon(CustomIcons.female, color: Colors.red,))),
      const SizedBox(height: 16,),
      Center(child: Text(member.name, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Никнейм", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.nickname, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      const Center(child: Text("Город", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.city, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      member.age == null ? SizedBox() : const Center(child: Text("Возраст", style: TextStyle(color: Colors.black, fontSize: 26)),),
      member.age == null ? SizedBox() : Center(child: Text(member.age.toString(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];
  }

  static Future<bool> _isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') == 'ROLE_ADMIN';
  }

}


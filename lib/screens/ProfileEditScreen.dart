import 'package:flutter/material.dart';


import '../model/event.dart';
import '../model/member.dart';
import '../widgets/LoginWidget.dart';
import '../widgets/NameWidget.dart';
import '../widgets/PasswordWidget.dart';
import '../widgets/SecretWordWidget.dart';
import '../widgets/SexWidget.dart';
import '../widgets/ageWidget.dart';

class ProfileEditScreen extends StatefulWidget {

  ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {

  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();


  @override
  void dispose() {
    loginController.dispose();
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final member = (ModalRoute.of(context)?.settings.arguments) as Member;

    loginController.text = member.login;
    nameController.text = member.name;
    ageController.text = member.age == 0 ? "" : member.age.toString();

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Редактирование профиля", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.settings))
        ],
      ),
      backgroundColor: Color(0xff292929),
      body: Center(
      child: Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
            children: [
              Center(
                child: SizedBox(height: 140, width: 140,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(member.pathToAvatar),
                    radius: 200,
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              //SexWidget(sex: member.sex,),
              const SizedBox(height: 16,),
              NameWidget(controller: nameController,),
              const SizedBox(height: 16,),
              LoginWidget(controller: loginController,),
              const SizedBox(height: 16,),
              AgeWidget(controller: ageController),
              Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                        final form = formKey.currentState!;
                        if (form.validate()) {
                          Navigator.pop(context);
                        }
                      },
                        child: Text("Сохранить"),
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                      ),
                    ),]
              ),

              const SizedBox(height: 16,),
            ]),
      ),
    ),
    )
    );
  }
}
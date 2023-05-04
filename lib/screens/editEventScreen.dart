import 'package:boardgm/widgets/DateTimeWidget.dart';
import 'package:flutter/material.dart';

import '../widgets/CountPlayersWidget.dart';
import '../widgets/DescriptionWidget.dart';
import '../widgets/LoginWidget.dart';
import '../widgets/NameWidget.dart';
import '../widgets/PasswordWidget.dart';
import '../widgets/SecretWordWidget.dart';
import '../widgets/ageWidget.dart';

class EditEventScreen extends StatefulWidget {

  EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final gameController = TextEditingController();
  final countPlayersController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final ageFromController = TextEditingController();
  final ageToController = TextEditingController();

  List<Widget> fields = [];

  @override
  void dispose() {
    nameController.dispose();
    gameController.dispose();
    countPlayersController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    ageFromController.dispose();
    ageToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Создание мероприятия", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                children: [
                  NameWidget(controller: nameController, withHelper: true, text: "Название мероприятия"),
                  const SizedBox(height: 16,),
                  NameWidget(controller: gameController, withHelper: true, text: "Название игры"),
                  const SizedBox(height: 16,),
                  CountPlayersWidget(controller: countPlayersController, withHelper: true,),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(child: DateTimeWidget(controller: dateController, withHelper: true,),),
                    ],
                  ),
                  const SizedBox(height: 16,),
                  DescriptionWidget(controller: descriptionController,),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      Expanded(child: AgeWidget(controller: ageFromController, text: "Возраст от")),
                      SizedBox(width: 16,),
                      Expanded(child: AgeWidget(controller: ageToController, text: "Возраст до")),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Row(
                      children: [
                        Expanded(
                          child: ElevatedButton( onPressed: () {
                            final form = formKey.currentState!;
                            if (form.validate()) {
                              //Navigator.pushNamed(context, '/registration+');
                              Navigator.pushReplacementNamed(context, '/registration+');
                            }
                          },
                            child: Text("Продолжить"),
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
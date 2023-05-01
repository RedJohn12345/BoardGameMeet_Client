
import 'package:flutter/material.dart';

import '../model/Sex.dart';
import '../model/event.dart';
import '../model/member.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final member = (ModalRoute.of(context)?.settings.arguments) as Member;


    final List<Widget> params = [
      Center(
        child: SizedBox(height: 140, width: 140,
          child: CircleAvatar(
            backgroundImage: AssetImage(member.pathToAvatar),
            radius: 200,
          ),
        ),
      ),
      const SizedBox(height: 16,),
      Center(child: Text(member.sex == Sex.NONE ? "" : member.sex.title, style: TextStyle(color: Colors.black, fontSize: 26)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Имя", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.name, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Логин", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.login, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      const Center(child: Text("Город", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(member.city, style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      member.age == 0 ? SizedBox() : const Center(child: Text("Возраст", style: TextStyle(color: Colors.black, fontSize: 26)),),
      member.age == 0 ? SizedBox() : Center(child: Text(member.age.toString(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Профиль", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.settings))
        ],
      ),
      backgroundColor: Color(0xff292929),
      body:
      Column(
        children:[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: params,
            )
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton( onPressed: () {
                    },
                      child: Text("Выйти"),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                    ),
                  ),]
            ),
          ),
      ],),
    );
  }
}
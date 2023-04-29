
import 'package:flutter/material.dart';
import 'package:untitled/model/item.dart';

import '../model/event.dart';

class EventScreenShow extends StatefulWidget {

  EventScreenShow({super.key});

  @override
  State<EventScreenShow> createState() => _EventScreenShowState();
}

class _EventScreenShowState extends State<EventScreenShow> {
  @override
  Widget build(BuildContext context) {

    final event = (ModalRoute.of(context)?.settings.arguments) as Event;


    final List<Widget> params = [
      const Center(child: Text("Игра", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.game, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Дата", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.date.toString(), style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Место", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.location, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.viewCountPlayers(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
    ];

    return Scaffold(
      appBar: AppBar(
        title:
            Text(event.name, style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body:
      Column(
        children:[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView.builder(
                  itemCount: params.length,
                  itemBuilder: (_, index) =>
                  params[index],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton( onPressed: () {
                      Navigator.pushReplacementNamed(context, '/event', arguments: event);
                    },
                      child: Text("Вступить"),
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                    ),
                  ),]
            ),
          ),
      ],),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled/model/item.dart';

import '../model/event.dart';

class EventScreen extends StatefulWidget {

  EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {

    final event = (ModalRoute.of(context)?.settings.arguments) as Event;


    Map<Item, bool> it = {};
    for (Item s in event.items) {
      it[s] = true;
    }

    final List<Widget> items = [];

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
      const Center(child: Text("Описание", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Align(alignment: Alignment.topLeft, child: Text(event.description, style: TextStyle(color: Colors.black, fontSize: 24)),),
      const SizedBox(height: 16,),
      const Center(child: Text("Количество игроков", style: TextStyle(color: Colors.black, fontSize: 26)),),
      Center(child: Text(event.viewCountPlayers(), style: TextStyle(color: Colors.black, fontSize: 24),),),
      const SizedBox(height: 16,),
      Center(child: Text("Нужные предметы", style: TextStyle(color: Colors.black, fontSize: 26)),),
      const SizedBox(height: 10,),
    ];

    for (Item item in event.items) {
      items.add(CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(item.name),
          value: it[item],
          onChanged: (bool? value) {
            setState(() {
              it[item] = value!;
            });
          },
        ),
      );
      items.add(const SizedBox(height: 5,),);
    }

    params.add(Container(decoration: BoxDecoration(
        color: Color(0xff50bc55),
        borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),child: Column(children: items,)));

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
                      Navigator.pushReplacementNamed(context, '/');
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
import 'package:flutter/material.dart';

import '../model/event.dart';

class MyEventsScreen extends StatelessWidget {

  final int numberPage = 1;
  final List<Event> events = [
    Event(name: "Event 1",
        game: "Monopoly",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 2",
        game: "Monopoly1",
        location: "Voronezh3123",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 3",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 4",
        game: "Monopoly3",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 5",
        game: "Monopoly5",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 6",
        game: "Monopoly4",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 7",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 8",
        game: "Monopoly434",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 1",
        game: "Monopoly",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 2",
        game: "Monopoly1",
        location: "Voronezh3123",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 3",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 4",
        game: "Monopoly3",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 5",
        game: "Monopoly5",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 6",
        game: "Monopoly4",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
    Event(name: "Event 7",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now()),
  ];


  MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
            Text("Мои мероприятия", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body:
        Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView.builder(
              //shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (_, index) =>
                  Card(
                    color: Colors.white,
                    child: ListTile(
                        title: Text(events[index].name),
                        subtitle: Text(
                            "${events[index].game} - ${events[index].date
                                .toString()} - ${events[index].location}"),
                        trailing: Icon(Icons.account_box),
                    ),
                  )
          ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {},
        backgroundColor: Color(0xff50bc55),
        child: Icon(Icons.add, color: Colors.white, size: 30.0,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: numberPage,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Главная"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Мои мероприятия"),
        ],
        backgroundColor: Color(0xff50bc55),
      ),
    );
  }
}
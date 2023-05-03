import 'package:flutter/material.dart';

import '../model/event.dart';
import '../model/item.dart';

class MainScreen extends StatelessWidget {

  final int numberPage = 0;
  final List<Event> events = [
    Event(name: "Event 1",
        game: "Monopoly",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "dsgkbjagjbigasjbkadgjhdjhkdsjhdfsjhldsgahjgjhk",
        items: {Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,
          Item(name: "Pidge"):false, Item(name: 'Padge'):false,},
        maxNumberPlayers: 6
        ),
    Event(name: "Event 2",
        game: "Monopoly1",
        location: "Voronezh3123",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 3",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 4",
        game: "Monopoly3",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 5",
        game: "Monopoly5",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 6",
        game: "Monopoly4",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 7",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 8",
        game: "Monopoly434",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 1",
        game: "Monopoly",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 2",
        game: "Monopoly1",
        location: "Voronezh3123",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 3",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 4",
        game: "Monopoly3",
        location: "Voronezh213",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 5",
        game: "Monopoly5",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 6",
        game: "Monopoly4",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
    Event(name: "Event 7",
        game: "Monopoly2",
        location: "Voronezh",
        numberPlayers: 4,
        date: DateTime.now(),
        description: "",
        items: {},
        maxNumberPlayers: 6),
  ];


  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
            Text("Список мероприятий", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body:
      Column(
        children:[
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(onPressed: () {
                Navigator.pushNamed(context, '/authorization');
              },
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/2.jpg"),
                  radius: 200,
                ),
                heroTag: 'avatar',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Row(
              children: [
                Expanded(
                  child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Введите название игры или мероприятия",
                    fillColor:  Color(0xff171717),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white60)
                  ),
                    style: TextStyle(color: Colors.white),
              ),
                ),
                //IconButton(onPressed: (){}, icon: Icon(Icons.search))
            ]),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (_, index) =>
                    Card(
                      color: Colors.white,
                      child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/eventShow', arguments: events[index]);
                          },
                          title: Text(events[index].name),
                          subtitle: Text(
                              "${events[index].game} - ${events[index].date
                                  .toString()} - ${events[index].location}")
                      ),
                    )
            ),
        ),
          ),
      ],),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/map');
      },
        backgroundColor: Color(0xff50bc55),
        child: Icon(Icons.add, color: Colors.white, size: 30.0,),
        heroTag: 'create_event',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: numberPage,
        selectedItemColor: Colors.deepPurpleAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamedAndRemoveUntil(context, '/my_events', (route) => false);
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30.0,),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt, size: 30.0,),
              label: ""),
        ],
        backgroundColor: Color(0xff50bc55),
      ),
    );
  }
}
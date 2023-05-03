import 'package:flutter/material.dart';

import '../model/Sex.dart';
import '../model/member.dart';

class MembersScreen extends StatelessWidget {

  final int numberPage = 1;
  final List<Member> members = [
    Member(name: "Denis", pathToAvatar: "assets/images/2.jpg", login: "pangolin", city: "Voronezh", sex: Sex.MAN),
    Member(name: "Ivan", pathToAvatar: "assets/images/2.jpg", login: "mneploxa", city: "Voronezh"),
    Member(name: "Denis", pathToAvatar: "assets/images/2.jpg", login: "dunadan", city: "Voronezh", age: 21),
    Member(name: "Vadim", pathToAvatar: "assets/images/2.jpg", login: "bezdeneg", city: "Voronezh"),
  ];


  MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
            Text("Список участников", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body:
        Column(
          children: [
            const SizedBox(height: 40,),
            Flexible(
              child: Container(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: members.length,
                    itemBuilder: (_, index) =>
                        Card(
                          color: Colors.white,
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile', arguments: members[index]);
                            },
                              title: Text(members[index].name),
                              leading: SizedBox(height: 40, width: 40,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(members[index].pathToAvatar),
                                  radius: 200,
                                ),
                              ),
                              trailing: IconButton(icon: Icon(Icons.disabled_by_default_outlined), color: Colors.red,
                                onPressed: () {},),
                          ),
                        )
                ),
      ),
            ),
          ],
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:untitled/model/member.dart';

class MembersScreen extends StatelessWidget {

  final int numberPage = 1;
  final List<Member> members = [
    Member(name: "Denis", pathToAvatar: "images/2.jpg"),
    Member(name: "Ivan", pathToAvatar: "images/2.jpg"),
    Member(name: "Denis", pathToAvatar: "images/2.jpg"),
    Member(name: "Vadim", pathToAvatar: "images/2.jpg"),
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
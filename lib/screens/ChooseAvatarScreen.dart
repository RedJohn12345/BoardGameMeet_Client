import 'package:flutter/material.dart';

import '../model/event.dart';

class ChooseAvatar extends StatefulWidget {


  ChooseAvatar({super.key});

  @override
  State<ChooseAvatar> createState() => _ChooseAvatarState();
}

class _ChooseAvatarState extends State<ChooseAvatar> {

  final List<AssetImage> images = [
    AssetImage('assets/images/1.jpg'),
    AssetImage('assets/images/2.jpg'),
    AssetImage('assets/images/3.jpg'),
  ];

  String path = "assets/images/1.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Выбор Аватара", style: TextStyle(fontSize: 24),),
        //
        centerTitle: true,
        backgroundColor: Color(0xff50bc55),
      ),
      backgroundColor: Color(0xff292929),
      body:
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              const SizedBox(height: 16,),
              SizedBox(height: 140, width: 140,
                child: CircleAvatar(
                  backgroundImage: AssetImage(path),
                  radius: 200,
                ),
              ),
              const SizedBox(height: 16,),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            path = images[index].assetName;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Image(
                            image: images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                  children: [
                    Expanded(
                      child: ElevatedButton( onPressed: () {
                          Navigator.pop(context);
                      },
                        child: Text("Сохранить"),
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xff50bc55))),
                      ),
                    ),]
              ),

              const SizedBox(height: 16,),
            ],
          ),
        ),


    );
  }
}
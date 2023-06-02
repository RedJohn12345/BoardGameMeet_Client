import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/dto/member_dto.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser, required this.interlocutor,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final Interlocutor interlocutor;

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          // asymmetric padding
          padding: EdgeInsets.fromLTRB(
            isCurrentUser ? 64.0 : 16.0,
            20,
            isCurrentUser ? 16.0 : 64.0,
            20,
          ),
          child: Column(
            children: [
              isCurrentUser ? Container() :
              Row(
                children: [
                  isCurrentUser ? Container() :
                  CircleAvatar(
                    backgroundImage: AssetImage(interlocutor.getAvatar()),
                    radius: 20,
                  ),
                  isCurrentUser ? Container() : SizedBox(width: 16,),
                  Text(
                    interlocutor.name,
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  ),
                ],
              ),
              isCurrentUser ? Container() :
              SizedBox(height: 10,),
              Align(
                // align the child within the container
                alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: DecoratedBox(
                  // chat bubble decoration
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child:
                        Text(
                          text,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
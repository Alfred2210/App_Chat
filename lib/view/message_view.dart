import 'package:flutter/material.dart';
import '../model/message.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final String userId;

  const MessageItem({
    Key? key,
    required this.message,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = userId == message.idFrom;
    final messageAlignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final messageColor = isCurrentUser ? Colors.black : Colors.white;
    final backgroundColor = isCurrentUser ? Colors.grey : Colors.blueGrey;

    return Column(
      crossAxisAlignment: messageAlignment,
      children: [
        Row(
          mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            messageContainer(messageColor, backgroundColor),
          ],
        ),
      ],
    );
  }


  Widget messageContainer(Color textColor, Color backgroundColor) {
    return Container(
      child: Text(
        message.content,
        style: TextStyle(
          color: textColor,
        ),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
    );
  }
}

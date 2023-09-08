import 'package:flutter/material.dart';
import 'package:firstbd233/controller/firebase_helper.dart'; // Import your FirebaseHelper class
import 'package:firstbd233/model/message.dart';

import 'message_view.dart'; // Import your Message model

class MyChatPage extends StatefulWidget {
  final String userId;
  final String chatGroupId;

  MyChatPage({required this.userId, required this.chatGroupId});

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  TextEditingController messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    // Load previous chat messages when the chat page is initialized
    _loadChatMessages();
  }

  void _loadChatMessages() async {
    int LIMIT = 20; // Change this as needed

    List<Message> chatMessages = await FirebaseHelper()
        .getMessage(widget.chatGroupId, LIMIT)
        .first;
    try {
      print("Chat messages loaded : ${chatMessages.length} messages"
          " from ${widget.chatGroupId} to ${widget.userId}");
    } catch (e) {
      print("Error loading chat messages : $e");
    }

    setState(() {
      messages.addAll(chatMessages.reversed);
    });
  }

  Widget _buildMessageInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String text = messageController.text.trim();
    if (text.isNotEmpty) {
      Message newMessage = Message(
        idFrom: widget.userId,
        idTo: widget.chatGroupId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text,
        type: 0, // This is a text message, you can change it as needed
      );

      // Send the message to Firebase using your FirebaseHelper's method
      FirebaseHelper().onSendMessage(widget.chatGroupId, newMessage);

      print("Message sent : " + newMessage.content);
      print("${newMessage.idFrom} sent a message to ${newMessage.idTo}");
      print("idFrom : ${widget.userId}");
      print("idTo : ${widget.chatGroupId}");
      setState(() {
        messages.add(newMessage);
      });



      messageController.clear();
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Message message = messages[index];
                return MessageItem(
                  message: message,
                  userId: widget.userId,

                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

}


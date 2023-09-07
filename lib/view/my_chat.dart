import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firstbd233/model/message.dart';

import '../controller/firebase_helper.dart'; // Importez votre classe Message

class MyChat extends StatefulWidget {
  final String idTo;
  const MyChat({Key? key, required this.idTo}) : super(key: key);


  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final FirebaseHelper firebaseHelper = FirebaseHelper();
  final TextEditingController _textController = TextEditingController();

  // Function to send a message
  void sendMessageInChat() async {
    String messageText = _textController.text.trim();
    print("messageText: $messageText");

    if (messageText.isNotEmpty) {
      // Create a new Message object
      Message message = Message();
      message.idFrom = FirebaseAuth.instance.currentUser!.uid; // Set the sender ID
      message.idTo = widget.idTo;
      message.message = messageText; // Set the message content
      message.date = DateTime.now(); // Set the date
      message.isRead = false; // Set isRead to false

      print("Sending message: ${message.toMap()}");

      // Send the message to Firebase
      await firebaseHelper.sendMessage(message.idFrom, message.idTo, message.message);

      // Clear the text field
      _textController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${widget.idTo}")
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: firebaseHelper.getChatMessages(
                  FirebaseAuth.instance.currentUser!.uid, widget.idTo),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No messages yet."),
                  );
                } else {
                  List<Message> messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      return ListTile(
                        title: Text(message.message),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration.collapsed(hintText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessageInChat, // Call the sendMessage function
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

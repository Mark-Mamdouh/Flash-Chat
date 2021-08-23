import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  // messageTextController will be used to clear the message
  // textfield after sending a message
  final messageTextController = TextEditingController();

  String messageText = "";

  void getCurrentUser() async {
    try {
      // get current logged user
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection("messages").getDocuments();
  //   for (var message in messages.documents) {
  //     print(message.data);
  //   }
  // }

  // this method is called once and it is automatically listens to new messages
  // unlike getMessages() method which after any new message you need to call it
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection("messages").snapshots()) {
  //     for (var message in snapshot.documents) {
  //       print(message.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          // sign out button
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // streambuilder turns our stream of snapshots into a widget
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      // set controller
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // we first create a database in our firestore
                      // and add a collection name messages
                      // with 2 fields: text & sender
                      _firestore.collection("messages").add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      // clear textfield
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").snapshots(),
      // builder keeps looking for new data and updates the streambuilder widget
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            backgroundColor: Colors.red,
          );
        } else {
          // .reversed so that we add the new message to the bottom
          final messages = snapshot.data.documents.reversed;
          List<MessageBubble> messageBubbles = [];
          // loop through returned data stream
          for (var message in messages) {
            final messageText = message.data["text"];
            final messageSender = message.data["sender"];
            final currentUser = loggedInUser.email;
            final messageBubble = MessageBubble(
                messageText, messageSender, currentUser == messageSender);
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse:
                  true, // so that we always see the bottom of the listview so that if a new message arrives we can see it
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}

// don't forget to change the rules in your firestore to

// rules_version = '2';
// service cloud.firestore {
// match /databases/{database}/documents {
// match /{document=**} {
// allow read, write: if
// request.auth.uid != null;
// }
// }
// }

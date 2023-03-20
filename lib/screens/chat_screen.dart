import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}



const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedinUser;
  late String messageText;
  TextEditingController messageFieldController = TextEditingController();

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedinUser = user;
        print(loggedinUser.email);
      }
    }catch(e){
      print(e);
    }
  }
/* geting message by docs
  void getMessages() async{
    final messages = await _firestore.collection('messages').get();
    for(var message in messages.docs){
      print(message.data());
    }
  }
*/

 void messagesStream() async{
  await for(var snapshot in _firestore.collection('messages').snapshots()){
    for(var message in snapshot.docs){
      print(message.data());
    }
  }
 }
 
 
 
  @override
  void initState() {
    Firebase.initializeApp();
    getCurrentUser();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(stream: _firestore.collection('messages').snapshots(),builder:(context, snapshot){
              if(snapshot.hasData){
                final messages = snapshot.data?.docs.reversed;
                List<messageBubble> messageWidgets = [];
                for (var message in messages!){
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  print('messagesender: $messageSender');
                  print('user: ${loggedinUser.email}');
                  if(messageSender == loggedinUser.email){
                    final messageWidget = messageBubble(messageText: messageText, messageSender: messageSender,isMe: true);
                    print(messageText);
                    messageWidgets.add(messageWidget);
                  } else{
                    final messageWidget = messageBubble(messageText: messageText, messageSender: messageSender, isMe: false,);
                    print(loggedinUser);
                    messageWidgets.add(messageWidget);
                  }
                
                }
                return Expanded(child: ListView(children: messageWidgets, padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),reverse: true,));
              }
              return Center(child: CircularProgressIndicator(),);
            },),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageFieldController,
                      onChanged: (value) {

                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({'text': messageText, 'sender': loggedinUser.email});
                      messageFieldController.clear();
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

class messageBubble extends StatelessWidget {
  final String messageText;
  final String messageSender;
  final bool isMe;
  const messageBubble({Key? key, required this.messageText, required this.messageSender, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text('$messageSender', style: TextStyle(fontSize: 11, color: Colors.grey)),
          Material(
            borderRadius: isMe? BorderRadius.only(topLeft:Radius.circular(30),bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)):
            BorderRadius.only(topRight:Radius.circular(30),bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Text(
                '$messageText',style: TextStyle(fontSize: 16, color: isMe ? Colors.white: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

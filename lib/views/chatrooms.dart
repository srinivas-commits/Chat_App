import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/authenticate.dart';
import 'package:spam_chat/helper/constants.dart';
import 'package:spam_chat/helper/helperFunctions.dart';
import 'package:spam_chat/services/auth.dart';
import 'package:spam_chat/services/database.dart';
import 'package:spam_chat/views/conversation.dart';
import 'package:spam_chat/views/search.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.documents[index]
                        .data()["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data()["chatRoomId"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Window"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app_sharp),
              onPressed: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              })
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomTile({Key key, this.userName, this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text("${userName.substring(0, 1).toUpperCase()}",
                  style: TextStyle(color: Colors.black, fontSize: 17.0)),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.black, fontSize: 17.0),
            ),
          ],
        ),
      ),
    );
  }
}

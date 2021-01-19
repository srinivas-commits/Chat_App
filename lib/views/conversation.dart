import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/constants.dart';
import 'package:spam_chat/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen({Key key, this.chatRoomId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  // ignore: non_constant_identifier_names
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: MediaQuery.of(context).size.height - 80,
                  padding: EdgeInsets.only(bottom: 70),
                  child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          message:
                              snapshot.data.documents[index].data()["message"],
                          isSendByMe:
                              snapshot.data.documents[index].data()["sendBy"] ==
                                  Constants.myName,
                        );
                      }),
                )
              : Container();
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black26,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.white60,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40.0)),
                        padding: EdgeInsets.all(12.0),
                        alignment: Alignment.center,
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key key, this.message, this.isSendByMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24.0, right: isSendByMe ? 24.0 : 0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC),
                  ]
                : [
                    const Color(0xff007000),
                    const Color(0xff007000),
                  ],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0))
              : BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black, fontSize: 17.0),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/constants.dart';
import 'package:spam_chat/services/database.dart';
import 'package:spam_chat/views/conversation.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEdittingController =
      new TextEditingController();

  QuerySnapshot searchSnapShot;

  void iniateState() {
    databaseMethods
        .getUserByUsername(searchTextEdittingController.text)
        .then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  createChatRoomAndChats({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ConversationScreen(chatRoomId: chatRoomId)));
    } else {
      print("");
    }
  }

  // ignore: non_constant_identifier_names
  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
              Text(userEmail),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndChats(userName: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Text("Chat"),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(13.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapShot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot.docs.length,
            itemBuilder: (context, int index) {
              return SearchTile(
                userName: searchSnapShot.docs[index].data()["name"],
                userEmail: searchSnapShot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    iniateState();
    //getUserInfo();
    super.initState();
  }

  // getUserInfo() async{
  //   _myName = await HelperFunctions.getUserNameSharedPreference();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for the contacts"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black26,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEdittingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search username",
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      iniateState();
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
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String x, String y) {
  if (x.substring(0, 1).codeUnitAt(0) > y.substring(0, 1).codeUnitAt(0)) {
    return "$y\_$x";
  } else {
    return "$x\_$y";
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUseremail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance
        .collection("users")
        .add(userMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((err) {
      print(err.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}

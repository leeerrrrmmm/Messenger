import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message/models/message_model.dart';

class ChatService extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// GET USER STREAM
  Stream<List<Map<String, dynamic>>> getAllUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

  //GET ALL USERS STREAM EXCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>>  getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore.collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockUsers')
        .snapshots()
        .asyncMap((snapshot) async {

          //get block users id

          final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

          //get all users
          final userSnapshot = await _firestore.collection('Users').get();

          return userSnapshot.docs
              .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUsersIds.contains(doc.id))
              .map((doc) => doc.data())
              .toList();
    });
  }


// SEND MESSAGE
  Future<void> sendMessage(String receiverID, message) async {
  //get cur info
  final String  currentId = _auth.currentUser!.uid;
  final String  currentEmail = _auth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentId,
        senderEmail: currentEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp
    );



    //construct chat room ID for the two users
  List<String> ids = [currentId, receiverID];
  ids.sort();
  String chatRoomId = ids.join('_');
  
    //add new message to database
    await _firestore.collection('Chat_rooms')
        .doc(chatRoomId).collection('Messages')
        .add(newMessage.toMap());

  }

  // GET MESSAGE
    Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
      List<String> ids = [userId, otherUserId];
      ids.sort();
      String chatRoomId = ids.join('_');

      return _firestore.collection('Chat_rooms')
          .doc(chatRoomId).collection('Messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    }

    //REPORT USER
    Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
      final report = {
        'reportedBy': currentUser!.uid,
        'messageId': messageId,
        'messageOwnerId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      };
      
      await _firestore.collection('Reports').add(report);
    }


    //BLOC USER
    Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockUsers')
        .doc(userId)
        .set({});
        notifyListeners();
    }


    //UNBLOCK USER
    Future<void> unblockUser (String blockedUserId) async {
      final currentUser = _auth.currentUser;
      await _firestore.collection('Users')
          .doc(currentUser!.uid)
          .collection('BlockUsers')
          .doc(blockedUserId).delete();

      notifyListeners();
    }


    //GET BLOCKED USER STREAM
  Stream<List<Map<String, dynamic>>> getBlockUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get blockUserStream ids
      final blockedUserIds = snapshot.docs
          .map((doc) => doc.id).toList();

      final userDoc = await Future.wait(
        blockedUserIds.map((id) => _firestore.collection('Users').doc(id).get()),
      );

      return userDoc
          .where((doc) => doc.data() != null)
          .map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }


}
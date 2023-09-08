import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstbd233/model/my_user.dart';

import '../model/message.dart';

class FirebaseHelper {
  final auth = FirebaseAuth.instance;
  final cloud_users = FirebaseFirestore.instance.collection("UTILISATEURS");
  final cloud_messages = FirebaseFirestore.instance.collection("message");
  final storage = FirebaseStorage.instance;


  //inscrire un utiisateur
  Future <MyUser>inscription(String nom , String prenom , String email , String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    Map<String,dynamic> data = {
      "NOM":nom,
      "PRENOM":prenom,
      "EMAIL": email,
    };
    addUser(uid, data);
    return getUser(uid);
  }


  Future <MyUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloud_users.doc(uid).get();
    return MyUser.bdd(snapshot);
  }

  //ajouter un utilisateur dans la base de donnée
  addUser(String uid,Map<String,dynamic>data ){
    cloud_users.doc(uid).set(data);
  }


  //me connecter
  Future<MyUser>connexion(String email , String password) async {
    UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    String uid = credential.user!.uid;
    return getUser(uid);


  }


  //mise à jour d'un utilisateur
  updateUser(String uid , Map<String,dynamic> map){
    cloud_users.doc(uid).update(map);
  }


  //stocker un fichier
  Future <String> stockage(String dossier,String uidUser , String nameFile, Uint8List datasFile) async{
    TaskSnapshot snapshot = await storage.ref("/$dossier/$uidUser/$nameFile").putData(datasFile);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }


  List<Message> _messageListFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _messageFromSnapshot(doc);
    }).toList();
  }

  Message _messageFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("message not found");
    return Message.fromMap(data);
  }

  Stream<List<Message>> getMessage(String groupChatId, int limit) {
    return FirebaseFirestore.instance

        .collection('message')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      // Convert the snapshot to a list of messages
      List<Message> messages = snapshot.docs.map((doc) {
        return _messageFromSnapshot(doc);
      }).toList();
      print("groupe : $groupChatId");
      // Sort the messages by timestamp (newest first)
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return messages;
    });
  }


  void onSendMessage(String groupChatId, Message message) {
    var documentReference = FirebaseFirestore.instance
        .collection('message')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference,message.toHashMap());
    });
  }



}
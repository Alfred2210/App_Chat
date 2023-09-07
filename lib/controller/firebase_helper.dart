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




  sendMessage(String idFrom, String idTo, String messageText) async {
    try {
      // Créez une référence à la collection "messages" dans Firestore.
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection("message");

      // Créez un nouveau document dans la collection "messages".
      final DocumentReference newMessageRef = messagesCollection.doc();

      // Obtenez l'ID unique du nouveau document créé.
      final String messageId = newMessageRef.id;

      // Créez un objet Message avec les données du message.
      final Map<String, dynamic> messageData = {
        "IDFROM": idFrom,
        "IDTO": idTo,
        "MESSAGE": messageText,
        "DATE": DateTime.now(),
        "ISREAD": false,
      };

      // Ajoutez le message au document Firestore.
      await newMessageRef.set(messageData);

      return messageId;
    } catch (error) {
      print("Erreur lors de l'envoi du message : $error");
      // Gérez les erreurs ici.
      throw error;
    }
  }

  Future<List<Message>> getChatMessages(String idFrom, String idTo) async {
    try {
      // Créez une référence à la collection "messages" dans Firestore.
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection("message");

      // Effectuez une requête pour récupérer les messages entre les utilisateurs spécifiés.
      QuerySnapshot querySnapshot = await messagesCollection
          .where("IDFROM", isEqualTo: idFrom)
          .where("IDTO", isEqualTo: idTo)
          .orderBy("DATE", descending: false) // Vous pouvez trier par date si nécessaire.
          .get();

      List<Message> messages = [];

      // Parcourez les documents de la requête pour créer des objets Message.
      querySnapshot.docs.forEach((doc) {
        messages.add(Message.bdd(doc));
      });

      return messages;
    } catch (error) {
      print("Erreur lors de la récupération des messages de chat : $error");
      // Gérez les erreurs ici.
      throw error;
    }
  }

}
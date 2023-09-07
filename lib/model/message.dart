import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String idFrom;
  late String idTo;
  late String message;
  late DateTime date;
  late bool isRead;


  Message(){
    idFrom = "";
    idTo = "";
    message = "";
    date = DateTime.now();
    isRead = false;
  }

  Message.bdd(DocumentSnapshot snapshot){
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    idFrom = map["IDFROM"];
    idTo = map["IDTO"];
    message = map["MESSAGE"];
    Timestamp? timestamp = map["DATE"];
    if(timestamp == null){
      date = DateTime.now();
    }
    else
    {
      date = timestamp.toDate();
    }
    isRead = map["ISREAD"];
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "IDFROM": idFrom,
      "IDTO": idTo,
      "MESSAGE": message,
      "DATE": date,
      "ISREAD": isRead
    };
    return map;
  }

}

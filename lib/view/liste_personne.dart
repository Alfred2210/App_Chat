import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:firstbd233/view/info_personne.dart';
import 'package:flutter/material.dart';

import 'my_chat.dart';

class ListPersonne extends StatefulWidget {
  const ListPersonne({super.key});

  @override
  State<ListPersonne> createState() => _ListPersonneState();
}

class _ListPersonneState extends State<ListPersonne> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseHelper().cloud_users.snapshots(),
        builder: (context,snap){
          if(snap.data == null){
            return Center(child: Text("Aucun utilisateur"),);
          }else {
            List documents = snap.data!.docs;

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context,index){
                  MyUser users = MyUser.bdd(documents[index]);
                  if(users.uid == moi.uid){
                    return Container();
                  }
                  else
                  {
                    return Card(
                        elevation: 5,
                        color: Colors.purple,
                        child: ListTile(
                        onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyInfoPersonne(personne: users)));
                    },

                  leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(users.avatar!),
                  ),
                  title: Text(users.fullName),
                  subtitle: Text(users.email),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                  onPressed: () {
                  setState(() {
                  if (moi.favoris!.contains(users.uid)) {
                  moi.favoris!.remove(users.uid);
                  } else {
                  moi.favoris!.add(users.uid);
                  }
                  Map<String, dynamic> map = {"FAVORIS": moi.favoris};
                  FirebaseHelper().updateUser(moi.uid, map);
                  });
                  },
                  icon: const Icon(Icons.favorite),
                  color: moi.favoris!.contains(users.uid) ? Colors.red : Colors.grey,
                  ),
                  IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyChatPage(
                          userId: moi.uid,
                          chatGroupId: moi.uid + users.uid,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  color: Colors.red,
                  ),
                  ],
                  ),
                  ),

                  );
                }
                }
            );
          }
        }
    );
  }
}

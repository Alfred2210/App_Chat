import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:flutter/material.dart';

class ListFavoris extends StatefulWidget {
  const ListFavoris({super.key});

  @override
  State<ListFavoris> createState() => _ListFavorisState();
}

class _ListFavorisState extends State<ListFavoris> {

  List ListMesFavoris = [];

  @override
  void initState() {
    // TODO: implement initState
    for(String element in moi.favoris!){
      FirebaseHelper().getUser(element).then((value){
        setState(() {
          ListMesFavoris.add(value);
        });

      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: ListMesFavoris.length,
        itemBuilder: (context,index){
          MyUser user = ListMesFavoris[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user.avatar!),
              ),
              Text(user.fullName)
            ],
          );
        }
    );
  }
}

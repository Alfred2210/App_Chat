import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/paiement_controller.dart';
import 'package:firstbd233/view/listFavoris.dart';
import 'package:firstbd233/view/liste_personne.dart';
import 'package:firstbd233/view/machine_learnig.dart';
import 'package:firstbd233/view/my_background.dart';
import 'package:firstbd233/view/my_carte.dart';
import 'package:firstbd233/view/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDashBord extends StatefulWidget {
  const MyDashBord({super.key});

  @override
  State<MyDashBord> createState() => _MyDashBordState();
}

class _MyDashBordState extends State<MyDashBord> {
  //variable
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Container(
        color: Colors.purple,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.6,
        child: MyDrawer(),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,

      ),

      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexPage,
        onTap: (index){
          setState(() {
            indexPage = index;
          });

        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Carte"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Personnes"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoris"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.rocket),
              label: "ML"
          ),

        ],
      ),
      body: Stack(
        children: [
          MyBackGroundPage(),
          bodyPage()
        ],
      ),
    );
  }

  Widget bodyPage(){
    switch(indexPage){
      case 0 : return MyCarte();
      case 1 : return ListPersonne();
      case 2 : return ListFavoris();
      case 3 : return MyMachineLearning();
      default : return Text("Erreur");
    }
  }
}

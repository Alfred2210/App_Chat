import 'package:firstbd233/controller/paiement_controller.dart';
import 'package:firstbd233/model/my_user.dart';
import 'package:firstbd233/view/my_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyInfoPersonne extends StatefulWidget {
  MyUser personne;
  MyInfoPersonne({required this.personne,super.key});

  @override
  State<MyInfoPersonne> createState() => _MyInfoPersonneState();
}

class _MyInfoPersonneState extends State<MyInfoPersonne> {
  final PaymentController controller = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,

        backgroundColor: Colors.transparent,
        title: Text(widget.personne.fullName,style: TextStyle(color: Colors.white,fontSize: 25),),
      ),
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          MyBackGroundPage(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: bodyPage(),
          )
        ],
      ),
    );
  }

  Widget bodyPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
           CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(widget.personne.avatar!),
              ),
          SizedBox(height: 10,),
          Text(widget.personne.email),
          /*ElevatedButton(
              onPressed: (){
                controller.makePayment(amount: '24', currency: 'eur');
              },
              child: Text("Paiement")
          ),*/


        ],
      ),
    );
  }
}

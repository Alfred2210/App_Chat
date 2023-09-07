import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firstbd233/constante/constant.dart';
import 'package:firstbd233/controller/firebase_helper.dart';
import 'package:firstbd233/controller/paiement_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    //variable
    String? nameFile;
    Uint8List? bytesFile;



    //fonctions
    pickPhoto(){
      showDialog(
          context: context, 
          builder: (context){
            return CupertinoAlertDialog(
              title: Text("Souhaitez envoyer cette image ?"),
              content: Image.memory(bytesFile!),
              actions: [
                TextButton(
                    onPressed: (){
                  nameFile = null;
                  bytesFile = null;
                  Navigator.pop(context);
                }, 
                    child: Text("Annuler")),
                TextButton(
                    onPressed: (){
                      FirebaseHelper().stockage("IMAGES", moi.uid, nameFile!, bytesFile!).then((value) {
                        setState(() {
                          moi.avatar = value;
                        });
                        Map<String,dynamic> map = {
                          "AVATAR": moi.avatar
                        };
                        FirebaseHelper().updateUser(moi.uid, map);
                        Navigator.pop(context);
                      });
                    }, 
                    child: Text("Uploader")
                )
              ],
            );
          }
      );
      
    }
    pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true
      );
      if(result != null){
        nameFile = result.files.first.name;
        bytesFile = result.files.first.bytes;
        pickPhoto();
      }
    }
    return Padding(
        padding: EdgeInsets.all(10),
      child: Column(
        children: [
          //Image Circulaire
          GestureDetector(
            onTap: (){
              pickFile();
            },
            child: CircleAvatar(
              radius: 150,
              backgroundImage: NetworkImage(moi.avatar!),
            ),
          ),
          Divider(thickness: 5,color: Colors.black,),


          //nom et prénom
          Text("Bonjour ${moi.fullName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),




        ],
      ),
    );
  }
}

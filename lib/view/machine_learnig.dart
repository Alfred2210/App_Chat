import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class MyMachineLearning extends StatefulWidget {
  const MyMachineLearning({super.key});

  @override
  State<MyMachineLearning> createState() => _MyMachineLearningState();
}

class _MyMachineLearningState extends State<MyMachineLearning> {
  //variable
  TextEditingController message = TextEditingController();
  String langageidentifier = "";
  LanguageIdentifier lang = LanguageIdentifier(confidenceThreshold: 0.6);
  ImageLabeler labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.4));
  late InputImage image;
  Uint8List? bytesImage;
  String resultatString = "";

  //méthode
  identificationLangage() async {
    langageidentifier = "";
    if(message != null){
      String mess = await lang.identifyLanguage(message.text);
      setState(() {
        langageidentifier = "la langue identifié est $mess";
      });

    }




  }

  plusieursLangage() async {
    if (message.text == "") return;
    List<IdentifiedLanguage> phraseList = await lang.identifyPossibleLanguages(message.text);
    for(IdentifiedLanguage label in phraseList){
      setState(() {
        langageidentifier += "\n la langue ${label.languageTag} est identifié avec une confiance de ${(label.confidence * 100).toInt()}%";
      });
    }
  }

  pickImage() async{
    resultatString = "";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true
    );
    setState(() {
      if(result != null){
        bytesImage = result.files.first.bytes;
        image = InputImage.fromBytes(bytes: bytesImage!, metadata: InputImageMetadata(size: Size(15, 15), rotation: InputImageRotation.rotation0deg, format: InputImageFormat.yuv_420_888, bytesPerRow: 10));
      }
    });
  }

  processing() async {
    pickImage();
    if(bytesImage == null) return;
    List images = await labeler.processImage(image);
    for(ImageLabel imageUnique in images){
      resultatString += "\n${imageUnique.label} avec une confiance de ${(imageUnique.confidence * 100).toInt()}%";
    }
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 150,),
          TextField(
            controller: message,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "entrer un texte"
            ),
          ),
          ElevatedButton(
              onPressed: identificationLangage,
              child: Text("selection")
          ),

          ElevatedButton(
              onPressed: plusieursLangage,
              child: Text("Plusieurs")
          ),
          ElevatedButton(
              onPressed: processing,
              child: Text("Choisir image")
          ),
          (bytesImage == null)?Container():Image.memory(bytesImage!),
          Text(langageidentifier),
          Text(resultatString)
        ],
      ),
    );
  }
}

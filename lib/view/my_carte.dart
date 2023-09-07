import 'package:firstbd233/controller/permission_gps.dart';
import 'package:firstbd233/view/data_maps.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyCarte extends StatefulWidget {
  const MyCarte({super.key});

  @override
  State<MyCarte> createState() => _MyCarteState();
}

class _MyCarteState extends State<MyCarte> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: PermissionGPS().init(),
        builder: (context,resultat) {
          if (resultat.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          else {
            if (resultat.data == null) {
              return Center(
                child: Text("Vous n'avez pas accès à la carte"),
              );
            }
            else {
              Position coordonne = resultat.data!;
              return MyDataMaps(coordonnee: coordonne,);
            }
          }
        }
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:hive/hive.dart';

class Favorites extends StatefulWidget {
  final DocumentReference reference;
  final Function() action;

  const Favorites({super.key, required this.reference, required this.action});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: currentUserDocument!.reference.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List favorite = snapshot.data!.get("favoriteReference") != null
                ? snapshot.data!.get("favoriteReference")
                : [];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  favorite.contains(widget.reference)
                      ? favorite.remove(widget.reference)
                      : favorite.add(widget.reference);
                  currentUserDocument!.reference
                      .update({'favoriteReference': favorite});
                },
                child: Icon(
                  favorite.contains(widget.reference)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 28,
                  color: AppColor.textColor,
                ),
              ),
            );
          }
          else{
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.favorite_border,
                size: 28,
                color: AppColor.textColor,
              ),
            );
          }
        }
    );
  }
}
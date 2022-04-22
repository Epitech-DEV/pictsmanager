
import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';

class Picture extends StatelessWidget {
  const Picture({ 
    required this.data,
    Key? key 
  }) : super(key: key);

  final PictureData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Image.network(
        data.url,
        fit: BoxFit.cover,
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/views/picture.dart';

class Picture extends StatelessWidget {
  const Picture({ 
    required this.data,
    Key? key 
  }) : super(key: key);

  final PictureData data;

  void viewImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PictureView(
          data: data
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewImage(context);
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: CachedNetworkImage(
            imageUrl: data.url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Container(
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
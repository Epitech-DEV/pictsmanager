
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';

class PictureView extends StatelessWidget {
  const PictureView({ 
    required this.data,
    Key? key 
  }) : super(key: key);

  final PictureData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Todo : share image
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Todo : edit image
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Todo : delete image
            },
          ),
        ],
      ),
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: InteractiveViewer(
          child: Center(
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
      )
    );
  }
}
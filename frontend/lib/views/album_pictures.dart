
import 'package:flutter/material.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/models/album.dart';

class AlbumPicturesView extends StatelessWidget {
  const AlbumPicturesView({
    required this.album,
    Key? key
  }) : super(key: key);

  final AlbumData album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.pictures.length.toString() + ' Photo(s) - ' + album.name),
      ),
      body: PictureGroupList(
        data: album.pictures,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          // TODO : take a new picture
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
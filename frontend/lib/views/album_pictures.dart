
import 'package:flutter/material.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/states/library_collection.dart';

class AlbumPicturesView extends StatefulWidget {
  const AlbumPicturesView({
    required this.album,
    Key? key
  }) : super(key: key);

  final AlbumData album;

  @override
  State<AlbumPicturesView> createState() => _AlbumPicturesViewState();
}

class _AlbumPicturesViewState extends State<AlbumPicturesView> {
  late final AlbumService _albumService;

  @override
  void initState() {
    super.initState();
    _albumService = AlbumService.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.pictures.length.toString() + ' Photo(s) - ' + widget.album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete Album'),
                content: const Text('Are you sure you want to delete this album?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _albumService.delete(widget.album.id!);
                      LibraryCollectionController.instance.reload();
                      Navigator.pop(context, 'Delete');
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ).then((value) {
              if (value == 'Delete') {
                Navigator.pop(context);
              }
            }),
          ),
        ],
      ),
      body: PictureGroupList(
        data: widget.album.pictures,
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
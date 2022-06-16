
import 'package:flutter/material.dart';
import 'package:frontend/components/delete_dialog_box.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/error.dart';
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
              builder: (BuildContext context) => DeleteDialogBox(
                title: "Delete Album", 
                content: "Are you sure you want to delete this album?", 
                onDelete: onDelete
              )
            ).then((value) {
              if (value == 'Delete') {
                LibraryCollectionController.instance.reload();
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

  Future<bool> onDelete() async {
    try {
      await _albumService.delete(widget.album.id!);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar = const SnackBar(content: Text('Failed to create album'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }
}
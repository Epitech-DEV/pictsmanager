import 'package:flutter/material.dart';
import 'package:frontend/components/delete_dialog_box.dart';
import 'package:frontend/components/picture_group_list.dart';
import 'package:frontend/components/username_dialog_box.dart';
import 'package:frontend/models/album.dart';
import 'package:frontend/services/albums.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/states/library_collection.dart';

class AlbumPicturesView extends StatefulWidget {
  const AlbumPicturesView({required this.album, Key? key}) : super(key: key);

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
        title: Text(widget.album.pictures.length.toString() +
            ' Photo(s) - ' +
            widget.album.name),
        actions: [
          PopupMenuButton<String>(
            child: const Icon(Icons.share),
            onSelected: (String action) {
              if (action == 'unshare') {
                showDialog<String>(
                  context: context, 
                  builder: (BuildContext context) => UsernameDialogBox(
                    title: "Unshare Ablum",
                    content: "Enter the username of the person you want to remove read permission",
                    onComfirm: onUnshare,
                  )
                ).then((value) {
                  if (value == 'Confirm') {
                    Navigator.pop(context);
                  }
                });
              } else if (action == 'share') {
                showDialog<String>(
                  context: context, 
                  builder: (BuildContext context) => UsernameDialogBox(
                    title: "Share Album",
                    content: "Enter the username of the person you want to add read permission",
                    onComfirm: onShare,
                  )
                ).then((value) {
                  if (value == 'Confirm') {
                    Navigator.pop(context);
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "share",
                child: Text("Share Album"),
              ),
              const PopupMenuItem<String>(
                value: "unshare",
                child: Text("Unshare Album"),              
              )
            ]
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => DeleteDialogBox(
                    title: "Delete Album",
                    content: "Are you sure you want to delete this album?",
                    onDelete: onDelete)).then((value) {
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> onShare(String username) async {
    try {
      await _albumService.shareAlbum(username);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar = const SnackBar(content: Text('Failed to share album'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }

  Future<bool> onUnshare(String username) async {
    try {
      await _albumService.unshareAlbum(username);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar = const SnackBar(content: Text('Failed to unshare album'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }

  Future<bool> onDelete() async {
    try {
      await _albumService.delete(widget.album.id!);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar =
          SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar =
          const SnackBar(content: Text('Failed to create album'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }
}

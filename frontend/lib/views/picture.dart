import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend/components/delete_dialog_box.dart';
import 'package:frontend/components/username_dialog_box.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/services/pictures.dart';
import 'package:frontend/shared/error.dart';

class PictureView extends StatefulWidget {
  const PictureView({required this.data, required this.image, Key? key})
      : super(key: key);

  final PictureData data;
  final List<int>? image;

  @override
  State<PictureView> createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  late final PictureService _pictureService;

  @override
  void initState() {
    super.initState();
    _pictureService = PictureService.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.name),
        actions: [
          PopupMenuButton<String>(
            child: const Icon(Icons.share),
            onSelected: (String action) {
              if (action == 'unshare') {
                showDialog<String>(
                  context: context, 
                  builder: (BuildContext context) => UsernameDialogBox(
                    title: "Unshare Picture",
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
                    title: "Share Picture",
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
                child: Text("Share Picture"),
              ),
              const PopupMenuItem<String>(
                value: "unshare",
                child: Text("Unshare Picture"),              
              )
            ]
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => DeleteDialogBox(
                  title: "Delete picture",
                  content: "Are you sure you want to delete this picture?",
                  onDelete: onDelete),
            ).then(
              (value) {
                if (value == 'Delete') {
                  Navigator.pop(context);
                }
              },
            ),
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
            child: Image.memory(
              Uint8List.fromList(widget.image!),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onShare(String username) async {
    try {
      await _pictureService.sharePicture(username);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar = const SnackBar(content: Text('Failed to share picture'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }

  Future<bool> onUnshare(String username) async {
    try {
      await _pictureService.unsharePicture(username);
      return true;
    } on ApiError catch (error) {
      SnackBar snackBar = SnackBar(content: Text("${error.statusCode}: ${error.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (_) {
      SnackBar snackBar = const SnackBar(content: Text('Failed to unshare picture'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return false;
  }

  Future<bool> onDelete() async {
    try {
      await _pictureService.deletePicture(widget.data.id!);
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

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/delete_dialog_box.dart';
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Todo : share image
            },
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
